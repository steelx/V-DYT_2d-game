/// @description obj_dialog_parent Step Event
// takes care of checking if

if (dialog_active) {
    set_game_paused();
    
    if (keyboard_check_pressed(vk_space)) {
        if (dialog_system.count() > 0) {
            current_dialog = dialog_system.pop();
        } else {
            end_dialog();
        }
    }
    
    if (dialog_system.has_options(current_dialog)) {
        if (keyboard_check_pressed(vk_right)) dialog_system.next_option(current_dialog);
        if (keyboard_check_pressed(vk_left)) dialog_system.prev_option(current_dialog);
        if (keyboard_check_pressed(vk_enter)) {
            var _selected_index = current_dialog.current_option;
            dialog_system.execute_callback(current_dialog, _selected_index);
        }
    }
} else if (instances_deactivated) {
    set_game_paused(false);
}

