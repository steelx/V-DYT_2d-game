/*
1. Chooses a random direction to move.
2. Checks up to 3 tiles ahead in that direction for a valid landing spot (a spot without collision).
3. If no valid spot is found, it checks in the opposite direction.
4. If a valid landing spot is found, it sets vel_x based on the jump distance and _move_speed.
5. Changes the state to MOVE.
*/
function enemy_jump_move(_move_speed = 2, _tiles_to_check = 3) {
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

/// @function enemy_random_move_v2(move_speed, tiles_to_check)
/// @param {real} _move_speed The speed at which the enemy should move
/// @param {real} _tiles_to_check The number of tiles to check for a valid landing spot
function enemy_random_move_v2(_move_speed = 1.5, _tiles_to_check = 3, _move_dir = undefined) {
    var _tile_size = global.tile_size;
    _move_dir = _move_dir == undefined ? choose(-1, 1) : _move_dir;
    var _jump_distance = 0;

    // Random movement logic
    _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
    if (_jump_distance == 0) {
        _move_dir *= -1;
        _jump_distance = check_valid_move(_move_dir, _tiles_to_check, _tile_size);
    }

    // Calculate vel_x based on jump distance and move_speed
    vel_x = _move_dir * _move_speed * (_jump_distance / _tiles_to_check);
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
    return abs(_distance_to_move) < 0;
}

/// @function enemy_move_to(pos_x, move_speed)
/// @param {real} _pos_x The target x position to move to
/// @param {real} _move_speed The speed at which the enemy should move
function enemy_move_to(_pos_x, _move_speed) {
    var _direction = sign(_pos_x - x);
    var _tiles_to_check = ceil(abs(_pos_x - x) / global.tile_size);
    
    // Check for valid move
    var _valid_distance = check_valid_move(_direction, _tiles_to_check, global.tile_size);
    
    // Set velocity based on the valid move
    if (_valid_distance > 0) {
        vel_x = _move_speed * _direction;
        image_xscale = _direction;
        sprite_index = spr_guardian_walk;
        state = CHARACTER_STATE.SEARCH;
    } else {
        vel_x = 0;
        sprite_index = spr_guardian_idle;
    }
}
