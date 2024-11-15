/// @description collision with obj_player
// other is obj_player
with (other) {
	// Check if the player is invincible
	if (no_hurt_frames > 0) {
		exit;
	}
	// inside WITH 'other' refers to hitbox
	hp -= other.damage;
    if (hp > 0) {
		// player hurt fx
		create_pixelated_blood_fx();
	}
	
	// Apply knockback to player
	var _enemy = instance_nearest(x, y, obj_little_ninja);
	var _knockback_speed = 4.5; // Adjust this value as needed
	var _knockback_direction = point_direction(_enemy.x, _enemy.y, x, y);
	apply_knockback(_knockback_direction, _knockback_speed);
}

