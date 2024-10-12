/// @description JET_PACK_JUMP
// Check for held space key
if (is_space_key_held()) {
    // Space is still being held
    space_hold_timer++;
    
    if (space_hold_timer == 1) { // This is the first check after the key press
        if (grounded) {
            // Perform normal jump
            state = CHARACTER_STATE.JUMP;
            vel_y = -jump_speed;
            sprite_index = spr_player_fall;
            image_index = 0;
            grounded = false;
            instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);
    
            var _sound = audio_play_sound(snd_jump, 0, 0);
            audio_sound_pitch(_sound, random_range(0.8, 1));
        } else if (jetpack_fuel > 0) {
            // Start jet pack hover immediately
            state = CHARACTER_STATE.JETPACK_JUMP;
            sprite_index = spr_player_jet_jump;
            image_index = 0;
            image_speed = 1;
        }
    }
    
    if (space_hold_timer > 1 && state == CHARACTER_STATE.JETPACK_JUMP && !grounded && jetpack_fuel > 0) {
        // Continue jet pack hover
        vel_y = -jump_speed * 0.5; // Adjust this value for desired hover strength
        jetpack_fuel -= 1/60; // Consume 1 point per second (assuming 60 FPS)
        
        if (sprite_index != spr_player_jet_jump) {
            sprite_index = spr_player_jet_jump;
            image_index = 0;
            image_speed = 1;
        }
    }
    
    // Set the alarm to check again in the next step
    alarm[JET_PACK_JUMP] = 1;
} else {
    // Space was released
    if (state == CHARACTER_STATE.JETPACK_JUMP && !grounded) {
        state = CHARACTER_STATE.JUMP;
        sprite_index = spr_player_jet_landing;
        image_index = 0;
        image_speed = 1;
    }
}
