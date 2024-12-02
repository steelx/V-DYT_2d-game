global.le_object_occlusion = object_occlusion;

force_es = (os_type == os_ios || os_type == os_tvos || os_type == os_android || os_type == os_unknown || os_type == os_switch);
if (force_es)
{
	shadow_type = LE_SHADOW_TYPE_HARD;	
}

precomposite_type = shadow_type + 2;

layer_is_set = false;

render_scale      = 1;
surface_width     = -1;
surface_height    = -1;
surface_lights    = noone;
surface_shadow    = noone;
surface_normal    = noone;
surface_material  = noone;
surface_bloom     = noone;
surface_depth     = noone;
shadow_atlas      = noone;
shadow_atlas_blur = noone;
buffer_lights     = noone;

surface_matrix    = matrix_build_identity();
shadow_matrix     = matrix_build_identity();
matrix_reset      = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);

alarm[10] = enable_lighting_buffer;

view_x       = 0;
view_y       = 0;
lights_array = [0];
shadow_grid  = noone;
loaded       = false;

// Ambient lighting normal
var _l = dcos(ambient_elevation);
ambient_x = dcos(ambient_direction) * -_l;
ambient_y = dsin(ambient_direction) * _l;
ambient_z = dsin(ambient_elevation);

event_user(LE_SHADER_SETUP); // Shader Setup
event_user(LE_SHADOW_ATLAS); // Shadow Atlas

				vertex_format_begin();
				vertex_format_add_position_3d();
vertex_format = vertex_format_end();
vertex_buffer = noone;
ambient_color = color_strip_alpha(ambient_color);

var _vbuff = vertex_create_buffer();
vertex_begin(_vbuff, vertex_format);
	vertex_position_3d(_vbuff, 0, 0, 0);
	vertex_position_3d(_vbuff, 0, 0, 0);
	vertex_position_3d(_vbuff, 0, 0, 0);
vertex_end(_vbuff);
vertex_freeze(_vbuff);
vertex_buffer_dummy = _vbuff;

