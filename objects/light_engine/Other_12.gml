/// @description Lighting

#region DECLARATIONS

	var _s_width  = surface_width,
		_s_height = surface_height;
	
	surface_depth_disable(true);
		if (!surface_exists(surface_lights))     surface_lights     = surface_create(_s_width, _s_height);
		if (!surface_exists(surface_bloom))      surface_bloom      = surface_create(_s_width, _s_height);
		if (!surface_exists(shadow_atlas))       shadow_atlas       = surface_create(shadow_atlas_width, shadow_atlas_height);
		if (!surface_exists(shadow_atlas_blur))  shadow_atlas_blur  = surface_create(shadow_atlas_width, shadow_atlas_height);
	surface_depth_disable(false);
	if (!surface_exists(surface_normal))   surface_normal   = surface_create(_s_width, _s_height);
	if (!surface_exists(surface_material)) surface_material = surface_create(_s_width, _s_height);
	if (!surface_exists(surface_depth))    surface_depth    = surface_create(_s_width, _s_height, surface_rg8unorm);

	var _angle	      = image_angle, 
		_xscale       = image_xscale,
		_yscale       = image_yscale,
		_view_x       = view_x,
		_view_y       = view_y,
		_depth        = depth,
		_v_buffer     = vertex_buffer,
		
	  	_s_lights     = surface_lights,
		_s_bloom      = surface_bloom,
		_s_norm       = surface_normal,
		_s_atlas      = shadow_atlas,
		_s_atlas_blur = shadow_atlas_blur,

		_u_atlas_tex    = u_atlas_tex_ss,
		_u_atlas_hor    = u_atlas_blur_params_hor,
		_u_atlas_ver    = u_atlas_blur_params_ver,
		_u_blur_hor     = u_blur_horizontal,
		_u_blur_ver     = u_blur_vertical,
		_u_normal_tex   = u_normal_tex_ss,
		_u_material_tex = u_material_tex_ss,
		_u_atlas_pos    = u_atlas_position,	
		_s_depth_hor    = s_atlas_blur_depth_hor,
		_s_depth_ver    = s_atlas_blur_depth_ver,
		
		_t_material   = surface_get_texture(surface_material),
		_t_normal     = surface_get_texture(_s_norm),
		_t_depth	  = surface_get_texture(surface_depth),
		
		_l_arr        = lights_array,
		_light_total  = instance_number(__light),
		_ambient_x    = ambient_x,
		_ambient_y    = ambient_y,
		_ambient_z    = ambient_z,
		_ambient_int  = ambient_intensity,
		_ambient_col  = ambient_color,

		_atlas_param_array = 
		[
			// Textel size
			1.0 / shadow_atlas_width, 
			1.0 / shadow_atlas_height, 
			
			// To go from map UV to the depth texture UV in frag shader
			shadow_map_cols, 
			shadow_map_rows,
			
			// Shadow map size in UV space
			1.0 / shadow_map_cols,
			1.0 / shadow_map_rows
		];
			
	gpu_set_blendmode_ext(bm_one, bm_one);
	surface_set_target_ext(0, _s_lights);
	surface_set_target_ext(1, _s_bloom);
		draw_clear_alpha(c_black, 0);
	surface_reset_target();
		
#endregion

