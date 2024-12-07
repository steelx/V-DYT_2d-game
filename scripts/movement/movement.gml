function apply_horizontal_movement() {
    var _remaining_move = vel_x;
    var _move_dir = sign(vel_x);
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(abs(_remaining_move), move_speed) * _move_dir;
        
        // Check for obstacles first
        var _obstacle_collision = global.collision_grid.CheckObstacleCollision(
            bbox_left + _step, 
            bbox_right + _step,
            bbox_top, 
            bbox_bottom
        );
        
        // Check for platforms
        var _platform = global.collision_grid.CheckPlatformCollision(
            bbox_left + _step, 
            bbox_right + _step,
            bbox_top, 
            bbox_bottom
        );
        
        var _collision_found = false;
        
        // Handle platform collision for both players and enemies
        if (_platform != noone) {
            if (is_on_ground() && bbox_bottom <= _platform.bbox.top + 1) {
                // Allow movement on top of platforms when grounded
                _collision_found = false;
            } else if (object_index == obj_player) {
                // For player, allow movement through platforms when not grounded on them
                _collision_found = false;
            } else {
                // For enemies, treat platforms as solid when not grounded on them
                _collision_found = true;
            }
        }
        
        // Check final collision result
        if (!_obstacle_collision && !_collision_found) {
            x += _step;
            _remaining_move -= _step;
        } else {
            vel_x = 0;
            break;
        }
    }
}

// Base vertical movement used by all characters
function apply_verticle_movement() {
    var _move_count_y = abs(vel_y);
    var _move_dir_y = sign(vel_y);
    var _remaining_move = vel_y;
    var _buffer_distance = 8; // Small buffer to prevent getting too close to ceiling
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(abs(_remaining_move), move_speed) * _move_dir_y;
        
        // Special handling for jetpack state
        if (state == CHARACTER_STATE.JETPACK_JUMP) {
            if (_move_dir_y < 0) { // Moving upward
                // Check for ceiling ahead with buffer
                var _ceiling_ahead = check_tilemap_collision(0, _step - _buffer_distance);
                
                if (_ceiling_ahead) {
                    // If moving up and about to hit ceiling, stop just before it
                    var _dist_to_ceiling = 0;
                    // Find exact distance to ceiling
                    for (var i = 1; i <= abs(_step); i++) {
                        if (check_tilemap_collision(0, -i)) {
                            _dist_to_ceiling = i - 1; // Subtract 1 to stay one pixel away
                            break;
                        }
                    }
                    if (_dist_to_ceiling > 0) {
                        y -= _dist_to_ceiling;
                    }
                    vel_y = 0;
                    break;
                }
            } else if (_move_dir_y > 0) { // Moving downward
                // Check for ground collision
                if (check_tilemap_collision(0, _step)) {
                    y = floor(y);
                    vel_y = 0;
                    grounded = true;
                    state = CHARACTER_STATE.IDLE;
                    sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                    break;
                }
            }
        } else {
            // Normal collision check for non-jetpack states
            if (check_tilemap_collision(0, _step)) {
                vel_y = 0;
                break;
            }
        }
        
        // Platform collision check
        var _platform = instance_place(x, y + _step, obj_collision);
        if (_platform != noone) {
            if (_move_dir_y > 0 && bbox_bottom <= _platform.bbox_top) {
                y = _platform.bbox_top - (bbox_bottom - y);
                vel_y = 0;
                grounded = true;
                if (state == CHARACTER_STATE.JETPACK_JUMP) {
                    state = CHARACTER_STATE.IDLE;
                    sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                }
                break;
            } else if (object_index != obj_player) {
                vel_y = 0;
                break;
            }
        }
        
        y += _step;
        _remaining_move -= _step;
    }

    // Additional safety check for ceiling
    if (state == CHARACTER_STATE.JETPACK_JUMP) {
        if (check_tilemap_collision(0, 0)) {
            // Find safe position below
            var _safe_distance = 1;
            while (check_tilemap_collision(0, _safe_distance) && _safe_distance < 32) {
                _safe_distance++;
            }
            if (_safe_distance < 32) {
                y += _safe_distance;
                vel_y = 0;
            }
        }
    }
}

