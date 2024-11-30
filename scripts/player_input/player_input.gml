/// @desc payer keyboard events
function player_input() {
    // Left movement
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        if (state != CHARACTER_STATE.KNOCKBACK && state != CHARACTER_STATE.ATTACK && state != CHARACTER_STATE.SUPER_ATTACK) {
            if (state != CHARACTER_STATE.JETPACK_JUMP) {
                state = CHARACTER_STATE.MOVE;
            }
            vel_x = -move_speed;
            image_xscale = -1;
            
            if (grounded && sprite_index != sprites_map[$ CHARACTER_STATE.FALL]) {
                sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            }
        }
    }
    
    // Right movement
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        if (state != CHARACTER_STATE.KNOCKBACK or state != CHARACTER_STATE.ATTACK or state != CHARACTER_STATE.SUPER_ATTACK) {
            if (state != CHARACTER_STATE.JETPACK_JUMP) {
                state = CHARACTER_STATE.MOVE;
            }
            vel_x = move_speed;
            image_xscale = 1;
            
            if (grounded && sprite_index != sprites_map[$ CHARACTER_STATE.FALL]) {
                sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            }
        }
    }
    
    // Jump
    if (keyboard_check_pressed(vk_up) || keyboard_check(ord("W")) || keyboard_check_pressed(vk_space)) {
        if (state != CHARACTER_STATE.KNOCKBACK or state != CHARACTER_STATE.ATTACK or state != CHARACTER_STATE.SUPER_ATTACK) {
            jump_key_held_timer = 0;
            alarm_set(JET_PACK_JUMP, 1);
        }
    }
    
    // Attack / SuperAttack
    if (keyboard_check_pressed(vk_space)) {
        if (state != CHARACTER_STATE.ATTACK and state != CHARACTER_STATE.SUPER_ATTACK) {
            if (keyboard_check(vk_shift)) {
                if (grounded and attack_fuel >= attack_fuel_consumption_rate) {
					state = CHARACTER_STATE.SUPER_ATTACK;
	                sprite_index = sprites_map[$ CHARACTER_STATE.SUPER_ATTACK];
	                image_index = 0;
	                attack_fuel -= attack_fuel_consumption_rate;
				}
            } else {
                state = CHARACTER_STATE.ATTACK;
                sprite_index = sprites_map[$ CHARACTER_STATE.ATTACK];
                image_index = 0;
            }
        }
    }
    
    // Stop horizontal movement if no left/right key is pressed
    if (!keyboard_check(vk_left) && !keyboard_check(vk_right) && !keyboard_check(ord("A")) && !keyboard_check(ord("D"))) {
        if (state == CHARACTER_STATE.MOVE) {
            state = CHARACTER_STATE.IDLE;
            vel_x = 0;
            if (grounded) {
                sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
            }
        }
    }
}