#region DEFERRED LIGHT RENDERING

	for (var _batch = 0; _batch < _light_total; _batch += light_batch_size)
	{				
		var _batch_count = min(light_batch_size, _light_total - _batch),
			_params = _batch_count * LE_PARAMS_LIGHT + LE_PARAMS_SOFT_SHADOW,
			_param_index = LE_PARAMS_SOFT_SHADOW,
			_light_index = -1;
			
		if (array_length(_l_arr) != _params) array_resize(_l_arr, _params);

		_l_arr[0] = _ambient_int;
		_l_arr[1] = _ambient_col; 
		_l_arr[2] = _ambient_x;
		_l_arr[3] = _ambient_y;
		_l_arr[4] = _ambient_z;
		_l_arr[5] = _batch_count;  // Light count for this batch
		_l_arr[6] = shadow_map_rows;
		_l_arr[7] = shadow_map_cols;
		_l_arr[8] = dof_near;
		_l_arr[9] = dof_far;
		_l_arr[10] = 1.0 - bloom_intensity;
		_l_arr[11] = shadow_opacity;
		
		_ambient_int = -1; // Tells shader to only apply ambience in first batch
		
		matrix_set(matrix_world, shadow_matrix);

		surface_set_target(_s_atlas);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendequation(bm_eq_max);
			shader_set(shd_shadow_atlas_glsl_es);
			shader_set_uniform_f(u_atlas_size, shadow_map_width, shadow_map_height,	shadow_map_rows, shadow_map_cols);
			shader_set_uniform_f(u_atlas_cell, shadow_map_cell_x, shadow_map_cell_y);
										
			for (var _li = _batch, _last = _batch + _batch_count; _li < _last; _li++)
			{
				with instance_find(__light, _li)
				{	
					shader_set_uniform_f(_u_atlas_pos, x, y, z_depth, (++_light_index + shadow_hardness_value) * directional);
					vertex_submit(_v_buffer, pr_trianglelist, _t_material);
				
					_l_arr[_param_index++] = x;
					_l_arr[_param_index++] = y;
					_l_arr[_param_index++] = _depth + z;
					_l_arr[_param_index++] = params[e_light.color] * directional;
					_l_arr[_param_index++] = params[e_light.intensity_depth];
					_l_arr[_param_index++] = params[e_light.falloff]; 
					_l_arr[_param_index++] = params[e_light.radius_angle];
					_l_arr[_param_index++] = params[e_light.width_arc];
				}
			}
			gpu_set_blendequation(bm_eq_add);
		surface_reset_target();	

		// Shadow atlas blur
		matrix_set(matrix_world, matrix_reset);
		gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
		for (var _b = 0; _b < shadow_blur_amount; _b++)
		{
			surface_set_target(_s_atlas_blur);
				shader_set(shd_atlas_blur_horizontal_glsl_es);
				texture_set_stage(_s_depth_hor, _t_depth);
				shader_set_uniform_f_array(_u_atlas_hor, _atlas_param_array);
				draw_surface(_s_atlas, 0, 0);
			surface_reset_target();
		
			surface_set_target(_s_atlas);
				shader_set(shd_atlas_blur_vertical_glsl_es);
				texture_set_stage(_s_depth_ver, _t_depth);
				shader_set_uniform_f_array(_u_atlas_ver, _atlas_param_array);
				draw_surface(_s_atlas_blur, 0, 0);
			surface_reset_target();
		}
		shader_reset();
				
		// Render lights in batches which iterate within the shader to massively reduce sample rate
		matrix_set(matrix_world, surface_matrix);
		gpu_set_blendmode_ext(bm_one, bm_one);
		shader_set(shd_light_ss_glsl_es);
		shader_set_uniform_f_array(u_lights_ss, _l_arr);
		texture_set_stage(_u_normal_tex, _t_normal);
		texture_set_stage(_u_material_tex, _t_material);
		texture_set_stage(_u_atlas_tex, surface_get_texture(_s_atlas));
		surface_set_target_ext(0, _s_lights);
		surface_set_target_ext(1, _s_bloom);
			draw_surface_ext(application_surface, _view_x, _view_y, _xscale, _yscale, _angle, image_blend, 1);	
		surface_reset_target();
		shader_reset();
	}
	
	matrix_set(matrix_world, matrix_reset);
	
#endregion

#region BLOOM LIGHTING

	// Ping pong blur
	gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
	for (var _b = 0; _b < bloom_amount; _b++)
	{
		surface_set_target(_s_norm);
			shader_set(shd_blur_horizontal_glsl_es);
			shader_set_uniform_f(_u_blur_hor, _s_width, _s_height);
			draw_surface(_s_bloom, 0, 0);
		surface_reset_target();
		
		surface_set_target(_s_bloom);
			shader_set(shd_blur_vertical_glsl_es);
			shader_set_uniform_f(_u_blur_ver, _s_width, _s_height);
			draw_surface(_s_norm, 0, 0);
		surface_reset_target();
	}
	shader_reset();
					
#endregion

#region FINAL COMPOSITE LIGHT, BLOOM, DOF

	gpu_set_blendmode(bm_normal);
	shader_set(shd_composite_light_bloom_glsl_es);
	texture_set_stage(s_bloom_dof, surface_get_texture(_s_bloom));
	draw_surface_ext(_s_lights, _view_x, _view_y, _xscale, _yscale, _angle, c_white, 1);
	shader_reset();
	
#endregion