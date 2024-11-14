/// @description collision with obj_player

var _x = x, _y = y;
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
		apply_zoom_motion_fx(1.2);
	}
	
	
	// Apply knockback
	// Apply knockback to the enemy
	var _guardian_enemy = instance_nearest(x, y, obj_guardian_enemy);
	var _knockback_speed = 6; // Adjust this value as needed
	var _knockback_direction = point_direction(_guardian_enemy.x, _guardian_enemy.y, x, y);
	apply_knockback(_knockback_direction, _knockback_speed);
}

