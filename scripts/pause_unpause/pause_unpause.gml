// Not paused by default.
global.game_paused = false;

// Declare pause function.
function pause() {
    // Pause the game.
    global.game_state = GAME_STATES.PAUSED;
}

function unpause() {
    // Unpause the game.
    global.game_state = GAME_STATES.PLAYING;
}
