// @description runs when the instance goes outside the room.
// This condition checks if the top edge of the player's mask is below the room,
// meaning it's completely outside the room now.
if (bbox_top > room_height and !obj_game.transition_active)
{
	// This reduces the health by 1.
	hp -= 1;

	// If the player still has hp left,
	if (hp > 0)
	{
		// This moves the player to the position stored in the grounded_x and _y variables,
		// which is the position when it was last on ground.
		x = grounded_x-(global.tile_size/2 *image_xscale);
		y = grounded_y;

		// This gives 2 seconds of invincibility to the player.
		no_hurt_frames += get_room_speed()*2;// 120

		// This resets the X and Y velocities of the player so it stops all movement.
		vel_x = 0;
		vel_y = 0;

		// This sets a knockback state for 20 frames (using the Alarm below) so user input is
		// disabled for that period, meaning the player doesn't immediately fall into the hurt zone
		// again.
		in_knockback = true;

		alarm[0] = 20;

		// Play the 'life lost' sound effect
		audio_play_sound(snd_life_lost_01, 0, 0);
	}
}