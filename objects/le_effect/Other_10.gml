/// @description Particle definitions

/*
Use the function part_emissive_alpha(_emissive, _alpha) when setting the alpha of a particle type.
This will encode the emissive value into the alpha channel. 

Note that the emissive value should be the same when using part_type_alpha2() or part_type_alpha3().
The alpha can be treated as normal and it will interpolate between values as normal.

This may change if GM implements a later shader version with bitwise operators, and in that case
emissive and alpha will be able to interpolate.
*/

#macro AUDIO_PRIORITY_HIGH 10
#macro AUDIO_PRIORITY_MED  5
#macro AUDIO_PRIOROTY_LOW  1

#macro c_fire0 $C4FDFF
#macro c_fire1 $54FAFF
#macro c_fire2 $1E4BFF
	
#region PARTICLE_TYPES
	
	part_emit_fire = part_type_add();
		part_type_shape(part_emit_fire, pt_shape_flare);
		part_type_size(part_emit_fire, 0.4, 0.6, -0.008, 0.2);
		part_type_color3(part_emit_fire, c_fire0, c_fire1, c_fire2);
		part_type_alpha2(part_emit_fire, part_emissive_alpha(0.9, 1.0), part_emissive_alpha(0.9, 0.6));
		part_type_speed(part_emit_fire, 2.0, 3.5, -0.4, 0.18);
		part_type_direction(part_emit_fire, 0, 360, 0, 0);
		part_type_gravity(part_emit_fire, 0.5, 90);
		part_type_orientation(part_emit_fire, 0, 360, 5, 0, false);
		part_type_life(part_emit_fire, 26, 30);
	
	part_pixel_yellow = part_type_add();
		part_type_shape(part_pixel_yellow, pt_shape_pixel);
		part_type_size(part_pixel_yellow, 8, 12, -0.2, 4);
		part_type_color3(part_pixel_yellow, c_yellow, c_lime, c_gray);
		part_type_alpha2(part_pixel_yellow, part_emissive_alpha(0.9, 1.0), part_emissive_alpha(0.9, 0.6));
		part_type_speed(part_pixel_yellow, 4, 8, -0.4, 0.5);
		part_type_direction(part_pixel_yellow, 0, 360, 0, 5);
		part_type_orientation(part_pixel_yellow, 0, 360, 5, 0, false);
		part_type_life(part_pixel_yellow, 22, 28);

	part_hit_white = part_type_add();
		part_type_shape(part_hit_white, pt_shape_flare);
		part_type_size(part_hit_white, 2, 4, -0.05, 0);
		part_type_color2(part_hit_white, c_white, c_grey);
		part_type_alpha2(part_hit_white, part_emissive_alpha(0.7, 0.9), part_emissive_alpha(0.7, 0.4));
		part_type_speed(part_hit_white, 2, 5, 0.1, 0);
		part_type_direction(part_hit_white, 0, 359, 0, 0);
		part_type_orientation(part_hit_white, 0, 360, 0, 0, false);
		part_type_life(part_hit_white, 35, 45);
	
	part_hit_red = part_type_add();
		part_type_shape(part_hit_red, pt_shape_explosion);
		part_type_size(part_hit_red, 2, 4, -0.05, 0);
		part_type_color2(part_hit_red, c_red, c_orange);
		part_type_alpha2(part_hit_red, part_emissive_alpha(0.7, 0.9), part_emissive_alpha(0.7, 0.4));
		part_type_speed(part_hit_red, 2, 5, 0.1, 0);
		part_type_direction(part_hit_red, 0, 359, 0, 0);
		part_type_orientation(part_hit_red, 0, 360, 0, 0, false);
		part_type_life(part_hit_red, 35, 45);
	
	part_hit_green = part_type_add();
		part_type_shape(part_hit_green, pt_shape_cloud);
		part_type_size(part_hit_green, 2, 4, -0.05, 0);
		part_type_color2(part_hit_green, c_green, c_grey);
		part_type_alpha2(part_hit_green, part_emissive_alpha(0.7, 0.9), part_emissive_alpha(0.7, 0.4));
		part_type_speed(part_hit_green, 2, 5, 0.1, 0);
		part_type_direction(part_hit_green, 0, 359, 0, 0);
		part_type_orientation(part_hit_green, 0, 360, 0, 0, false);
		part_type_life(part_hit_green, 35, 45);

	part_hit_blue = part_type_add();
		part_type_shape(part_hit_blue, pt_shape_ring);
		part_type_size(part_hit_blue, 2, 4, -0.05, 0);
		part_type_color2(part_hit_blue, c_fuchsia, c_ltgray);
		part_type_alpha2(part_hit_blue, part_emissive_alpha(0.7, 0.9), part_emissive_alpha(0.7, 0.4));
		part_type_speed(part_hit_blue, 2, 5, 0.1, 0);
		part_type_direction(part_hit_blue, 0, 359, 0, 0);
		part_type_orientation(part_hit_blue, 0, 360, 0, 0, false);
		part_type_life(part_hit_blue, 35, 45);
		
	part_fx_fire = part_type_add();
		part_type_sprite(part_fx_fire, spr_fx_fire, true, true, false);
		part_type_life(part_fx_fire, 28, 28);
		part_type_alpha2(part_fx_fire, part_emissive_alpha(0.9, 1), part_emissive_alpha(0.9, 0.6));
				
	part_fx_bubble = part_type_add();
		part_type_sprite(part_fx_bubble, spr_fx_bubble, true, true, false);
		part_type_life(part_fx_bubble, 45, 45);
		part_type_alpha2(part_fx_bubble, part_emissive_alpha(0.7, 1), part_emissive_alpha(0.7, 1));
		
	part_fx_earth = part_type_add();
		part_type_sprite(part_fx_earth, spr_fx_earth, true, true, false);
		part_type_life(part_fx_earth, 50, 50);
		part_type_alpha2(part_fx_earth, part_emissive_alpha(0.6, 1), part_emissive_alpha(0.6, 1));
		
	part_fx_spark = part_type_add();
		part_type_sprite(part_fx_spark, spr_fx_spark, true, true, false);
		part_type_life(part_fx_spark, 42, 42);
		part_type_alpha2(part_fx_spark, part_emissive_alpha(0.7, 1), part_emissive_alpha(0.7, 0.8));
	
