// Resolution settings
#macro LE_RENDER_WIDTH 1280
#macro LE_RENDER_HEIGHT 720
#macro LE_GUI_SET_WIDTH 1920
#macro LE_GUI_SET_HEIGHT 1080
#macro LE_GUI_WIDTH  (sprite_get_width(spr_gui_guide))
#macro LE_GUI_HEIGHT (sprite_get_height(spr_gui_guide))

// Light engine constants
#macro LE_LIGHT_MAX_RANGE      16000  // default 16000
#macro LE_SHADER_SETUP	       0
#macro LE_SHADOW_TYPE_HARD     1
#macro LE_SHADOW_TYPE_SOFT     2
#macro LE_SHADOW_ATLAS		   5 
#macro LE_DRAW_MATERIAL        14
#macro LE_DRAW_NORMAL          15
#macro LE_BUFF_SIZE_EDGE       72
#macro LE_NORMAL_ANGLE         ((image_angle mod 360 + 360) mod 360) * 0.00277777777777777777777777777778
#macro LE_PARAMS_LIGHT         8
#macro LE_PARAMS_SOFT_SHADOW   12
#macro LE_BLOOM_MAX            10
#macro LE_SHADOW_BLUR_MAX      10

// Math Constants
#macro LE_2PI   6.283185307179586476925286766559

// Tick rate
#macro MICRO_SEC 0.000001
#macro TICK delta_time * MICRO_SEC

function lerp_inverse(_min, _max, _val)
{
	return (_val - _min) / (_max - _min);	
}

function degtorad_normalize(_angle)
{
	return degtorad((_angle mod 360 + 360) mod 360);
}

function angle_normalize(_angle)
{
	return (_angle mod 360 + 360) mod 360;
}

function smooth_step(_a, _b, _x)
{
	var _t = clamp((_x - _a) / (_b - _a), 0.0, 1.0);
	return (_t * _t * (3.0 - 2.0 * _t));
}

function range_wrap(_value, _increment, _max)
{
	return (_max + _value + _increment) mod _max;
}

function make_color_random(_min, _max)
{
	return make_color_rgb(irandom_range(_min, _max), irandom_range(_min, _max), irandom_range(_min, _max));	
}

function color_strip_alpha(_col)
{
	return _col &~ 4278190080; // Bitwise NOT -> 11111111 00000000 00000000 00000000
}

function color_make_normal_depth(_has_normal_map, _emissive, _depth)
{
	_depth += 16000;
	return make_color_rgb(clamp(_emissive * 255, 0, 255), ((_depth & 32512) >> 8) + 128 * _has_normal_map, _depth & 255);
}

function color_make_material_depth(_metallic, _roughness, _depth)
{
	_depth += 16000;
	return make_color_rgb(((_metallic * 15) << 4) + _roughness * 15, (_depth & 32512) >> 8, _depth & 255);
}

function part_emissive_alpha(_emissive, _alpha)
{
	// Stores emissive and alpha values in same float
	// Emissive should be in increments of 0.1

	// Alpha values can interpolate, but emissive needs
	// to be the same for the lifetime of a particle type
	// due to interpolation messing up the encoded values
	
	return _emissive + _alpha * 0.01;
}

function slog() 
{
	var _msg = "** Log: ", _arg;
	for (var _i = 0; _i < argument_count; _i++)
	{
		_arg = argument[_i];
		if is_string(_arg) { _msg += _arg+" "; continue; }
	    _msg += string(_arg)+" ";
	}  
	show_debug_message(_msg);
}

function screenshot_dated(_label)
{
	screen_save(_label+"_"+string(current_month)+"-"
		+ string(current_day)+"_"
		+ string(current_hour)+"-" 
		+ string(current_minute)+"-" 
		+ string(current_second)+".png");	
}

function surface_save_fullalpha(_surf, _label)
{
	// Helps with debugging surfaces with zero alpha
	
	if !surface_exists(_surf) return;
	
	var _save_surf = surface_create(surface_get_width(_surf), surface_get_height(_surf)),
		_mode = gpu_get_blendmode();
	
	gpu_set_blendmode_ext_sepalpha(bm_zero, bm_src_color, bm_zero, bm_one);
	surface_set_target(_save_surf);
		draw_clear_alpha(c_white, 1);
		draw_surface(_surf, 0, 0);
	surface_reset_target();
	gpu_set_blendmode(_mode);
	surface_save(_save_surf, _label);
	surface_free(_save_surf);
}

