// Not paused by default.
global.game_paused = false;

// Declare pause function.
function pause() {
    // Pause the game.
    global.game_paused = true;
}

function unpause() {
    // Unpause the game.
    global.game_paused = false;
}
