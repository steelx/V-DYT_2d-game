/// @description obj_dialog_parent create
dialog_active = false;
current_dialog = noone;
dialog_system = new DialogSystem();


// Surface for dialog
dialog_surface = -1;
surface_width = 1920;  // Match viewport width
surface_height = 1080; // Match viewport height

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
    show_debug_message($"trigger_dialog {current_dialog}");
    pause();
};

