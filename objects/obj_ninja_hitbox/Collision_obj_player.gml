/// @description ninja hitbox collision with obj_player
// other is obj_player
with (other) {
	// Check if the player is invincible
	if (no_hurt_frames > 0) {
		exit;
	}
	// inside WITH 'other' refers to hitbox
	hp -= 1;
    if (hp > 0) {
		// player hurt fx
		create_pixelated_blood_fx();
	}
	
	// Apply knockback to the player
	var _guardian_enemy = instance_nearest(x, y, obj_little_ninja);
	var _knockback_direction = point_direction(_guardian_enemy.x, _guardian_enemy.y, x, y);
	apply_knockback(_knockback_direction, 4.0);
}
