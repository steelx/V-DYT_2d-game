event_inherited();

obj_camera.follow = obj_player;

// Handle state transitions
switch(state) {
    case CHARACTER_STATE.JUMP:
        if (grounded) {
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        break;
}

// Set the position of the default audio listener to the player's position, for positional audio
// with audio emitters (such as in obj_end_gate)
audio_listener_set_position(0, x, y, 0);
