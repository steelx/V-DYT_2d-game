
function apply_knockback_to_enemy(_knockback_speed = 2, _no_hurt_frames = 60){
	// Start enemy blinking
	no_hurt_frames = _no_hurt_frames;
	// Apply knockback to the enemy
	var _knockback_direction = point_direction(obj_player.x, obj_player.y, x, y);
		
	if variable_instance_exists(id, "apply_knockback") {
		apply_knockback(_knockback_direction, _knockback_speed);
		return;
	}
		
	var _knockback_x = lengthdir_x(_knockback_speed, _knockback_direction);
	var _knockback_y = lengthdir_y(_knockback_speed, _knockback_direction);
	vel_x = _knockback_x;
	vel_y = 0;

	// Set the enemy to a knockback state
	state = CHARACTER_STATE.KNOCKBACK;
	knockback_active = true;
}
