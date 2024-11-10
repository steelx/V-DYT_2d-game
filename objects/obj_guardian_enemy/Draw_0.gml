/// @description obj_guardian_enemy Draw event
if !enabled {
	// if attack sequence is running hide this object
	exit;
}
// Inherit the parent event
event_inherited();

//draw_debug_info();
//debug_render_mask();
show_debug_message($"xS: {image_xscale}, s:{obj_game._states[state]}, Roam: {roam_count}, lastSeenX: {last_seen_player_x}");

//draw_visibility_ray(visible_range, attack_range);
