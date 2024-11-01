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
        audio_play_sound(electro_low_bleep, 10, false);
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
        audio_play_sound(blip_stab_bleep, 10, false);  // Play menu selection sound
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
