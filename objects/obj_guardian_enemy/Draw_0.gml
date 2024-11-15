/// @description obj_guardian_enemy Draw event
if !enabled {
	// if attack sequence is running hide this object
	exit;
}
// Inherit the parent event
event_inherited();

bt_root.Draw(id);

//draw_visibility_ray(visible_range, attack_range);
