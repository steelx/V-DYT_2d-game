event_inherited();

obj_camera.follow = obj_player;

// Handle state transitions
switch(state) {
    case CHARACTER_STATE.JUMP:
        if (grounded) {
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        break;
    case CHARACTER_STATE.KNOCKBACK:
        // This checks if the player is invincible, by checking if no_hurt_frames is greater than 0.
        if (no_hurt_frames > 0)
        {
            // In that case we exit the event so the player is not hurt by the enemy.
            exit;
        }
        // This action gets the sign (1, 0 or -1) from the enemy's position to the player's position.
        var _x_sign = sign(x - other.x);
        
        // That sign is multiplied by 15, and applied to vel_x as the knockback.
        vel_x = _x_sign * 15;
        
        // This sets no_hurt_frames to 120, so the player is invincible for the next 2 seconds (as one second contains 60 frames).
        no_hurt_frames = get_room_speed() * 2;// 120
        if (hp > 0) add_screenshake(0.25);
        
        // This changes the sprite to the hurt sprite.
        sprite_index = spr_player_hurt;
        image_index = 0;
        
        // Set Alarm 0 to run after 15 frames; that event stops the player's horizontal velocity, ending the knockback
        alarm[0] = 15;
        
        // Play the 'life lost' sound effect
        audio_play_sound(snd_life_lost_01, 0, 0);
        break;
}

// Set the position of the default audio listener to the player's position, for positional audio
// with audio emitters (such as in obj_end_gate)
audio_listener_set_position(0, x, y, 0);
