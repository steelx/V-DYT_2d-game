/*
	Solution for creating precise sprite outlines.  Each sub-image outline is stored in an array as x/y points
	in order and each sprite is assigned an array that holds each of those.  A static map is created called
	__sprite_outline_map which holds each sprites information.  This ensures a sprite only has an outline generated
	one time. 
	
	Outlines are generated in local space and after retrieving a given sprite outline the points should be copied
	to a new array or buffer while applying the instances transforms.
	
	Sprites will use default parameters when generating an outline, or by use of tagging a sprite can have its
	values defined.  Use the following tags followed by an underscore and value, such as min_alpha_127 would
	set the minimum alpha threshold at 127.

	Tags that will be parsed for:
		precision  - Changes how many rays are cast to detect sprite edges, range of 0 - 100 (normalized to 0 - 1)
		min_alpha  - The minimum alpha value for edge detection, range 0 - 255
		angle_diff - Angle to check when pruning extra points, range 0 - 180
		step_dist  - Distance in pixels before checking to prune, range >= 1
		
	Example tags: precision_100, min_alpha_230, angle_diff_25, step_dist_10
	
	** Precision and minimum alpha are best left with the default values and no tag is needed.  
	** Angle difference and step distance will vary a lot between pixel art and larger HD sprites.
	
	This solution works well with convex shapes but concave will often be not accurate with the current algorithm.
	The shadow path option is current best for concave shapes, but in the future the algorithm used in this file
	will be changed to a direct trace around the edge using a shader.
*/


/// @function					get_sprite_outline_map()
/// @description                Get the static map holding sprite outline arrays
function get_sprite_outline_map()
{
	static __sprite_outline_map = ds_map_create();
	return __sprite_outline_map;
}


/// @function					get_sprite_outline(_sprite, _precision, _min_alpha)
/// @param {index} _sprite		The sprite index to use
/// @description                Creats an array filled with point list arrays that outline a sprite
function get_sprite_outline(_sprite)
{	
	var _map = get_sprite_outline_map(),
		_outline = _map[? _sprite];
		
	if (_outline == undefined)
	{
		var _precision = 1, _min_alpha = 230, _angle_diff = 35, _step_dist = 10,
			_tags = asset_get_tags(_sprite, asset_sprite);
		
		for (var _t = 0, _len = array_length(_tags); _t < _len; _t++)
		{
			var _str = _tags[_t];

			switch (string_letters(_str))
			{
				case "precision" : _precision  = real(string_digits(_str)) * 0.01; break;
				case "minalpha"  : _min_alpha  = real(string_digits(_str)); break;
				case "anglediff" : _angle_diff = real(string_digits(_str)); break;
				case "stepdist"  : _step_dist  = real(string_digits(_str)); break;
			}
		}
		
		_outline = create_sprite_outline(_sprite, _precision, _min_alpha, _angle_diff, _step_dist); 
		_map[? _sprite] = _outline;
	}

	return _outline;	
}


