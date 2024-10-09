function is_player_facing(_obj = obj_player) {
    if (!instance_exists(_obj)) return false;
    
    var _dir_to_player = point_direction(x, y, _obj.x, _obj.y);
    var _facing_right = (image_xscale > 0);
    var _facing_left = (image_xscale < 0);
    
    // Check if the archer is facing the correct direction
    return (_facing_right && _dir_to_player >= 270 && _dir_to_player <= 90) ||
        (_facing_left && (_dir_to_player >= 90 && _dir_to_player <= 270));
}

function player_within_range(_range) {
    return instance_exists(obj_player) and distance_to_object(obj_player) < _range
}

function is_player_visible(_visible_range = 32) {
    return player_within_range(_visible_range);
}

function is_player_in_attack_range(_attack_range = 16) {
    return player_within_range(_attack_range) and is_player_facing();
}