function surface_save_red_channel(_surf, _label)
{
	// Helps with debugging surfaces with zero alpha
	
	if !surface_exists(_surf) return;
	
	var _save_surf = surface_create(surface_get_width(_surf), surface_get_height(_surf)),
		_mode = gpu_get_blendmode();
	
	gpu_set_blendmode_ext_sepalpha(bm_zero, bm_src_color, bm_zero, bm_one);
	surface_set_target(_save_surf);
		draw_clear_alpha(c_white, 1);
		draw_surface_ext(_surf, 0, 0, 1, 1, 0, c_red, 1);
	surface_reset_target();
	gpu_set_blendmode(_mode);
	surface_save(_save_surf, _label);
	surface_free(_save_surf);
}

function print_mat4x4(_mat, _label)
{
	show_debug_message(_label);
	for (var _r = 0; _r < 4; _r++)
	{
		var _str = "";
		for (var _c = 0; _c < 4; _c++)
			_str += string(_mat[_r * 4 + _c]) + " ";
		show_debug_message(_str);
	}
	show_debug_message(" ");
}

function buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag_depth)
{
	// Tri 1
	buffer_write(_buff, buffer_f32, _x1);
	buffer_write(_buff, buffer_f32, _y1);
	buffer_write(_buff, buffer_f32, _depth);
		
	buffer_write(_buff, buffer_f32, _x2);
	buffer_write(_buff, buffer_f32, _y2);
	buffer_write(_buff, buffer_f32, _depth);
	
	buffer_write(_buff, buffer_f32, _x1);
	buffer_write(_buff, buffer_f32, _y1);
	buffer_write(_buff, buffer_f32, _mag_depth);
	
	// Tri 2
	buffer_write(_buff, buffer_f32, _x1);
	buffer_write(_buff, buffer_f32, _y1);
	buffer_write(_buff, buffer_f32, _mag_depth);
	
	buffer_write(_buff, buffer_f32, _x2);
	buffer_write(_buff, buffer_f32, _y2);
	buffer_write(_buff, buffer_f32, _depth);
	
	buffer_write(_buff, buffer_f32, _x2);
	buffer_write(_buff, buffer_f32, _y2);
	buffer_write(_buff, buffer_f32, _mag_depth);	
}

function vertex_create_texture_buffer(_format, _verts, _blend, _alpha, _sprite, _index)
{
	var _size = array_length(_verts),
		_buff = vertex_create_buffer(),
		_uvs  = sprite_get_uvs(_sprite, _index),
		_left = _uvs[0], _right  = _uvs[2], 
		_top  = _uvs[1], _bottom = _uvs[3],
		_v;
		
	vertex_begin(_buff, _format);

	for (var _i = 0; _i < _size; _i++)
	{	
		_v = _verts[_i];
				
		vertex_position_3d(_buff, _v[0], _v[1], 0);
		vertex_color(_buff, _blend, _alpha);
		vertex_texcoord(_buff, lerp(_left, _right, _v[2]), lerp(_top, _bottom, _v[3]));				
	}
		
	vertex_end(_buff);
	vertex_freeze(_buff);
	return _buff
}