/// @function					create_sprite_outline(_sprite, _precision = 1, _min_alpha = 230, _angle_diff = 35, _step_dist = 10)
/// @param {index} _sprite		The sprite index to use
/// @param {real} _precision	The precision to use for outline in the range (0 - 1)
/// @param {integer} _min_alpha The alpha threshold for testing sprite edge
/// @param {real} _angle_diff   The angle difference used for pruning points
/// @param {real} _step_dist	The distance between pruning points
/// @description                Creats an array of points which outline a sprite
function create_sprite_outline(_sprite, _precision = 1, _min_alpha = 230, _angle_diff = 35, _step_dist = 10)
{
	#macro SPR_OUTLINE_2PI     6.283185307179586476925286766559
	#macro SPR_OUTLINE_RAD_MIN 0.01745329251994329576923690768489
	#macro SPR_OUTLINE_RAD_MAX 0.39269908169872415480783042290994
	
	var _count    = sprite_get_number(_sprite),
		_outlines = array_create(_count),
		_width    = sprite_get_width(_sprite),
		_height   = sprite_get_height(_sprite),
		_origin_x = sprite_get_xoffset(_sprite),
		_origin_y = sprite_get_yoffset(_sprite),
		_surface  = surface_create(_width, _height),
		_buffer	  = buffer_create(((_width * _height) << 2), buffer_fast, 1);
		
		_precision = lerp(SPR_OUTLINE_RAD_MIN,SPR_OUTLINE_RAD_MAX, 1.0 - _precision);

	// Iterate through all sub-images of the sprite
	for (var _s = 0; _s < _count; _s++)
	{
		// Convert current sub-image to buffer
		surface_set_target(_surface);
			draw_clear_alpha(c_black, 0);
			draw_sprite(_sprite, _s, _origin_x, _origin_y); 
		surface_reset_target();	
		buffer_get_surface(_buffer, _surface, 0)
		
		// New array of points
		var _points = [],
			_rx, _ry, _buffer_x, _buffer_y;

	    // Raycast 
	    for (var _theta = 0; _theta < SPR_OUTLINE_2PI; _theta += _precision)
	    {
			var _cos_t   = cos(_theta), 
				_sin_t   = -sin(_theta),
				_point_x = _cos_t,
				_point_y = _sin_t,
				_ray_length = 2;
	  
	        // Cast a ray until out of bounds
	        while(_ray_length)
	        {
				_rx = _cos_t * _ray_length;
				_ry = _sin_t * _ray_length++;
				_buffer_x = floor(_origin_x + _rx);
				_buffer_y = floor(_origin_y + _ry);
	
				// Check in bounds
	            if (_buffer_x >= _width || _buffer_x <= 0 || _buffer_y >= _height || _buffer_y <= 0)
					_ray_length = -1; 
				else if (buffer_peek(_buffer, (_buffer_x + _buffer_y * _width << 2) + 3, buffer_u8) > _min_alpha)
	            {
	                _point_x = _rx;
	                _point_y = _ry; 
	            }
	        }
			
			array_push(_points, _point_x, _point_y);
	    }	
		_outlines[_s] = prune_shadow_outline(_points, _angle_diff, _step_dist);
	}
	
	surface_free(_surface);
	buffer_delete(_buffer);
	
	return _outlines;
}

/// @function					prune_shadow_outline(_points, _angle_diff, _step_dist)
/// @param {index} _points		The sprite index to use
/// @param {real} _angle_diff   The angle difference used for pruning points
/// @param {real} _step_dist	The distance between pruning points
/// @description                Creats an array of points which outline a sprite
function prune_shadow_outline(_points, _angle_diff, _step_dist)
{	
	// Loops around the sprite outline removing points based on angle difference and distance
	// This can remove hundreds of redundant points without any noticable difference in precision
	
	var _len = array_length(_points),
		_px  = _points[_len - 2],
		_py  = _points[_len - 1],
		_tx  = _points[0],
		_ty  = _points[1],
		_dir = point_direction(_px, _py, _tx, _ty),
		_pruned_points = [_px, _py],
		_dist = 0, _ndir = 0, _nx = 0, _ny = 0, _p = 2;
			
	while (_p < _len)
	{
		_nx = _points[_p++];
		_ny = _points[_p++];
		
		_dist = point_distance(_px, _py, _nx, _ny);
		_ndir = point_direction(_tx, _ty, _nx, _ny);
			
		if (_dist > _step_dist && abs(angle_difference(_dir, _ndir)) >= _angle_diff)
		{			
			array_push(_pruned_points, _tx, _ty);
			_px = _tx;
			_py = _ty;
			_tx = _nx;
			_ty = _ny;
			_dir = point_direction(_px, _py, _tx, _ty);
		}
		else
		{
			_tx = _nx;
			_ty = _ny;	
		}
	}	
	
	// If needing to debug and see the difference prunning made
	//show_debug_message("Total points: " + string(_len >> 1) + " After pruning: " + string(array_length(_pruned_points) >> 1));
	
	return _pruned_points;
}

/// @function					draw_sprite_outline(_outline, _x, _y, _index, _color)
/// @param {index} _outline		The array of points to use
/// @param {real} _x			The x position to draw from
/// @param {real} _y			The y position to draw from
/// @param {integer} _color		The color to use
/// @description				Draws the lines which connect each point in a sprite outline
function draw_sprite_outline(_outline, _x, _y, _index, _color)
{
	var _points = _outline[floor(_index)],
		_len = array_length(_points),
		_px = _x + _points[_len - 2],
		_py = _y + _points[_len - 1],
		_i = 0;
		
	while (_i < _len)
	{
		var _nx = _x + _points[_i++],
			_ny = _y + _points[_i++];
		
		draw_line_color(_px, _py, _nx, _ny, _color, _color);
		_px = _nx;
		_py = _ny;
	}
}
