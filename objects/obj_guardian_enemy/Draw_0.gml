/// @description obj_guardian_enemy Draw event
if !enabled {
	// if attack sequence is running hide this object
	exit;
}
// Inherit the parent event
event_inherited();

debug_render_mask();