#region FUNCTIONS

	function set_shadow_opacity(_value)
	{
		shadow_opacity = clamp(_value, 0, 1);	
	}
	
	function set_bloom_intensity(_value)
	{
		bloom_intensity = clamp(_value, 0, 0.99);	
	}

	function update_ambient_params()
	{
		var _l = dcos(ambient_elevation);
		
		ambient_x = dcos(ambient_direction) * -_l;
		ambient_y = dsin(ambient_direction) * _l;
		ambient_z = dsin(ambient_elevation);
	}
	
	function set_ambient_direction(_direction)
	{
		ambient_direction = angle_normalize(_direction);
		update_ambient_params();
	}
	
	function increment_ambient_direction(_increment)
	{
		set_ambient_direction(ambient_direction + _increment);	
	}
	
	function set_ambient_elevation(_elevation)
	{
		ambient_elevation = (_elevation mod 90 + 90) mod 90;
		update_ambient_params();
	}
	
	function increment_ambient_elevation(_increment)
	{
		set_ambient_elevation(ambient_elevation + _increment);	
	}
		
	function set_bloom(_bloom)
	{
		bloom_amount = round(clamp(_bloom, 1, LE_BLOOM_MAX));
	}
	
	function set_shadow_blur_amount(_value)
	{
		shadow_blur_amount = clamp(_value, 1, LE_BLOOM_MAX);
	}

	function increment_bloom(_amount)
	{
		bloom_amount = round(clamp(bloom_amount + _amount, 1, LE_BLOOM_MAX));	
	}

	function set_ambient_intensity(_intensity)
	{
		ambient_intensity = clamp(_intensity, 0, 1);
	}

	function increment_ambient_intensity(_amount)
	{
		ambient_intensity = clamp(ambient_intensity + _amount, 0, 1);
	}

	function set_dof_far(_value)
	{
		dof_far = clamp(_value, 0, dof_near);
	}
	
	function set_dof_near(_value)
	{
		dof_near = clamp(_value, dof_far, 1);
	}

	function set_ambient_color(_color)
	{
		ambient_color = color_strip_alpha(_color);
	}

	function set_ambient_color_rgb(_r, _g, _b)
	{
		ambient_color = make_color_rgb(_r, _g, _b);	
	}

	function increment_render_resolution(_value)
	{
		set_render_resolution(render_scale + _value);
	}

	function set_render_resolution(_factor)
	{
		_factor = clamp(_factor, 0.25, 3);
		
		var _width  = window_get_width(),
			_height = window_get_height();
		
		if (_width > _height)
		{
			var _aspect = _height/_width;
			_width  = LE_RENDER_WIDTH * _factor;
			_height = _width * _aspect;
		}
		else 
		{
			var _aspect = _width/_height;
			_height *= LE_RENDER_HEIGHT * _factor;
			_width = _height * _aspect;
		}
		
		if (enable_lighting_buffer)
		{
			var _old_buff = buffer_lights;
			buffer_lights = buffer_create(_width * _height * 4, buffer_fixed, 1);
			buffer_delete(_old_buff);
		}
		
		surface_resize(application_surface, _width, _height);	
		free_lighting_surfaces();
		render_scale = _factor;
	}
	
	function free_lighting_surfaces()
	{
		if surface_exists(surface_lights)    surface_free(surface_lights);
		if surface_exists(surface_shadow)    surface_free(surface_shadow);
		if surface_exists(surface_normal)    surface_free(surface_normal);
		if surface_exists(surface_material)  surface_free(surface_material);
		if surface_exists(surface_bloom)     surface_free(surface_bloom);
		if surface_exists(surface_depth)     surface_free(surface_depth);
		if surface_exists(shadow_atlas)      surface_free(shadow_atlas);
		if surface_exists(shadow_atlas_blur) surface_free(shadow_atlas_blur);
				
		event_user(LE_SHADOW_ATLAS); // Update shadow atlas parameters
	}
	
	function set_shadow_type(_type)
	{
		if (_type == LE_SHADOW_TYPE_HARD || force_es)
		{
			shadow_type = LE_SHADOW_TYPE_HARD;
			if surface_exists(shadow_atlas) surface_free(shadow_atlas);
		}
		else if (_type == LE_SHADOW_TYPE_SOFT)
		{
			shadow_type = LE_SHADOW_TYPE_SOFT;
			if surface_exists(surface_shadow) surface_free(surface_shadow);
			event_user(LE_SHADOW_ATLAS);
		}
		else 
			slog("Invalide shadow type");
			
		precomposite_type = shadow_type + 2;
	}
	
	function set_shadow_atlas_size(_size)
	{
		shadow_atlas_size = _size;
		event_user(LE_SHADOW_ATLAS);
	}
	
	function set_shadow_map_size(_size)
	{
		shadow_map_size = _size;
		event_user(LE_SHADOW_ATLAS);
	}
		
	function draw_shadow_grid()
	{
		var _grid = shadow_grid,
			_x = x div shadow_area_width,
			_y = y div shadow_area_height;
				
		draw_set_alpha(0.2);
				
		for (var _c = 0, _cols = ds_grid_width(_grid); _c < _cols; _c++)
			for (var _r = 0, _rows = ds_grid_height(_grid); _r < _rows; _r++)
				_grid[# _c, _r].draw(c_blue, c_yellow, !(_x == _c && _y == _r));
			
		draw_set_alpha(1);
	}
	
	function get_shadow_area(_x, _y)
	{
		return ds_grid_get(shadow_grid, 
			clamp(_x div shadow_area_width, 0, shadow_divisions_x - 1), 
			clamp(_y div shadow_area_height, 0, shadow_divisions_y - 1));					  
	}
	
	function init_shadow_grid()
	{
		var _width = room_width / shadow_divisions_x,
			_height = room_height / shadow_divisions_y,
			_x_offset = _width * 0.5,
			_y_offset = _height * 0.5,
			_grid = ds_grid_create(shadow_divisions_x, shadow_divisions_y);
		
		for (var _column = 0, _x = 0; _column < shadow_divisions_x; _column++)
		{
			for (var _row = 0, _y = 0; _row < shadow_divisions_y; _row++)
			{
				_grid[# _column, _row] = new shadow_area(_x, _y, _width, _height, _x_offset, _y_offset);
				_y += _height;
			}
			_x += _width;
		}

		shadow_grid = _grid;
		shadow_area_width = _width;
		shadow_area_height = _height;	
		slog("Shadow grid initialized");
	}
	
#endregion