/// @description obj_player_superattack_hitbox collision with obj_enemy_parent
if (other.no_hurt_frames > 0) exit;

// Reduce enemy's HP
with (other) {
	hp--;
	create_blood_splash();
	apply_zoom_motion_fx(30, 1.5);
	play_priority_sound(snd_attack_hit, SoundPriority.CRITICAL);
	if (hp > 0 and instance_exists(other)) {
		var _no_attack_frames = 30;
		apply_knockback_to_enemy(6, _no_attack_frames);
		
		//if enemy has attack alarm task
		if (variable_instance_exists(id, "attack_delay_alarm_idx")) {
			alarm[attack_delay_alarm_idx] = _no_attack_frames;
		}
	}
}
