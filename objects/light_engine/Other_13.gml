/// @description Pre-composite (no mrt)

var _s_width  = surface_width,
	_s_height = surface_height,
	_u_spine_normal_uvs      = u_spine_normal_uvs,
	_u_spine_normal_params   = u_spine_normal_params,
	_u_spine_normal_tex      = u_spine_normal_tex,
	_u_spine_material_uvs    = u_spine_material_uvs,
	_u_spine_material_params = u_spine_material_params,
	_u_spine_material_tex    = u_spine_material_tex,
	_u_lit_normal            = u_lit_particles_normal,
	_u_lit_material          = u_lit_particles_material,
	_cam					 = view_get_camera(view_current);
	
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_zfunc(cmpfunc_lessequal);
	
#region NORMALS

	if (!surface_exists(surface_normal)) surface_normal = surface_create(_s_width, _s_height);
	surface_set_target(surface_normal);
		camera_apply(_cam);
		gpu_set_blendenable(false);
		
		// **** GAME NORMALS **** //
		shader_set(shd_draw_normals_glsl_es);
		with (__shadow) event_user(LE_DRAW_NORMAL);
		with (__le_game) event_user(LE_DRAW_NORMAL);
		// ADD OTHER NORMAL MAP DRAWING HERE

		// **** SPINE NORMALS **** //
		shader_set(shd_spine_normal_nomrt_glsl_es);
		with (__le_spine)
		{
			shader_set_uniform_f(_u_spine_normal_uvs, uv_array[0], uv_array[1], uv_array[2], uv_array[3]);
			shader_set_uniform_f(_u_spine_normal_params, emissive_strength, shadow_depth, depth, image_angle);
			texture_set_stage(_u_spine_normal_tex, normal_tex);
			draw_self();
		}
			
		// **** PARTICLE NORMALS **** //
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext_sepalpha(bm_src_color, bm_inv_src_color, bm_one, bm_one);
		shader_set(shd_draw_particle_normal_nomrt_glsl_es);
		shader_enable_corner_id(true);
		with (__le_particles)
		{
			shader_set_uniform_f(_u_lit_normal, depth);
			draw();
		}
		shader_enable_corner_id(false);
	surface_reset_target();

#endregion

#region MATERIALS

	if (!surface_exists(surface_material)) surface_material = surface_create(_s_width, _s_height);
	surface_set_target(surface_material);
		camera_apply(_cam);
		gpu_set_blendenable(false);
		gpu_set_blendmode(bm_normal);
		
		// **** GAME MATERIALS **** //
		shader_set(shd_draw_materials_nomrt_glsl_es);
		with (__shadow) event_user(LE_DRAW_MATERIAL);
		with (__le_game) event_user(LE_DRAW_MATERIAL);	
		// ADD OTHER MATERIAL DRAWING HERE
			
		// **** SPINE MATERIALS **** //
		shader_set(shd_spine_material_nomrt_glsl_es);
		with (__le_spine)
		{
			shader_set_uniform_f(_u_spine_material_uvs, uv_array[4], uv_array[5], uv_array[6], uv_array[7]);
			shader_set_uniform_f(_u_spine_material_params, emissive_strength, shadow_depth, depth);
			texture_set_stage(_u_spine_material_tex, material_tex);
			draw_self();
		}
			
		// **** PARTICLE MATERIALS **** //
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext_sepalpha(bm_src_color, bm_inv_src_color, bm_one, bm_one);
		shader_set(shd_draw_particle_material_nomrt_glsl_es);
		shader_enable_corner_id(true);
		with (__le_particles)
		{
			shader_set_uniform_f(_u_lit_material, shadow_depth, depth);
			draw();
		}
		shader_enable_corner_id(false);
	surface_reset_target();
	
#endregion

shader_reset();
gpu_set_blendmode(bm_normal);
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
