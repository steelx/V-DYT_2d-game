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


function draw_visibility_ray(_visible_range, _attack_range, _draw_degug = true) {
	// Draw the ray line
	var _ray_length = _visible_range;
	var _ray_direction = (image_xscale > 0) ? 0 : 180;
	var _ray_end_x = x + lengthdir_x(_ray_length, _ray_direction);
	var _ray_end_y = y - sprite_height / 2 + lengthdir_y(_ray_length, _ray_direction);
	var _ray_color = c_yellow;

	if (is_player_in_attack_range(_attack_range)) {
	    _ray_color = c_red;
	}

	draw_line_width_color(x, y - sprite_height / 2, _ray_end_x, _ray_end_y, 1, _ray_color, _ray_color);
	// Debug: draw visible and attack ranges
	if _draw_degug {
		draw_set_alpha(0.2);
		draw_circle_color(x, y, _visible_range, c_yellow, c_yellow, false);
		draw_circle_color(x, y, _attack_range, c_red, c_red, false);
		draw_set_alpha(1);
	}
}
