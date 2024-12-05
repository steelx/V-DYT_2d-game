event_inherited();

#region SHADOW BUFFER

	var _path = shadow_path,
		_points = path_get_number(shadow_path),
		_vx = array_create(_points),
		_vy = array_create(_points),
		_x_off = sprite_get_xoffset(sprite_index),
		_y_off = sprite_get_yoffset(sprite_index);
	
		for (var _n = 0; _n < _points; _n++)
		{
			_vx[_n] = path_get_point_x(_path, _n) - _x_off;
			_vy[_n] = path_get_point_y(_path, _n) - _y_off;
		}

	verts_x = _vx;
	verts_y = _vy;

	function add_shadow(_buff)
	{
		var _cos_x = dcos(image_angle), _cos_y = _cos_x * image_yscale,
			_sin_x = dsin(image_angle), _sin_y = _sin_x * image_yscale,
			_length = array_length(verts_x),
			_x2 = verts_x[_length - 1],
			_y2 = verts_y[_length - 1],
			_depth = shadow_depth, _mag = shadow_mag_depth;
		
		_cos_x *= image_xscale;
		_sin_x *= image_xscale;
		
		var _x1 = x + _cos_x * _x2 + _sin_y * _y2,
			_y1 = y - _sin_x * _x2 + _cos_y * _y2;
		
		for (var _n = 0; _n < _length; _n++)
		{
			_x2 = x + _cos_x * verts_x[_n] + _sin_y * verts_y[_n];
			_y2 = y - _sin_x * verts_x[_n] + _cos_y * verts_y[_n];
		
			buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
			_x1 = _x2;
			_y1 = _y2;
		}
	}

#endregion

#region VERTEX BUFFERS

	var _poly   = polygon_path,
		_count  = path_get_number(_poly),
		_verts  = array_create(_count),
		
		// Sprite bounds in path room used to find relative UV position
		_width  = sprite_get_width(sprite_index),
		_height = sprite_get_height(sprite_index),
		
		// Values to transform vertex
		_cos_x = dcos(image_angle), 
		_cos_y = _cos_x * image_yscale,
		_sin_x = dsin(image_angle), 
		_sin_y = _sin_x * image_yscale,
		_px, _py, _tx, _ty;
		
	_cos_x *= image_xscale;
	_sin_x *= image_xscale;
		
	// Process path points
	for (var _p = 0; _p < _count; _p++)
	{
		// Exact xy defined in path room
		_px = path_get_point_x(_poly, _p);
		_py = path_get_point_y(_poly, _p);
		
		// Transformed xy
		_tx = _px - _x_off;
		_ty = _py - _y_off;
			
		_verts[_p] = 
		[
			// xy normalized to local space
			x + _cos_x * _tx + _sin_y * _ty,
			y - _sin_x * _tx + _cos_y * _ty,
			
			// uv position in sprite space
			lerp_inverse(0, _width, _px),
			lerp_inverse(0, _height, _py)
		];
				
	}
				  // Same as passthrough format
				  vertex_format_begin();
				  vertex_format_add_position_3d();
				  vertex_format_add_color();
				  vertex_format_add_texcoord();
	var _format = vertex_format_end();

	vertex_buffer_albedo   = vertex_create_texture_buffer(_format, _verts, image_blend, image_alpha, sprite_index, 0);
	vertex_buffer_material = vertex_create_texture_buffer(_format, _verts, material, shadow_depth, material_map, 0);
	vertex_buffer_normal   = vertex_create_texture_buffer(_format, _verts, normal, LE_NORMAL_ANGLE, normal_map, 0);
	vertex_format = _format;
	
	tex_albedo   = sprite_get_texture(sprite_index, 0);
	tex_material = sprite_get_texture(material_map, 0);
	tex_normal   = sprite_get_texture(normal_map, 0);
	
#endregion