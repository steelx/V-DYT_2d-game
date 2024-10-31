/// @description obj_dialog_parent create
dialog_active = false;
current_dialog = noone;
dialog_system = new DialogSystem();

dialog_width = window_get_width() / 2;
dialog_height = window_get_height() * 0.25;

// Surface for dialog
dialog_surface = -1;
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height

_needs_redraw = true;

end_dialog = function() {
    dialog_active = false;
    current_dialog = noone;
    unpause();
    instance_destroy();
};

trigger_dialog = function(_dialog_system) {
    dialog_active = true;
    current_dialog = _dialog_system.pop();
    pause();
};

