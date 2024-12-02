part_system_update(particle_system);

gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
shader_set(shd_particle_albedo);
part_system_drawit(particle_system);
shader_reset();
gpu_set_blendmode(bm_normal);