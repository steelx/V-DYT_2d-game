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

function move_to_point(_target_x, _speed) {
    var _direction = sign(_target_x - x);
    vel_x = _speed * _direction;
    image_xscale = _direction;
    sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
}


/*
* player_detected Adds 3 ray casts:
* One from the enemy's head (80% of sprite height)
* One from the enemy's torso (50% of sprite height)
* One at a 45-degree upward angle (only if _can_see_player_in_air is true)
* Uses collision_line to check for obstacles (assuming obj_wall is your wall object)
* @returns {Boolean} true if at least one ray can see the player without hitting obstacles
*/
function player_detected(_visible_range, _can_see_player_in_air = false) {
    if (!instance_exists(obj_player)) return false;
    
    var _is_visible = player_within_range(_visible_range);
    if (!_is_visible) return false;
    
    var _collision_array = [obj_collision, global.collision_tilemap];
    
    // Always check head and torso rays
    var _rays_hit = perform_ray_checks(_collision_array, _visible_range, _can_see_player_in_air);
    
    // Check if at least one ray did not hit an obstacle
    return !_rays_hit.head && !_rays_hit.torso && (!_can_see_player_in_air || !_rays_hit.diagonal);
}

/*
* player_detected_debug
* Debug version of player_detected that draws the rays
*/
function player_detected_debug(_visible_range, _can_see_player_in_air = false) {
    if (!instance_exists(obj_player)) return;
    
    var _collision_array = [obj_collision, global.collision_tilemap];
    
    // Perform ray checks
    var _rays_hit = perform_ray_checks(_collision_array, _visible_range, _can_see_player_in_air, true);
}

// Helper function to perform ray checks
function perform_ray_checks(_collision_array, _visible_range, _can_see_player_in_air, _is_debug = false) {
    // Ray start positions
    var _ray_start_head_x = x;
    var _ray_start_head_y = y - sprite_height * 0.8;
    var _ray_start_torso_x = x;
    var _ray_start_torso_y = y - sprite_height * 0.5;
    
    // Perform collision checks
    var _hit_head = collision_line(_ray_start_head_x, _ray_start_head_y, 
                                  obj_player.x, obj_player.y,
                                  _collision_array, false, true);
                                  
    var _hit_torso = collision_line(_ray_start_torso_x, _ray_start_torso_y,
                                   obj_player.x, obj_player.y,
                                   _collision_array, false, true);
    
    var _hit_diagonal = false;
    
    if (_can_see_player_in_air) {
        var _diagonal_length = _visible_range;
        var _diagonal_angle = (image_xscale > 0) ? 45 : 135; // Adjusted angle for correct direction
        var _ray_end_x = x + lengthdir_x(_diagonal_length, _diagonal_angle);
        var _ray_end_y = y + lengthdir_y(_diagonal_length, _diagonal_angle);
        
        _hit_diagonal = collision_line(x, y, _ray_end_x, _ray_end_y,
                                       _collision_array, false, true);
    }
    
    // If this is a debug call, draw the rays
    if (_is_debug) {
        // Draw head ray
        draw_set_color(_hit_head ? c_red : c_lime);
        draw_line(x, _ray_start_head_y, obj_player.x, obj_player.y);
        
        // Draw torso ray
        draw_set_color(_hit_torso ? c_red : c_lime);
        draw_line(x, _ray_start_torso_y, obj_player.x, obj_player.y);
        
        // Draw diagonal ray if can see in air
        if (_can_see_player_in_air) {
            draw_set_color(_hit_diagonal ? c_red : c_lime);
            draw_line(x, y, _ray_end_x, _ray_end_y);
        }
        
        draw_set_color(c_white);
    }
    
    // Return an object with the hit status of each ray
    return {
        "head": _hit_head,
        "torso": _hit_torso,
        "diagonal": _hit_diagonal
    };
}