#endregion

#region EFFECT_FUNCTIONS

	function emit_fire(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_emit_fire, 3);	
	}

	function pixel_trail_yellow(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_pixel_yellow, 4);	
	}

	function impact_white(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_hit_white, 6);
		if !audio_is_playing(sfx_impact0) audio_play_sound(sfx_impact0, AUDIO_PRIORITY_MED, false);
	}

	function impact_red(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_hit_red, 6);	
		if !audio_is_playing(sfx_impact0) audio_play_sound(sfx_impact0, AUDIO_PRIORITY_MED, false);
	}

	function impact_green(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_hit_green, 6);	
		if !audio_is_playing(sfx_impact0) audio_play_sound(sfx_impact0, AUDIO_PRIORITY_MED, false);
	}

	function impact_blue(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_hit_blue, 6);	
		if !audio_is_playing(sfx_impact0) audio_play_sound(sfx_impact0, AUDIO_PRIORITY_MED, false);
	}
	
	function fx_fire(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_fx_fire, 1);
		if !audio_is_playing(sfx_fire) audio_play_sound(sfx_fire, AUDIO_PRIORITY_MED, false);
	}
	
	function fx_bubble(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_fx_bubble, 1);
		if !audio_is_playing(sfx_splash) audio_play_sound(sfx_splash, AUDIO_PRIORITY_MED, false);
	}
	
	function fx_earth(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_fx_earth, 1);
		if !audio_is_playing(sfx_earth) audio_play_sound(sfx_earth, AUDIO_PRIORITY_MED, false);
	}
	
	function fx_spark(_x, _y)
	{
		part_particles_create(particle_system, _x, _y, part_fx_spark, 1);
		if !audio_is_playing(sfx_impact1) audio_play_sound(sfx_impact1, AUDIO_PRIORITY_MED, false);
	}
	
#endregion