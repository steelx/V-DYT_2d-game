/// @description obj_player step 0 event

event_inherited();


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
            vel_y = -jump_speed;
            grounded = false;
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        
        break;
    
    case CHARACTER_STATE.JETPACK_JUMP:
        if (!is_space_key_held() || jetpack_fuel <= 0) {
            state = CHARACTER_STATE.JUMP;
            sprite_index = spr_player_jet_landing;
            image_index = 0;
        } else {
            jetpack_fuel -= jetpack_fuel_consumption_rate;
            if (y > jetpack_max_height) {
                vel_y = max(-jump_speed * 0.5, -abs(y - jetpack_max_height) * 0.1);
            } else {
                vel_y = sin(current_time * jetpack_hover_speed) * jetpack_hover_amplitude;
            }
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
}

apply_verticle_movement();

/// Regenerate jetpack fuel when grounded
/// (in future add fuel collectible items and remove this code)
if (grounded && jetpack_fuel < jetpack_max_fuel) {
    jetpack_fuel += jetpack_fuel_consumption_rate * 2; // Regenerate twice as fast as consumption
    jetpack_fuel = min(jetpack_fuel, jetpack_max_fuel);
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
