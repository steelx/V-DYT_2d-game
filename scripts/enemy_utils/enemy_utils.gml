function player_within_range(_range) {
    return instance_exists(obj_player) and distance_to_object(obj_player) < _range
}

function is_player_visible(_visible_range = 32) {
    return player_within_range(_visible_range);
}

function is_player_in_attack_range(_attack_range = 16) {
    return player_within_range(_attack_range);
}
