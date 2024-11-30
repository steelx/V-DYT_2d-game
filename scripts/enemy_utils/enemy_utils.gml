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
function generate_search_path(_patrol_width, _search_point_spacing) {
    ds_list_clear(search_path_points);
    
    // Generate points in a zigzag pattern
    var _points = ceil(_patrol_width / _search_point_spacing);
    var _start_x = x - _patrol_width/2;
    
    for (var i = 0; i <= _points; i++) {
        var _point_x = _start_x + (i * _search_point_spacing);
        ds_list_add(search_path_points, _point_x);
    }
}


function player_detected(_can_see_player_in_air = false) {
	if (!instance_exists(obj_player)) return false;
    var _player_above = obj_player.y < y - sprite_height/2;
    var _is_visible = player_within_range(visible_range);
	if (_can_see_player_in_air) return _is_visible;
    return (_is_visible && !_player_above);
}

function move_to_point(_target_x, _speed) {
    var _direction = sign(_target_x - x);
    vel_x = _speed * _direction;
    image_xscale = _direction;
    sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
}
