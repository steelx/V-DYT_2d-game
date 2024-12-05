/// @description Projectile Collision with obj_player
// Check if the player is invincible
with (other) {
	if (no_hurt_frames > 0) exit;

	// Damage the player
	hp -= other.damage;//other here is projectile

	// Change sprite to hurt sprite
	sprite_index = spr_player_hurt;
	image_index = 0;

	// Apply knockback
	state = CHARACTER_STATE.KNOCKBACK;

	// Set invincibility frames
	no_hurt_frames = get_room_speed() * 2; // 2 second of invincibility


	// Set Alarm 0 to run after 15 frames to end knockback
	alarm[KNOCKED_BACK] = 15;

	// Add screen shake if player is still alive
	if (hp > 0) add_screenshake(0.2, 2);

	// Play hurt sound
	audio_play_sound(snd_life_lost_01, 0, 0);
}

// Destroy the projectile
instance_destroy();
