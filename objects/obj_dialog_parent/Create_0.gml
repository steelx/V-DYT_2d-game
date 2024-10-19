/// @description obj_dialog_parent create
dialog_active = false;
current_dialog = noone;
instances_deactivated = false;
dialog_system = new DialogSystem();

set_game_paused = function(_pause = true) {
    if _pause == true {
        pause();
    } else {
        unpause();
    }
};

end_dialog = function() {
    dialog_active = false;
    current_dialog = noone;
    set_game_paused(false);
    instance_destroy();
};

trigger_dialog = function(_dialog_system) {
    dialog_active = true;
    current_dialog = _dialog_system.pop();
    set_game_paused();
};

