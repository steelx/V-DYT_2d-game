/// @description obj_player_superattack_hitbox collision with obj_enemy_parent
if (other.no_hurt_frames > 0) exit;

// Reduce enemy's HP
with (other) {
	create_blood_splash();
	hp--;
	apply_zoom_motion_fx(30, 1.5);
	play_priority_sound(snd_attack_hit, SoundPriority.CRITICAL);
	if (hp > 0 and instance_exists(other)) {
		// Start enemy blinking
		no_hurt_frames = 60;
		// Apply knockback to the enemy
		var _knockback_speed = 6; // Adjust this value as needed
		var _knockback_direction = point_direction(obj_player.x, obj_player.y, x, y);
		
		if variable_instance_exists(id, "apply_knockback") {
			apply_knockback(_knockback_direction, _knockback_speed);
			exit;
		}
		
		var _knockback_x = lengthdir_x(_knockback_speed, _knockback_direction);
		var _knockback_y = lengthdir_y(_knockback_speed, _knockback_direction);
		vel_x = _knockback_x;
		vel_y = 0;

		// Set the enemy to a knockback state
		state = CHARACTER_STATE.KNOCKBACK;
		knockback_active = true;
	}
}
