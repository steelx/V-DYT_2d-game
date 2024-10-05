
function apply_verticle_movement() {
    var _move_count_y = abs(vel_y);
    var _move_dir_y = sign(vel_y);
    
    repeat (_move_count_y) {
        var _collision_found = check_collision(0, _move_dir_y);
        if (!_collision_found)
        {
            y += _move_dir_y;
        }
        else
        {
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