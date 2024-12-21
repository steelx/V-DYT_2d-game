/// @description obj_game Step, added in rm_init
if (keyboard_check_pressed(vk_escape)) {
    _needs_redraw = true;
    if (global.game_state == GAME_STATES.PLAYING) {
        pause_game();
    } else {
        resume_game();
    }
}

if (global.game_state == GAME_STATES.PAUSED and global.show_game_menu) {
    var _old_index = menu_index;
    menu_min = global.game_state == GAME_STATES.GAME_OVER ? 1 : 0;
    var _move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    
    if (_move != 0) {
        audio_play_sound(snd_button_press_01, 10, false);
        menu_index += _move;
        
        // Wrap around menu
        if (menu_index < menu_min) {
            menu_index = option_num - 1;
        } else if (menu_index >= option_num) {
            menu_index = menu_min;
        }
        
        _needs_redraw = true;
    }
    
    // Select Menu on Enter key press
    if (keyboard_check_pressed(vk_enter) or gamepad_button_check_pressed(0, gp_face2)) {
        audio_play_sound(alert_abyssal, 10, false);  // Play menu selection sound
        switch(menu_options[menu_index]) {
            case "Resume":
                resume_game();
                break;
            case "Restart":
                game_restart();
                break;
            case "Quit":
                game_end();
                break;
        }
    }
}

/// Room Transition
if (transition_active) {
    transition_progress += transition_speed;
    
    if (transition_progress >= 1) {
        transition_progress = 0;
        
        switch(transition_phase) {
            case TRANSITION_PHASE.BEGIN: // Fade out complete
                transition_phase = TRANSITION_PHASE.COMPLETE;
                // Store player position and state before room change
                with(obj_player) {
                    global.player_save = {
						hp, state
					}
                }
                room_goto(target_room_index);
                break;
                
            case TRANSITION_PHASE.COMPLETE: // Room change complete
			    transition_phase = TRANSITION_PHASE.FINISHED;
			    // Restore player position and state
			    with(obj_player) {
					hp = global.player_save.hp;
			        state = global.player_save.state;
					no_hurt_frames = get_room_speed() * 1;
			    }
			    break;

            case TRANSITION_PHASE.FINISHED: // Fade in complete
				transition_phase = TRANSITION_PHASE.BEGIN;
                transition_active = false;
                break;
        }
    }
}

