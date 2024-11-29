/// @description obj_player_attack_hitbox collision with obj_enemy_parent
if (other.no_hurt_frames > 0) exit;

// Create the hit effect at intersection point
with(instance_create_depth(x, y, -depth, obj_hit_fx)) {
	image_xscale = obj_player.image_xscale;	
}

with (other) {
	create_blood_splash();
	play_priority_sound(snd_attack_hit, SoundPriority.CRITICAL);
	hp--;
	if hp > 0 {
		apply_knockback_to_enemy(2, 50);
	}
}
