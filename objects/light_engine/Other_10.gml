/// @description Shader Setup

// Common
u_blur_horizontal = shader_get_uniform(shd_blur_horizontal_glsl_es, "u_params");
u_blur_vertical   = shader_get_uniform(shd_blur_vertical_glsl_es, "u_params");

// Soft shadows
u_lights_ss        = shader_get_uniform(shd_light_ss_glsl_es, "u_lights");
u_normal_tex_ss    = shader_get_sampler_index(shd_light_ss_glsl_es, "u_normal");
u_material_tex_ss  = shader_get_sampler_index(shd_light_ss_glsl_es, "u_material");
u_atlas_tex_ss	   = shader_get_sampler_index(shd_light_ss_glsl_es, "u_shadow_atlas");
u_atlas_position   = shader_get_uniform(shd_shadow_atlas_glsl_es, "u_position");
u_atlas_size       = shader_get_uniform(shd_shadow_atlas_glsl_es, "u_size");
u_atlas_cell       = shader_get_uniform(shd_shadow_atlas_glsl_es, "u_cell");
s_bloom_dof        = shader_get_sampler_index(shd_composite_light_bloom_glsl_es, "s_bloom_dof");
s_atlas_blur_depth_hor = shader_get_sampler_index(shd_atlas_blur_horizontal_glsl_es, "s_depth");
s_atlas_blur_depth_ver = shader_get_sampler_index(shd_atlas_blur_vertical_glsl_es, "s_depth");
u_atlas_blur_params_hor = shader_get_uniform(shd_atlas_blur_horizontal_glsl_es, "u_params");
u_atlas_blur_params_ver = shader_get_uniform(shd_atlas_blur_vertical_glsl_es, "u_params");
u_lit_particles    = shader_get_uniform(shd_particle_deferred_glsl_es, "u_depth");
u_spine_uvs        = shader_get_uniform(shd_spine_deferred_glsl_es, "u_uvs");
u_spine_params     = shader_get_uniform(shd_spine_deferred_glsl_es, "u_params");
u_spine_normal     = shader_get_sampler_index(shd_spine_deferred_glsl_es, "u_normal");
u_spine_material   = shader_get_sampler_index(shd_spine_deferred_glsl_es, "u_material");
u_spine_occlusion  = shader_get_uniform(shd_spine_deferred_glsl_es, "u_occlusion");
	
// Hard shadows (1-bit encoded)
u_lights          = shader_get_uniform(shd_light_nomrt_glsl_es, "u_lights");
u_normal_tex      = shader_get_sampler_index(shd_light_nomrt_glsl_es, "u_normal");
u_material_tex    = shader_get_sampler_index(shd_light_nomrt_glsl_es, "u_material");
u_shadow_tex      = shader_get_sampler_index(shd_light_nomrt_glsl_es, "u_shadow");
u_shadow_position = shader_get_uniform(shd_shadow_cast_glsl_es, "u_position");
u_shadow_index    = shader_get_uniform(shd_shadow_cast_glsl_es, "u_index");
u_lit_particles_normal   = shader_get_uniform(shd_draw_particle_normal_nomrt_glsl_es, "u_depth");
u_lit_particles_material = shader_get_uniform(shd_draw_particle_material_nomrt_glsl_es, "u_depth");
u_spine_normal_uvs       = shader_get_uniform(shd_spine_normal_nomrt_glsl_es, "u_uvs");
u_spine_normal_params    = shader_get_uniform(shd_spine_normal_nomrt_glsl_es, "u_params");
u_spine_normal_tex       = shader_get_sampler_index(shd_spine_normal_nomrt_glsl_es, "u_normal");
u_spine_material_uvs     = shader_get_uniform(shd_spine_material_nomrt_glsl_es, "u_uvs");
u_spine_material_params  = shader_get_uniform(shd_spine_material_nomrt_glsl_es, "u_params");
u_spine_material_tex     = shader_get_sampler_index(shd_spine_material_nomrt_glsl_es, "u_material");	
