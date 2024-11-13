function is_player_facing(_obj = obj_player) {
    if (!instance_exists(_obj)) return false;
    
    var _dir_to_player = point_direction(x, y, _obj.x, _obj.y);
    var _facing_right = (image_xscale > 0);
    var _facing_left = (image_xscale < 0);
    
    if (_facing_right) {
        return (_dir_to_player >= 270 || _dir_to_player <= 90);
    } else if (_facing_left) {
        return (_dir_to_player >= 90 && _dir_to_player <= 270);
    }
    
    return false;
}


function player_within_range(_range) {
    return instance_exists(obj_player) and distance_to_object(obj_player) < _range
}

function is_player_visible(_visible_range = 32) {
    return player_within_range(_visible_range) and is_player_facing();
}

function is_player_in_attack_range(_attack_range = 16) {
    return player_within_range(_attack_range);
}

/// @function is_player_visible_direction(range, direction)
/// @param {real} _range The range to check for player visibility
/// @param {real} _direction The direction to check (-1 for left, 1 for right)
function is_player_visible_direction(_range, _direction) {
    if (!instance_exists(obj_player)) return false;
    
    var _player_x = obj_player.x;
    var _player_y = obj_player.y;
    
    // Check if player is within the vertical range
    if (abs(_player_y - y) > sprite_height/2) return false;
    
    // Check if player is within the horizontal range and in the correct direction
    var _distance = _player_x - x;
    return (sign(_distance) == _direction) && (abs(_distance) <= _range);
}

function draw_visibility_ray(_visible_range, _attack_range) {
    draw_set_alpha(0.2);
    draw_rectangle_color(
        x - _visible_range, y - sprite_height,
        x + _visible_range, y,
        c_yellow, c_yellow, c_yellow, c_yellow,
        false
    );
    draw_rectangle_color(
        x - _attack_range, y - sprite_height,
        x + _attack_range, y,
        c_red, c_red, c_red, c_red,
        false
    );
    draw_set_alpha(1);
}

/// @desc: make sure obj_enemy_parent has `search_path_points` variable!
function generate_search_path() {
    ds_list_clear(search_path_points);
    
    // Generate points in a zigzag pattern
    var _points = ceil(patrol_width / search_point_spacing);
    var _start_x = x - patrol_width/2;
    
    for (var i = 0; i <= _points; i++) {
        var _point_x = _start_x + (i * search_point_spacing);
        ds_list_add(search_path_points, _point_x);
    }
}
