// Not paused by default.
global.game_paused = false;

// Declare pause function.
function pause() {
    // Pause the game.
    global.game_paused = true;

    // Apply the following code to all instances of obj_character_parent and its children...
    with (obj_character_parent) {
        if variable_instance_exists(id, "state") {
            // Set state to a new PAUSED state 
            state = CHARACTER_STATE.PAUSED;
        }
    }
}

function unpause() {
    // Unpause the game.
    global.game_paused = false;

    // Apply to all instances of obj_character_parent and its children.
    with (all) {
        if variable_instance_exists(id, "state") {
            // Restore velocities
            state = CHARACTER_STATE.IDLE;
        }
    }
}
