/// @description obj_guardian_enemy Draw event
if !enabled {
	// if attack sequence is running hide this object
	exit;
}
// Inherit the parent event
event_inherited();

draw_debug_info();
//debug_render_mask();

// Draw the ray line
//draw_visibility_ray(visible_range, attack_range);
