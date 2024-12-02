/// @description Pre-composite

var _s_width  = surface_width,
	_s_height = surface_height,
	_cam	  = view_get_camera(view_current);
	
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_zfunc(cmpfunc_lessequal);
gpu_set_blendenable(false);

#region NORMALS AND MATERIALS
		
	// **** NORMALS **** //
	if (!surface_exists(surface_normal)) surface_normal = surface_create(_s_width, _s_height);

	shader_set(shd_draw_normals_glsl_es);
	surface_set_target(surface_normal);	
		camera_apply(_cam);
		with (__shadow) event_user(LE_DRAW_NORMAL);
		with (__le_game) event_user(LE_DRAW_NORMAL);
		
		// ADD OTHER NORMAL MAP DRAWING HERE IF NEEDED
		// ...
		
	surface_reset_target();
		
	// **** MATERIALS **** //
	if (!surface_exists(surface_material)) surface_material = surface_create(_s_width, _s_height);
	if (!surface_exists(surface_depth)) surface_depth       = surface_create(_s_width, _s_height, surface_rg8unorm);
	
	shader_set(shd_draw_materials_glsl_es);
	surface_set_target_ext(0, surface_material);
	surface_set_target_ext(1, surface_depth);
		camera_apply(_cam);
		shader_set_occlusion(global.le_object_occlusion);
	
		with (__shadow) 
		{	
			// material changes to r = metal, g = rough, b = occluder
			// alpha still = shadow_depth
			// set uniform for depth or gpu_set_depth?
			event_user(LE_DRAW_MATERIAL);
		}
		with (__le_game)
		{
			// set uniform for depth or gpu_set_depth?
			event_user(LE_DRAW_MATERIAL);	
		}
		
		// ADD OTHER MATERIAL DRAWING HERE IF NEEDED
		// ...
		
	surface_reset_target();
		
#endregion

#region SPINE AND PARTICLES

	surface_set_target_ext(0, surface_normal);
	surface_set_target_ext(1, surface_material);
	surface_set_target_ext(2, surface_depth);
		camera_apply(_cam);
		
		// **** SPINE SPRITES **** //
		var _u_spine_uvs       = u_spine_uvs,
			_u_spine_params    = u_spine_params,
			_u_spine_normal    = u_spine_normal,
			_u_spine_material  = u_spine_material,
			_u_spine_occlusion = u_spine_occlusion;
		
		shader_set(shd_spine_deferred_glsl_es);
		with (__le_spine)
		{
			shader_set_uniform_f_array(_u_spine_uvs, uv_array);
			shader_set_uniform_f(_u_spine_params, emissive_strength, shadow_depth, depth, image_angle);
			shader_set_uniform_f(_u_spine_occlusion, has_occlusion);
			texture_set_stage(_u_spine_normal, normal_tex);
			texture_set_stage(_u_spine_material, material_tex);
			draw_self();
		}
		
		// **** LIT PARTICLES **** //
		var _u_lit = u_lit_particles;
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext_sepalpha(bm_one, bm_src_color, bm_one, bm_inv_src_alpha);
		shader_set(shd_particle_deferred_glsl_es);
		shader_enable_corner_id(true);
		with (__le_particles)
		{
			shader_set_uniform_f(_u_lit, shadow_depth, depth);
			draw();
		}
		shader_enable_corner_id(false);

	surface_reset_target();
	
#endregion

shader_reset();
gpu_set_blendmode(bm_normal);
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);