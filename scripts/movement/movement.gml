
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