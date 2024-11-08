/*
1. Chooses a random direction to move.
2. Checks up to 3 tiles ahead in that direction for a valid landing spot (a spot without collision).
3. If no valid spot is found, it checks in the opposite direction.
4. If a valid landing spot is found, it sets vel_x based on the jump distance and _move_speed.
5. Changes the state to MOVE.
*/
function enemy_random_move(_move_speed = 2, _tiles_to_check = 3) {
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
        return;
    }
    
    // Calculate vel_x based on jump distance and move_speed
    vel_x = _move_dir * _move_speed * (_jump_distance / _tiles_to_check);

    // Change state to MOVE
    state = CHARACTER_STATE.MOVE;
}

/// @function enemy_random_move_v2(move_speed, tiles_to_check, enable_smart)
/// @param {real} _move_speed The speed at which the enemy should move
/// @param {real} _tiles_to_check The number of tiles to check for a valid landing spot
/// @param {bool} _enable_smart Whether to enable smart search behavior
function enemy_random_move_v2(_move_speed = 1.5, _tiles_to_check = 3, _enable_smart = false) {
    var _tile_size = global.tile_size;
    var _move_dir = choose(-1, 1);
    var _jump_distance = 0;

    if (_enable_smart && instance_exists(obj_player)) {
        var _player_visible = is_player_visible(visible_range);
        
        if (_player_visible) {
            last_seen_player_x = obj_player.xprevious;
            alarm[ENEMY_SMART_SEARCH] = smart_search_duration;
            state = CHARACTER_STATE.MOVE;
            _move_dir = sign(obj_player.xprevious - x);
            _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
        } else if (alarm[ENEMY_SMART_SEARCH] > 0) {
            // Search for the player
            if (abs(x - last_seen_player_x) > 10) {
                _move_dir = sign(last_seen_player_x - x);
            } else {
                _move_dir = choose(-1, 1);
            }
            _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
            
            // Check both sides for the player
            if (is_player_visible_direction(visible_range, 1) || is_player_visible_direction(visible_range, -1)) {
                last_seen_player_x = obj_player.xprevious;
                alarm[ENEMY_SMART_SEARCH] = smart_search_duration;
            }
        } else {
            // Return to original position
            if (abs(x - original_x) > 10) {
                _move_dir = sign(original_x - x);
                _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
            } else {
                vel_x = 0;
                state = CHARACTER_STATE.IDLE;
                return;
            }
        }
    } else {
        // Original random movement logic
        _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
        if (_jump_distance == 0) {
            _move_dir *= -1;
            _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
        }
    }

    // If no valid jump found, don't move
    if (_jump_distance == 0) {
        vel_x = 0;
        state = CHARACTER_STATE.IDLE;
        return;
    }

    // Calculate vel_x based on jump distance and move_speed
    vel_x = _move_dir * _move_speed * (_jump_distance / _tiles_to_check);

    // Change state to MOVE
    state = CHARACTER_STATE.MOVE;
    image_xscale = _move_dir;
}


/// @function check_valid_move(direction, tiles_to_check, tile_size)
/// @param {real} _direction The direction to check (-1 for left, 1 for right)
/// @param {real} _tiles_to_check The number of tiles to check
/// @param {real} _tile_size The size of each tile
function check_valid_move(_direction, _tiles_to_check, _tile_size) {
    for (var _i = _tiles_to_check; _i > 0; _i--) {
        var _check_x = _direction * _i * _tile_size;
        var _check_y = _tile_size + 1; // Check one tile plus one pixel below the current position
        
        // Check if there's no collision at the landing spot and there is ground below it
        if (!check_collision(_check_x, 0) && check_collision(_check_x, _check_y)) {
            return _i;
        }
    }
    return 0;
}


/// @function move_to_attack_position(player_x, attack_object_x, attack_object_width)
/// @param {real} _player_x The x-coordinate of the player
/// @param {real} _attack_object_x The x-coordinate of the attack object relative to the enemy
/// @param {real} _attack_object_width The width of the attack object
function move_to_attack_position(_player_x, _attack_object_x, _attack_object_width) {
    var _ideal_distance = abs(_attack_object_x) + _attack_object_width / 2;
    var _direction_to_player = sign(_player_x - x);
    var _ideal_position = _player_x - (_ideal_distance * _direction_to_player);
    
    // Calculate the distance to move
    var _distance_to_move = _ideal_position - x;
    
    // Move the enemy
    x += _distance_to_move;
    
    // Ensure the enemy is facing the player
    image_xscale = _direction_to_player;
    
    // Return true if we moved, false otherwise
    return abs(_distance_to_move) > 0;
}


function smart_search_player(_player_visible = false) {
    if (_player_visible) {
        last_seen_player_x = obj_player.xprevious;
        smart_search_timer = smart_search_duration;
        state = CHARACTER_STATE.MOVE;
        vel_x = sign(obj_player.x - x) * move_speed;
    } else if (smart_search_timer > 0) {
        smart_search_timer--;
                
        // Search for the player
        if (abs(x - last_seen_player_x) > 10) {
            vel_x = sign(last_seen_player_x - x) * move_speed;
        } else {
            vel_x = choose(-1, 1) * move_speed;
        }
                
        // Check both sides for the player
        if (is_player_visible_direction(visible_range, 1) || is_player_visible_direction(visible_range, -1)) {
            last_seen_player_x = obj_player.x;
            smart_search_timer = smart_search_duration;
        }
    } else {
        // Return to original position
        if (abs(x - original_x) > 10) {
            vel_x = sign(original_x - x) * move_speed;
        } else {
            vel_x = 0;
            state = CHARACTER_STATE.IDLE;
        }
    }
}