function shadow_area(_x, _y, _width, _height, _x_offset, _y_offset) constructor
{
	// Defines an area for shadow caster objects and buffers static ones
	
	x = _x;
	y = _y;
	x2 = _x + _width;
	y2 = _y + _height;
	
	left   = _x - _x_offset;
	right  = x2 + _x_offset;
	top    = _y - _y_offset;
	bottom = y2 + _y_offset;
		
	var _list = ds_list_create(),
		_size = collision_rectangle_list(left, top, right, bottom, __shadow_static, false, true, _list, false),
		_buff = buffer_create(_size * LE_BUFF_SIZE_EDGE, buffer_grow, 4);
				
	for (var _i = 0; _i < _size; _i++)
		_list[| _i].add_shadow(_buff);
	
	buffer = _buff;
	buffer_size = buffer_get_size(_buff);
		
	ds_list_destroy(_list);
	
	static get_vertex_buffer = function(_v_format)
	{
		// Add static buffer to dynamic shadow casters as a vertex buffer
		
		var _list = ds_list_create(),
			_size = collision_rectangle_list(left, top, right, bottom, __shadow_dynamic, false, true, _list, false),
			_buff = buffer,
			_buff_size = buffer_size + _size * LE_BUFF_SIZE_EDGE;
			
		if (_buff_size == 0) 
		{
			ds_list_destroy(_list);
			return noone;
		}
		
		buffer_resize(_buff, _buff_size);
		buffer_seek(_buff, buffer_seek_start, buffer_size);
			
		for (var _i = 0; _i < _size; _i++)		
			_list[| _i].add_shadow(_buff);
				
		ds_list_destroy(_list);
		
		return vertex_create_buffer_from_buffer(_buff, _v_format);
	}
		
	static destroy = function() { if (buffer_exists(buffer)) buffer_delete(buffer); }
		
	static draw = function(_c1, _c2, _outline)
	{
		if (!_outline) draw_rectangle_color(left, top, right, bottom, _c2, _c2, _c2, _c2, _outline);
		draw_rectangle_color(x, y, x2, y2, _c1, _c1, _c1, _c1, _outline);
	}
	
}

function init_window(_fullscreen)
{
	var _width  = display_get_width(),
		_height = display_get_height();
	
	window_set_size(_width, _height);
	window_set_fullscreen(_fullscreen);
	
	if (_width > _height)
	{
		var _aspect = _height/_width;
		
		surface_resize(application_surface, LE_RENDER_WIDTH, LE_RENDER_WIDTH * _aspect);
		display_set_gui_size(LE_GUI_SET_WIDTH, LE_GUI_SET_WIDTH * _aspect);
	}
	else 
	{
		var _aspect = _width/_height;
	
		surface_resize(application_surface, LE_RENDER_HEIGHT * _aspect, LE_RENDER_HEIGHT);
		display_set_gui_size(LE_GUI_SET_HEIGHT * _aspect, LE_GUI_SET_HEIGHT);
	}
		
}

function mouse_x_gui()
{
	return window_mouse_get_x() / window_get_width() * display_get_gui_width();
}

function mouse_y_gui()
{
	return window_mouse_get_y() / window_get_height() * display_get_gui_height();
}

function lighting_getpixel_value_buffered(_x, _y)
{
	var _value = 0;
	
	with (light_engine)
	{
		if (buffer_exists(buffer_lights))
		{
			var _cam		    = camera_get_active(),
				_view_width	    = camera_get_view_width(_cam),
				_view_height    = camera_get_view_height(_cam),
				_dist           = point_distance(_x, _y, view_x, view_y),
				_theta          = point_direction(_x, _y, view_x, view_y) - image_angle;
	
			_x = floor(surface_width * (-_dist * dcos(_theta) / _view_width));
			_y = floor(surface_height * (_dist * dsin(_theta) / _view_height));
		
			var _rgba = buffer_peek(buffer_lights, (_x + _y * surface_width << 2), buffer_u32);
			if(is_int64(_rgba))
				_value = colour_get_value(_rgba & 16777215) * 0.0039215686274509803921568627451;
		}
	}
	
	return _value;
}

function lighting_getpixel_value(_x, _y)
{
	var _value = 0;
	
	with (light_engine)
	{
		if (surface_exists(surface_lights))
		{
			var _cam		    = camera_get_active(),
				_view_width	    = camera_get_view_width(_cam),
				_view_height    = camera_get_view_height(_cam),
				_dist           = point_distance(_x, _y, view_x, view_y),
				_theta          = point_direction(_x, _y, view_x, view_y) - image_angle;
	
			_x = floor(surface_width * (-_dist * dcos(_theta) / _view_width));
			_y = floor(surface_height * (_dist * dsin(_theta) / _view_height));
		
			_value = colour_get_value(surface_getpixel(surface_lights, _x, _y) & 16777215) * 0.0039215686274509803921568627451;
		}
	}
	
	return _value;	
}

function shader_set_occlusion(_enable)
{
	static _u_occlusion = shader_get_uniform(shd_draw_materials_glsl_es, "u_occlusion");
	shader_set_uniform_f(_u_occlusion, _enable);
}

function lighting_set_object_occlusion(_enable)
{
	global.le_object_occlusion = _enable;
}