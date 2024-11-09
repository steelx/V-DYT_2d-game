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

function check_player_visibility() {
    var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;
    return !_player_above && is_player_visible(visible_range);
}

function check_player_attackable() {
    var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;
    return !_player_above && can_attack && is_player_in_attack_range(attack_range);
}

function perform_attack_sequence(_alarm_index = 4, _alarm_attack_seq = 3) {
    can_attack = false;
    alarm[_alarm_index] = attack_delay;
    var _attack_object_x = 40;
    var _attack_object_width = 10;
    
    if (move_to_attack_position(obj_player.xprevious, _attack_object_x, _attack_object_width)) {
        alarm[_alarm_attack_seq] = 1;
        return false;
    }
    
    state = CHARACTER_STATE.ATTACK;
    return true;
}

function handle_patrol_movement() {
    var _distance_from_start = abs(x - xstart);
    if (_distance_from_start > patrol_width) {
        var _return_direction = sign(xstart - x);
        enemy_move_to(xstart, move_speed);
        image_xscale = _return_direction;
        return true;
    }
    return false;
}



function reset_roam_count() {
    roam_count = roam_count_max * choose(2, 3);
}

function handle_idle_state(_sprite_idle = spr_guardian_idle) {
    vel_x = 0;
    sprite_index = _sprite_idle;
    
    if (check_player_visibility()) {
        transition_to_chase();
        return;
    }
    
    // Debug
    show_debug_message("Roam count: " + string(roam_count));
    
    if (roam_count > 0) {
        roam_count--;
    }
    
    if (roam_count <= 0) {
        show_debug_message("Roam check triggered"); // Debug
        if (random(1) < move_chance) {
            show_debug_message("Transitioning to MOVE state"); // Debug
            state = CHARACTER_STATE.MOVE;
            enemy_random_move_v2(move_speed, 9);
            sprite_index = spr_guardian_walk;
        } else {
            show_debug_message("Staying in IDLE state"); // Debug
            reset_roam_count();
        }
    }
}


#region transition state / parent

function transition_to_chase() {
    transition_to_state(CHARACTER_STATE.CHASE);
    last_seen_player_x = obj_player.x;
}

function transition_to_alert() {
    transition_to_state(CHARACTER_STATE.ALERT);
    alert_count = alert_count_init;
}

function transition_to_idle() {
    transition_to_state(CHARACTER_STATE.IDLE);
    reset_roam_count();
}


// Add in Draw event if needed
function draw_debug_info() {
	draw_set_color(c_white);
    draw_text(x, y - 40, "State: " + obj_game._states[state]);
    draw_text(x, y - 60, "Roam Count: " + string(roam_count));
    draw_text(x, y - 80, "Vel X: " + string(vel_x));	
}

/// obj enemy parent specific
function get_last_state() {
	return prev_states[0];
}

function update_state_history(_new_state) {
    array_copy(prev_states, 1, prev_states, 0, 2);
    prev_states[0] = state;
}

function transition_to_state(_new_state) {
    update_state_history(_new_state);
    state = _new_state;
    sprite_index = sprites_map[$ _new_state];
}

#endregion