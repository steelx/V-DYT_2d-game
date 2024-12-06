/// @description obj_player step 0 event
if (variable_instance_exists(id, "enabled") and !enabled) exit;//used for attack seq spawner
if should_pause_object() exit;

event_inherited();

player_input();

switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
		move_speed = move_speed_init;
        vel_x = 0;
        break;
    case CHARACTER_STATE.MOVE:
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
        if (!is_jump_key_held() || jetpack_fuel <= 0) {
            sprite_index = sprites_map[$ CHARACTER_STATE.FALL];// fall
        } else {
            jetpack_fuel -= jetpack_fuel_consumption_rate;
    
            // Hover behavior
            var _target_y = jetpack_max_height + (sin(current_time * jetpack_hover_speed) * jetpack_hover_amplitude);
            y = lerp(y, _target_y, 0.1); // Smoothly interpolate towards the target height
        }
        break;
        
    case CHARACTER_STATE.KNOCKBACK:
        // Knockback state behavior
        // Slow down knockback
		sprite_index = sprites_map[$ CHARACTER_STATE.KNOCKBACK];
		vel_x = 0;
		// Apply knockback movement with collision checking
		knockback_vel_x = apply_knockback_movement(knockback_vel_x);
        
        // Check if knockback is finished
        if (abs(knockback_vel_x) < 0.1) {
            knockback_vel_x = 0;
			///transition_to_idle(); TODO: setup sprites_map for player
			state = CHARACTER_STATE.IDLE;
			sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
        }
        break;
        
    case CHARACTER_STATE.ATTACK:
		vel_x = 0;
	    vel_y = 0;
	    if (sprite_index = spr_hero_attack and image_index >= 9) {
	        state = CHARACTER_STATE.IDLE;
	        sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
	    }
        break;
        
    case CHARACTER_STATE.SUPER_ATTACK:
        vel_x = 0;
	    vel_y = 0;
	    if (is_animation_end()) {
	        state = CHARACTER_STATE.IDLE;
	        sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
	    }
        break;
}

// Apply vertical movement
apply_horizontal_movement();
apply_verticle_movement();
jump_thru_platform();
    
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

// Set the position of the default audio listener to the player's position, for positional audio
// with audio emitters (such as in obj_end_gate)
audio_listener_set_position(0, x, y, 0);