function check_collision(_move_x, _move_y) {
    // Check tilemap obstacles first
    if (global.collision_grid.CheckObstacleCollision(
        bbox_left + _move_x, bbox_right + _move_x,
        bbox_top + _move_y, bbox_bottom + _move_y
    )) {
        return true;
    }

    // Then check platforms
    var _platform = global.collision_grid.CheckPlatformCollision(
        bbox_left + _move_x, bbox_right + _move_x,
        bbox_top + _move_y, bbox_bottom + _move_y
    );

    if (_platform != noone) {
        if (object_index != obj_player) return true;
        
        // Player-specific platform handling
        if (vel_y < 0) return false; // Allow jumping through
        if (keyboard_check(vk_down) && vel_y >= 0) return false; // Allow dropping through
        if (vel_y > 0 && bbox_bottom <= _platform.bbox.top) return true; // Land on top
    }

    return false;
}

// Additional platform-specific movement for player (add after verticle movement check)
function jump_thru_platform() {
    if (object_index != obj_player) return;
    
    var _platform = instance_place(x, y, obj_collision);
    if (_platform != noone) {
        var _dist_to_platform_top = bbox_bottom - _platform.bbox_top;
        var _dist_to_platform_bottom = _platform.bbox_bottom - bbox_top;
        var _coyote_threshold = 8;
        
        // Moving upward through platform
        if (vel_y < 0) {
            // Allow passing through
            return;
        }
        
        // Pressing down to fall through platform
        if (keyboard_check(vk_down) && vel_y >= 0 && grounded) {
            y += 1; // Small push to initiate fall
            grounded = false;
            return;
        }
        
        // Handle landing on platform
        if (_dist_to_platform_top <= _coyote_threshold && vel_y >= 0) {
            y = _platform.bbox_top - (bbox_bottom - y);
            vel_y = 0;
            grounded = true;
        }
    }
}

function check_tilemap_collision(_move_x, _move_y) {
    // Check tilemap obstacles only (not platforms)
    return global.collision_grid.CheckObstacleCollision(
        bbox_left + _move_x, 
        bbox_right + _move_x,
        bbox_top + _move_y, 
        bbox_bottom + _move_y
    );
}

// Utility function to smoothly approach a value
function approach(_current, _target, _amount) {
    if (_current < _target) {
        return min(_current + _amount, _target);
    } else {
        return max(_current - _amount, _target);
    }
}


/**
 * Checks for ground within a specified distance below the instance
 * @param {real} max_distance Maximum distance to check downward
 * @returns {boolean} True if ground was found
 */
function find_ground_below(_max_distance) {
    for(var i = 0; i < _max_distance; i++) {
        if (check_collision(0, i)) {
            return true;
        }
    }
    return false;
}

/**
 * Checks if there's enough horizontal clearance at current position
 * @param {real} clearance Amount of horizontal space needed
 * @returns {boolean} True if there's enough clearance
 */
function has_horizontal_clearance(_clearance) {
    return !check_collision(_clearance, 0) && !check_collision(-_clearance, 0);
}

/**
* Checks if calling entity is on ground
* @returns {bool} True if is on ground
*/
function is_on_ground() {
    // Check for collision one pixel below
    return check_collision(0, 1);
}


function is_moving_upwards() {
    return (vel_y < 0);
}

/**
 * Applies knockback force while respecting collisions
 * @param {real} _direction Direction in degrees
 * @param {real} _speed Knockback speed
 */
function apply_knockback_movement(_vel_x) {
    var _remaining_move = _vel_x;
    var _move_dir = sign(_vel_x);
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(abs(_remaining_move), move_speed) * _move_dir;
        var _collision_found = check_collision(_step, 0);
        
        if (!_collision_found) {
            x += _step;
            _remaining_move -= _step;
        } else {
            // Stop knockback if we hit a wall
            return 0;
        }
    }
    
    // Return the remaining velocity after movement
    return _vel_x * 0.8; // Apply some dampening when hitting walls
}
// used at move to last seen to check if object can reach the x position
function can_reach_position(_target_x) {
    // Check if there's a direct path to the target
    var _step_size = 16; // Adjust this value based on your game's scale
    var _start_x = x;
    var _direction = sign(_target_x - _start_x);
    var _current_x = _start_x;
    
    while (abs(_target_x - _current_x) > _step_size) {
        // Check for wall collision
        if (check_collision(_step_size * _direction, 0)) {
            return false;
        }
        _current_x += _step_size * _direction;
    }
    
    // Check final step
    return !check_collision(_target_x - _current_x, 0);
}
