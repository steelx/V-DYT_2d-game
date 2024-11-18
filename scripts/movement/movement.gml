
function apply_verticle_movement() {
    var _move_count_y = abs(vel_y);
    var _move_dir_y = sign(vel_y);
    var _remaining_move = vel_y;
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(abs(_remaining_move), move_speed) * _move_dir_y;
        var _collision_found = check_collision(0, _step);
        
        if (!_collision_found) {
            y += _step;
            _remaining_move -= _step;
        } else {
            vel_y = 0;
            break;
        }
    }
}

function apply_horizontal_movement() {
    var _remaining_move = vel_x;
    var _move_dir = sign(vel_x);
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(abs(_remaining_move), move_speed) * _move_dir;
        var _collision_found = check_collision(_step, 0);
        
        if (!_collision_found) {
            x += _step;
            _remaining_move -= _step;
        } else {
            vel_x = 0;
            break;
        }
    }
}

// Utility function to smoothly approach a value
function approach(_current, _target, _amount) {
    if (_current < _target) {
        return min(_current + _amount, _target);
    } else {
        return max(_current - _amount, _target);
    }
}

// This function checks if the instance is colliding with an object, or a tile, at the current
// position + the given movement values (_move_x and _move_y).
// The function returns true if a collision was found, or false if a collision was not found.
function check_collision(_move_x, _move_y) {
    // Check for collision with obj_collision
    if (place_meeting(x + _move_x, y + _move_y, obj_collision)) {
        // If moving upwards, allow passing through
        if (object_index == obj_player && is_moving_upwards() && _move_y < 0)
        {
            // Check if the player's feet are above the platform
            var _inst = instance_place(x + _move_x, y + _move_y, obj_collision);
            if (_inst != noone && bbox_bottom <= _inst.bbox_top)
            {
                return false; // Allow passing through
            }
        }
        return true; // Collision found
    }

    // The function continues if there were no object collisions. In this case we check for tile
    // collisions, at each corner of the instance's bounding box.
    // This checks for tile collision at the top-left corner of the instance's mask
    var _left_top = tilemap_get_at_pixel(global.collision_tilemap, bbox_left + _move_x, bbox_top + _move_y);

    // This checks for tile collision at the top-right corner of the instance's mask
    var _right_top = tilemap_get_at_pixel(global.collision_tilemap, bbox_right + _move_x, bbox_top + _move_y);

    // This checks for tile collision at the bottom-right corner of the instance's mask
    var _right_bottom = tilemap_get_at_pixel(global.collision_tilemap, bbox_right + _move_x, bbox_bottom + _move_y);

    // This checks for tile collision at the bottom-left corner of the instance's mask
    var _left_bottom = tilemap_get_at_pixel(global.collision_tilemap, bbox_left + _move_x, bbox_bottom + _move_y);

    // The results of the above four actions were stored in temporary variables. If any of those variables were true, meaning a tile
    // collision was found at any given corner, we return true and end the function.
    if (_left_top or _right_top or _right_bottom or _left_bottom)
    {
        return true;
    }

    // If no tile collisions were found, the function continues.
    // In that case we return false, to indicate that no collisions were found, and the instance is free to move to the new position.
    return false;
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
