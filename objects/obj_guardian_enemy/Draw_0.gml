/// @description obj_guardian_enemy Draw event
if (variable_instance_exists(id, "enabled") and !enabled) exit;
// Inherit the parent event
event_inherited();

bt_root.Draw(id);

//draw_visibility_ray(visible_range, attack_range);
