event_inherited();


// Handle state transitions
switch(state) {
    case CHARACTER_STATE.JUMP:
        if (grounded) {
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
        break;
}

#region Shader step
    // Update trail positions
    ds_list_insert(trail_positions, 0, [x, y]);
    if (ds_list_size(trail_positions) > trail_count) {
        ds_list_delete(trail_positions, trail_count);
    }
    
    // Decrease trail intensity over time
    if (trail_intensity > 0) {
        trail_intensity -= 0.05;
        if (trail_intensity < 0) trail_intensity = 0;
    }
    
    // Disable shader when trail effect is done
    if (trail_intensity == 0) {
        use_trail_shader = false;
    }
#endregion

// Set the position of the default audio listener to the player's position, for positional audio
// with audio emitters (such as in obj_end_gate)
audio_listener_set_position(0, x, y, 0);
