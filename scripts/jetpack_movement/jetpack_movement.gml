/// Helper Functions for Jetpack Movement

// Vertical Movement
function jetpack_vertical_movement(is_active, target_height = 0) {
    if (is_active) {
        vel_y = approach(vel_y, -jetpack.hover_strength, jetpack.acceleration * delta_time);
    } else {
        vel_y = approach(vel_y, 0, jetpack.deceleration * delta_time);
    }

    // Smooth vertical movement to target height
    var _vertical_distance = target_height - y;
    vel_y += _vertical_distance * 0.1;

    // Cap vertical velocity
    vel_y = clamp(vel_y, -jetpack.max_vertical_speed, jetpack.max_vertical_speed);
}

// Horizontal Movement
function jetpack_horizontal_movement(is_active) {
    var _input_x = (keyboard_check(vk_right) - keyboard_check(vk_left));

    if (is_active) {
        if (_input_x != 0) {
            jetpack.horizontal_momentum = approach(
                jetpack.horizontal_momentum,
                _input_x * jetpack.max_horizontal_speed,
                jetpack.acceleration * delta_time
            );
        } else {
            jetpack.horizontal_momentum = approach(
                jetpack.horizontal_momentum,
                0,
                jetpack.deceleration * delta_time
            );
        }
    } else {
        jetpack.horizontal_momentum = approach(jetpack.horizontal_momentum, 0, jetpack.deceleration * delta_time);
    }

    // Apply horizontal momentum
    vel_x = jetpack.horizontal_momentum;

    // Ensure horizontal speed is capped
    vel_x = clamp(vel_x, -jetpack.max_horizontal_speed, jetpack.max_horizontal_speed);
}

// Update Ground Reference
function jetpack_update_ground_reference() {
    var _ground_found = false;
    var _ground_y = y + jetpack.ground_check_distance;

    // Check for platforms first
    var _platform = global.collision_grid.GetNearestPlatformBelow(x, y, jetpack.ground_check_distance);
    if (_platform != noone) {
        _ground_y = _platform.bbox.top;
        _ground_found = true;
    }

    // If no platform found, check for solid ground
    if (!_ground_found) {
        var _obstacle = global.collision_grid.GetNearestObstacleBelow(x, y, jetpack.ground_check_distance);
        if (_obstacle != noone) {
            _ground_y = _obstacle.position.y;
            _ground_found = true;
        }
    }

    // Update ground reference with proper height adjustment
    if (_ground_found) {
        jetpack.ground_reference_y = _ground_y;
    } else {
        // When no ground is found, gradually lower the reference point
        jetpack.ground_reference_y = min(jetpack.ground_reference_y + 2, y + jetpack.min_height);
    }
}
