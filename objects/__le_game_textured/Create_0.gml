event_inherited();

// Rebuild model matrix anytime the object moves, resizes, or rotates
function update_model_matrix()
{
	model_mat = matrix_build(x, y, depth, 0, 0, image_angle, image_xscale, image_yscale, 1);
	
	if (image_angle != image_angle_previous)
	{
		// Normal map vectors must be rotated
		image_angle_previous = image_angle;
		var _new_buff = vertex_create_texture_buffer(vertex_format, verts, normal, LE_NORMAL_ANGLE, normal_map, 0);
		vertex_delete_buffer(vertex_buffer_normal);
		vertex_buffer_normal = _new_buff;
	}
}

#region VERTEX BUFFERS

	// Dynamic object has vertex buffers without any transforms applied
	// When drawing the world matrix will apply any instance transforms
	
	var _poly  = polygon_path,
		_count = path_get_number(_poly),
		_verts = array_create(_count),
		_x_off = sprite_get_xoffset(sprite_index),
		_y_off = sprite_get_yoffset(sprite_index),
		
		// Sprite bounds in path room used to find relative UV position
		_width  = sprite_get_width(sprite_index),
		_height = sprite_get_height(sprite_index),
		_px, _py;
		
	// Process path points
	for (var _p = 0; _p < _count; _p++)
	{
		// Exact xy defined in path room
		_px = path_get_point_x(_poly, _p);
		_py = path_get_point_y(_poly, _p);
		
		_verts[_p] = 
		[
			// xy normalized to local space
			_px - _x_off,
			_py - _y_off,
			
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
	
	verts = _verts;
	image_angle_previous = image_angle;
	
#endregion

update_model_matrix();
world_mat = matrix_get(matrix_world);
world_model_mat = world_mat;