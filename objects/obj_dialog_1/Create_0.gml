/// @description obj_dialog_1 create

// Inherit the parent event
event_inherited();

dialog_system.add(
    spr_cat_picture, 
    "Hello there!", 
    ["Nice to meet you", "Go away"],
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
    "Welcome to the game!",
    ["Start game", "Quit game"],
    [
        function() {
            show_debug_message("Starting the game");
            room_goto(rm_level_2);  // Assuming rm_game is your game room
        },
        function() {
            show_debug_message("Exiting the game");
            game_end();
        }
    ]
);

trigger_dialog(dialog_system);
