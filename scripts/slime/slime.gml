/*
1. Chooses a random direction to move.
2. Checks up to 3 tiles ahead in that direction for a valid landing spot (a spot without collision).
3. If no valid spot is found, it checks in the opposite direction.
4. If a valid landing spot is found, it sets vel_x based on the jump distance and _move_speed.
5. Changes the state to MOVE.
*/
function slime_jump_move() {
    var _move_speed = 2;
    var _tiles_to_check = 3;
    var _tile_size = global.tile_size;
    
    // Choose a random direction
    var _move_dir = choose(-1, 1);
    
    // Check tiles ahead
    var _jump_distance = 0;
    for (var _i = _tiles_to_check; _i > 0; _i--) {
        var _check_x = _move_dir * _i * _tile_size;
        var _check_y = _tile_size + 1; // Check one tile plus one pixel below the current position
        
        // Check if there's no collision at the landing spot and there is ground below it
        if (!check_collision(_check_x, 0) && check_collision(_check_x, _check_y)) {
            _jump_distance = _i;
            break;
        }
    }
    
    // If no valid jump found, try the opposite direction
    if (_jump_distance == 0) {
        _move_dir *= -1;
        for (var _i = _tiles_to_check; _i > 0; _i--) {
            var _check_x = _move_dir * _i * _tile_size;
            var _check_y = _tile_size + 1;
            
            if (!check_collision(_check_x, 0) && check_collision(_check_x, _check_y)) {
                _jump_distance = _i;
                break;
            }
        }
    }
    
    // If still no valid jump found, don't move
    if (_jump_distance == 0) {
        vel_x = 0;
        state = CHARACTER_STATE.IDLE;
        show_debug_message($"don't move: {vel_x}");
        return;
    }
    
    // Calculate vel_x based on jump distance and move_speed
    vel_x = _move_dir * _move_speed * (_jump_distance / _tiles_to_check);
    show_debug_message($"move: {vel_x}");
    // Change state to MOVE
    state = CHARACTER_STATE.MOVE;
}


