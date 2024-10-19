/// @description obj_dialog_1 create

// Inherit the parent event
event_inherited();

dialog_system.add(
    spr_cat_picture, 
    "Hello, please use L, R Arrow keys to move and Up Arrow key to jump", 
    ["Okay", "Go away"],
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
            trigger_dialog(dialog_system);
        },
        function() {
            end_dialog();
        }
    ]
);

dialog_system.add(
    spr_cat_picture, 
    "Welcome to the game!",
    ["Start game", "Quit game"],
    [
        function() {
            show_debug_message("Starting the game");
            end_dialog();
        },
        function() {
            show_debug_message("Exiting the game");
            game_end();
        }
    ]
);

trigger_dialog(dialog_system);
