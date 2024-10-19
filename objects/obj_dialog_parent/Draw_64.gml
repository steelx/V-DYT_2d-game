/// @description obj_dialog_parent Draw GUI Event

show_debug_message($"Draw GUI dialog_active {dialog_active}");
if (dialog_active && current_dialog != noone) {
    var _dialog_width = 400;
    var _dialog_height = 100;
    var _dialog_x = (display_get_gui_width() - _dialog_width) / 2;
    var _dialog_y = display_get_gui_height() - 20;
    dialog_system.draw(_dialog_x, _dialog_y, _dialog_width, _dialog_height, current_dialog);
}
