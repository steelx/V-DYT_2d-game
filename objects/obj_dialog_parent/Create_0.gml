/// @description obj_dialog_parent create
dialog_active = false;
current_dialog = noone;
dialog_system = new DialogSystem();


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

