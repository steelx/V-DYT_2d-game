/// @description obj_enemy1 collision with obj_player

with (other) {
	// This checks if the player is invincible, by checking if no_hurt_frames is greater than 0.
	if (no_hurt_frames > 0) exit;

	// This section hurts the player, because it only runs if the player was not found to be jumping on the enemy's head.
	previous_hp = hp; // used at GUI
	hp -= other.damage;
	no_hurt_frames = get_room_speed() * 3;// 60 * 3

	if (hp > 0) {
		// Add red border effect
	    create_pixelated_blood_fx();
		add_screenshake(0.5);
	}

	// This changes the sprite to the hurt sprite.
	state = CHARACTER_STATE.KNOCKBACK;
	sprite_index = spr_player_hurt;
	image_index = 0;

	// ending the knockback after alarm ends, player goes to IDLE state
	alarm[KNOCKED_BACK] = 30;

	// Play the 'life lost' sound effect
	audio_play_sound(snd_life_lost_01, 0, 0);
}
