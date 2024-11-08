/// @description obj_player_attack_hitbox collision with obj_enemy_parent
if (other.no_hurt_frames > 0) exit;

with (other) {
	create_blood_splash();
	hp--;
	if hp > 0 {
		// Apply knockback to the enemy
		var _knockback_speed = 2; // Adjust this value as needed
		var _knockback_direction = point_direction(obj_player.x, obj_player.y, x, y);
		var _knockback_x = lengthdir_x(_knockback_speed, _knockback_direction);
		var _knockback_y = lengthdir_y(_knockback_speed, _knockback_direction);
		vel_x = _knockback_x;
		vel_y = 0;

		// Set the enemy to a knockback state
		state = CHARACTER_STATE.KNOCKBACK;

		// Start enemy blinking
		no_hurt_frames = 60; // Blink for 30 frames (adjust as needed)
		audio_play_sound(snd_enemy_hit, 1, false);
	}
}
