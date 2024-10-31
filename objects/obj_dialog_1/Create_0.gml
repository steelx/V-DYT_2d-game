/// @description obj_dialog_1 create

// Inherit the parent event
event_inherited();

//display_set_gui_size(GUI_WIDTH, GUI_HEIGHT);

dialog_system.add(
    spr_cat_picture, 
    "[c_red]Hello, [c_green]this is dialog message demo, select option and hit space key.", 
    ["Okay", "Exit"],
    [
        function() {
            show_debug_message("Player chose to be friendly");
            trigger_dialog(dialog_system);
        },
        function() {
            show_debug_message("Player chose to be unfriendly");
            end_dialog();
        }
    ]
);

dialog_system.add(
    spr_cat_picture, 
    "You can use SPACE key to Attack, Shift + Space for Super Attack.", 
    ["Okay", "Go away"],
    [
        function() {
            show_debug_message("Okay");
            trigger_dialog(dialog_system);
        },
        function() {
            show_debug_message("end_dialog");
            end_dialog();
        }
    ]
);

dialog_system.add(
    undefined, 
    "Welcome to the game!"
);

trigger_dialog(dialog_system);
