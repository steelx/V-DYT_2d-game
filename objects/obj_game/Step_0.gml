/// @description obj_game Step
if (keyboard_check_pressed(vk_escape)) {
    _needs_redraw = true;
    if (global.game_state == GAME_STATES.PLAYING) {
        global.game_state = GAME_STATES.PAUSED;
        global.show_game_menu = true; // in case of Dialog box we dont set this
    } else {
        global.game_state = GAME_STATES.PLAYING;
        global.show_game_menu = false;
    }
}

if (global.game_state == GAME_STATES.PAUSED and global.show_game_menu) {
    var _old_index = menu_index;
    menu_min = global.game_state == GAME_STATES.GAME_OVER ? 1 : 0;
    var _move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    
    if (_move != 0) {
        menu_index += _move;
        
        // Wrap around menu
        if (menu_index < menu_min) {
            menu_index = option_num - 1;
        } else if (menu_index >= option_num) {
            menu_index = menu_min;
        }
        
        _needs_redraw = true;
        show_debug_message($"menu_index {menu_index} {menu_options[menu_index]}");
    }
    
    // Pressed enter or Space trigger the menu option function
    if (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)) {
        switch(menu_options[menu_index]) {
            case "RESUME":
                global.game_state = GAME_STATES.PLAYING;
                global.show_game_menu = false;
                break;
            case "RESTART":
                game_restart();
                break;
            case "QUIT":
                game_end();
                break;
        }
    }
}
