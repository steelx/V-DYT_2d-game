/// @description obj_player step 0 event
GAME_PAUSED_THEN_EXIT
event_inherited();

player_input();
switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
        vel_x = 0;
        break;
    case CHARACTER_STATE.MOVE:
        apply_horizontal_movement();
        if (grounded) {
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        break;
    
    case CHARACTER_STATE.JUMP:
        if (grounded) {
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        
        break;
    
    case CHARACTER_STATE.JETPACK_JUMP:
        // Allow horizontal movement during jetpack jump
        apply_horizontal_movement();
    
        if (!is_jump_key_held() || jetpack_fuel <= 0) {
            sprite_index = spr_player_fall;
        } else {
            jetpack_fuel -= jetpack_fuel_consumption_rate;

            // Hover behavior
            var _target_y = jetpack_max_height + (sin(current_time * jetpack_hover_speed) * jetpack_hover_amplitude);
            y = lerp(y, _target_y, 0.1); // Smoothly interpolate towards the target height
        }
        break;
    
    case CHARACTER_STATE.KNOCKBACK:
        // Knockback state behavior
        // The character is unable to control movement in this state
        // Knockback velocity is applied in the collision event and stopped in Alarm 0
        vel_x = 0;
        vel_y = 0;
        if is_animation_end() {
            state = CHARACTER_STATE.IDLE;
            break;
        }
        break;
    
    case CHARACTER_STATE.ATTACK:
        vel_x = 0;
        vel_y = 0;
        if (image_index >= 9) {
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_player_idle;
        }
        break;
    
    case CHARACTER_STATE.SUPER_ATTACK:
        vel_x = 0;
        vel_y = 0;
        if (is_animation_end()) {
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_player_idle;
        }
        break;
}

// Apply vertical movement
apply_verticle_movement();

/// Regenerate jetpack fuel when grounded
/// (in future add fuel collectible items and remove this code)
if (grounded && jetpack_fuel < jetpack_max_fuel) {
    jetpack_fuel += jetpack_fuel_regeneration_rate;
    jetpack_fuel = min(jetpack_fuel, jetpack_max_fuel);
}

// Regenerate attack fuel when not attacking
if (state != CHARACTER_STATE.ATTACK && state != CHARACTER_STATE.SUPER_ATTACK && attack_fuel < attack_fuel_max) {
    attack_fuel += attack_fuel_regeneration_rate;
    attack_fuel = min(attack_fuel, attack_fuel_max);
}


#region sh_bounce_trail step
    // Update trail positions
    ds_list_insert(trail_positions, 0, [x, y]);
    if (ds_list_size(trail_positions) > trail_count) {
        ds_list_delete(trail_positions, trail_count);
    }
    
    // Decrease trail intensity over time
    if (trail_intensity > 0) {
        trail_intensity -= 0.05;
        if (trail_intensity < 0) trail_intensity = 0;
    }
    
    // Disable shader when trail effect is done
    if (trail_intensity == 0) {
        use_trail_shader = false;
    }
#endregion

// Set the position of the default audio listener to the player's position, for positional audio
// with audio emitters (such as in obj_end_gate)
audio_listener_set_position(0, x, y, 0);
