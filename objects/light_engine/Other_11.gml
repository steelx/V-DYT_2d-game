/// @description Lighting (no mrt)

/// @description Lighting

#region DECLARATIONS

	var _s_width  = surface_width,
		_s_height = surface_height;
	
	if (!surface_exists(surface_lights)) 
	{
		surface_depth_disable(true);
		surface_lights = surface_create(_s_width, _s_height);
		surface_depth_disable(false);
	}
	
	if (!surface_exists(surface_shadow))   surface_shadow   = surface_create(_s_width, _s_height);
	if (!surface_exists(surface_normal))   surface_normal   = surface_create(_s_width, _s_height);
	if (!surface_exists(surface_material)) surface_material = surface_create(_s_width, _s_height);
		
	var _angle	     = image_angle, 
		_xscale      = image_xscale,
		_yscale      = image_yscale,
		_view_x      = view_x,
		_view_y      = view_y,
		_depth       = depth,
		_v_buffer    = vertex_buffer,
	  	_s_lights    = surface_lights,
		_s_shadows   = surface_shadow,
		_u_shadow    = u_shadow_position,
		_u_index     = u_shadow_index,
		_l_arr       = lights_array,
		_light_total = instance_number(__light),
		_ambient_x   = ambient_x,
		_ambient_y   = ambient_y,
		_ambient_z   = ambient_z,
		_ambient_int = ambient_intensity,
		_ambient_col = ambient_color;
				
	texture_set_stage(u_normal_tex, surface_get_texture(surface_normal));
	texture_set_stage(u_material_tex, surface_get_texture(surface_material));
		
	gpu_set_blendmode_ext(bm_one, bm_one);
	surface_set_target(_s_lights);
		draw_clear_alpha(c_black, 0);
	surface_reset_target();
	
#endregion

#region DEFERRED LIGHT RENDERING

	// Draw in surface space coordinates
	matrix_set(matrix_world, surface_matrix);

	// Encode 32 shadow maps as 1 bit into a single 32 bit surface per batch
	for (var _batch = 0; _batch < _light_total; _batch += 32)
	{				
		var _batch_count = min(32, _light_total - _batch),
			_params = _batch_count * 8 + 6,
			_param_index = 6,
			_light_index = -1;
			
		if (array_length(_l_arr) != _params) array_resize(_l_arr, _params);
		
		_l_arr[0] = _ambient_int;
		_l_arr[1] = _ambient_col; 
		_l_arr[2] = _ambient_x;
		_l_arr[3] = _ambient_y;
		_l_arr[4] = _ambient_z;
		_l_arr[5] = _batch_count;  // Light count for this batch
		
		_ambient_int = -1; // Tells shader to only apply ambience in first batch
		
		// Depth buffer ensures overlaps of the same vertex submit encode correctly
		surface_set_target(_s_shadows);
		draw_clear_alpha(c_black, 0);
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
		gpu_set_zfunc(cmpfunc_notequal);  // Using notequal is important for the 1 bit encoding
		shader_set(shd_shadow_cast_glsl_es);
				
		// Iterate through current subset of lights
		for (var _li = _batch, _last = _batch + _batch_count; _li < _last; _li++)
		{
			with instance_find(__light, _li)
			{	
				shader_set_uniform_f(_u_shadow, x, y, z_depth);
				shader_set_uniform_f(_u_index, ++_light_index * directional);
				vertex_submit(_v_buffer, pr_trianglelist, -1);
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
		
		gpu_set_ztestenable(false);
		gpu_set_zwriteenable(false);
		surface_reset_target();
		
		// Render lights in batches which iterate within the shader to massively reduce sample rate
		shader_set(shd_light_nomrt_glsl_es);
		shader_set_uniform_f_array(u_lights, _l_arr);
		texture_set_stage(u_shadow_tex, surface_get_texture(_s_shadows));
		surface_set_target(_s_lights);
			draw_surface_ext(application_surface, _view_x, _view_y, _xscale, _yscale, _angle, image_blend, 1);	
		surface_reset_target();
		shader_reset();
	}
		
	// No longer draw in surface space
	matrix_set(matrix_world, matrix_reset);
	
	// Preserve the background color
	gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha); 
	draw_surface_ext(_s_lights, _view_x, _view_y, _xscale, _yscale, _angle, c_white, 1);
	gpu_set_blendmode(bm_normal);
	
#endregion

#region BLOOM LIGHTING
	
	// Gaussian blur for the bloom
	if (!surface_exists(surface_bloom)) 
	{
		surface_depth_disable(true);
		surface_bloom = surface_create(_s_width, _s_height);	
		surface_depth_disable(false);
	}
	
	var _u_hor  = u_blur_horizontal,
		_u_ver  = u_blur_vertical,
		_s_bloom = surface_bloom;
	
	// Capture bright areas for bloom
	gpu_set_blendmode_ext(bm_one, bm_one);
	surface_set_target(_s_bloom);
		draw_clear_alpha(c_black, 0);
		shader_set(shd_bloom_composite_nomrt_glsl_es);
		draw_surface(_s_lights, 0, 0);
	surface_reset_target();
					
	// Ping pong the values (reuse the light surface to save memory)
	gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
	for (var _b = 0; _b < bloom_amount; _b++)
	{
		surface_set_target(_s_lights);
			shader_set(shd_blur_horizontal_glsl_es);
			shader_set_uniform_f(_u_hor, _s_width, _s_height);
			draw_surface(_s_bloom, 0, 0);
		surface_reset_target();
		
		surface_set_target(_s_bloom);
			shader_set(shd_blur_vertical_glsl_es);
			shader_set_uniform_f(_u_ver, _s_width, _s_height);
			draw_surface(_s_lights, 0, 0);
		surface_reset_target();
	}
			
	shader_reset();
	gpu_set_blendmode(bm_add);
	draw_surface_ext(_s_bloom, _view_x, _view_y, _xscale, _yscale, _angle, c_white, 1);
	gpu_set_blendmode(bm_normal);
		
#endregion
