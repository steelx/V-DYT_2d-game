/// @description obj_player_superattack_hitbox collision with obj_enemy_parent
if (other.no_hurt_frames > 0) exit;

// Create the hit effect at intersection point

with(instance_create_depth(x, y, -depth, obj_hit_fx)) {
	sprite_index = spr_electric_hit_2;
	image_xscale = obj_player.image_xscale;	
}


// Reduce enemy's HP
with (other) {
	hp--;
	create_blood_splash();

	if (hp > 0 and instance_exists(other)) {
		var _no_attack_frames = 30;
		apply_knockback_to_enemy(6, _no_attack_frames);
		
		//if enemy has attack alarm task
		if (variable_instance_exists(id, "attack_delay_alarm_idx")) {
			alarm[attack_delay_alarm_idx] = _no_attack_frames;
		}
	}
}
