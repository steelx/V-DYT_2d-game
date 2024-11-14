
function apply_verticle_movement() {
    var _move_count_y = abs(vel_y);
    var _move_dir_y = sign(vel_y);
    var _remaining_move = vel_y;
    
    while (abs(_remaining_move) >= 0.1) {
        var _step = min(1, abs(_remaining_move)) * _move_dir_y;
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
    var _move_count = abs(vel_x);
    var _move_dir = sign(vel_x);
    // The section below handles pixel-perfect collision checking.
    // It does collision checking twice, first on the X axis, and then on the Y axis.
    repeat (_move_count) {
        var _collision_found = check_collision(_move_dir, 0);
        if (!_collision_found) {
            x += _move_dir;
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