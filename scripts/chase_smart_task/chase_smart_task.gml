function ChaseSmartTaskOld(_move_speed, _jump_force, _jump_height) : BTreeLeaf() constructor {
    name = "Chase Smart Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    jump_height = _jump_height;
    ray_length = 100; // Length of the ray to cast ahead
    ray_count = 8; // Number of rays to cast
    ray_angle_spread = 80; // Angle spread for the rays (in degrees)
    obstacle_ahead_threshold = 32; // Threshold to detect obstacle ahead
    instance_ref = noone; // Reference to the enemy instance

    static Init = function() {
        var _user = black_board_ref.user;
        with(_user) {
            if (!variable_instance_exists(id, "last_seen_player_x")) {
                variable_instance_set(id, "last_seen_player_x", noone);
            }
        }
        instance_ref = _user; // Assign the enemy instance
    }

    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) {
            return BTStates.Failure;
        }

        with(_user) {
            var _dist = distance_to_object(obj_player);
            // Check attack range first to prevent flickering
            if (_dist <= attack_range) {
                vel_x = 0;
                sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                return BTStates.Success;
            }
            
            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }
			
			// Check if player is above on a high platform
            var _player_height_diff = obj_player.y - y;
            if (_player_height_diff < other.jump_height && abs(obj_player.x - x) < sprite_width) {
                vel_x = 0;
                last_seen_player_x = obj_player.x;
                return BTStates.Failure; // This will trigger the alert sequence
            }

            // Determine direction to player
            var _player_x = obj_player.x;
            var _player_y = obj_player.y;
            var _move_dir = sign(_player_x - x);

            // Check for obstacle ahead
            var _obstacle_ahead = other.check_obstacle_ahead(id, _move_dir, other.obstacle_ahead_threshold);

            if (_obstacle_ahead) {
                // Ray casting to check for jump opportunities
                var _has_jump_opportunity = false;
                var _jump_target_x = x;
                var _jump_target_y = y;

                for (var i = 0; i < other.ray_count; i++) {
                    var _angle = (-other.ray_angle_spread / 2) + (i * (other.ray_angle_spread / (other.ray_count - 1)));
                    var _ray_length = other.ray_length;

                    // Adjust start point based on image_xscale
                    var _start_x = x + (image_xscale > 0 ? bbox_right : bbox_left);
                    var _ray_x = _start_x + (cos(degtorad(_angle)) * _ray_length);
                    var _ray_y = y + (sin(degtorad(_angle)) * _ray_length);

                    var _land_x = 0;
                    var _land_y = 0;

                    var _steps = 10;
                    var _found = false;
                    for (var j = 0; j <= _steps; j++) {
                        var _check_x = lerp(_start_x, _ray_x, j / _steps);
                        var _check_y = lerp(y, _ray_y, j / _steps);

                        if (check_collision(_check_x - x, _check_y - y)) {
                            _found = true;
                            _land_x = _check_x;
                            _land_y = _check_y;
                            break;
                        }
                    }

                    if (_found) {
                        var _height_diff = _land_y - y;
                        if (_height_diff <= other.jump_height && _height_diff > 0) {
                            _has_jump_opportunity = true;
                            _jump_target_x = _land_x;
                            _jump_target_y = _land_y;
                            break;
                        }
                    }
                }

                // Perform jump if possible
                if (_has_jump_opportunity) {
                    vel_y = -other.jump_force;
                    vel_x = approach(vel_x, other.chase_speed * _move_dir, 0.5);
                    image_xscale = _move_dir;
                    sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
                } else {
                    // Move horizontally towards player if no jump opportunity
                    vel_x = other.chase_speed * _move_dir;
                    image_xscale = _move_dir;
                    sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
                }
            } else {
                // Move horizontally towards player if no obstacle ahead
                vel_x = other.chase_speed * _move_dir;
                image_xscale = _move_dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            }

            last_seen_player_x = obj_player.x;
        }

        return BTStates.Running;
    }

    static Draw = function(_inst_id) {
        if (!instance_exists(_inst_id)) return;
        
        with(_inst_id) {
            var _start_x = x + (image_xscale > 0 ? bbox_right : bbox_left);
            
            // Draw ray casts
            for (var i = 0; i < other.ray_count; i++) {
                var _angle = (-other.ray_angle_spread / 2) + (i * (other.ray_angle_spread / (other.ray_count - 1)));
                var _ray_length = other.ray_length;
                var _ray_x = _start_x + (cos(degtorad(_angle)) * _ray_length);
                var _ray_y = y + (sin(degtorad(_angle)) * _ray_length);
                
                var _steps = 10;
                var _found = false;
                var _end_x = _ray_x;
                var _end_y = _ray_y;
                
                // Check for collision along the ray
                for (var j = 0; j <= _steps; j++) {
                    var _check_x = lerp(_start_x, _ray_x, j / _steps);
                    var _check_y = lerp(y, _ray_y, j / _steps);
                    if (check_collision(_check_x - x, _check_y - y)) {
                        _found = true;
                        _end_x = _check_x;
                        _end_y = _check_y;
                        break;
                    }
                }
                
                // Draw the ray
                draw_set_alpha(0.5);
                draw_line_color(
                    _start_x, y,
                    _end_x, _end_y,
                    _found ? c_red : c_green,
                    _found ? c_red : c_green
                );
                draw_set_alpha(1);
            }
        }
    }

    static Clean = function() {
        // Cleanup code if needed
    }

    static check_obstacle_ahead = function(_id, _move_dir, _obstacle_ahead_threshold) {
        with(_id) {
            for (var i = 1; i <= _obstacle_ahead_threshold; i++) {
                var _check_x = x + _move_dir * i;
                if (check_collision(_check_x - x, 0)) {
                    return true;
                }
            }
        }
        return false;
    }
}

function ChaseSmartTask(_move_speed, _jump_force, _jump_height) : BTreeLeaf() constructor {
    name = "Chase Smart Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    jump_height = _jump_height;
    ray_length = 100;
    ray_count = 8;
    ray_angle_spread = 80;
    obstacle_ahead_threshold = 32;
    instance_ref = noone;
    grid_look_ahead = 4; // How many grid cells to look ahead

    static Init = function() {
        var _user = black_board_ref.user;
        with(_user) {
            if (!variable_instance_exists(id, "last_seen_player_x")) {
                variable_instance_set(id, "last_seen_player_x", noone);
            }
        }
    }

    static Process = function() {
        // Main chase logic
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;

        with(_user) {
            var _dist = distance_to_object(obj_player);
            if (_dist <= attack_range) {
                vel_x = 0;
                sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                return BTStates.Success;
            }

            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }

            var _move_dir = sign(obj_player.x - x);
            var _obstacle_ahead = other.check_obstacle_ahead(id, _move_dir, other.obstacle_ahead_threshold);

            if (_obstacle_ahead) {
                // Try to find a jump path using the grid system
                if (other.find_jump_path(id, obj_player.x, obj_player.y)) {
                    vel_y = -other.jump_force;
                    vel_x = other.chase_speed * _move_dir;
                    sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
                } else {
                    // Fallback to regular movement if no jump path found
                    vel_x = other.chase_speed * _move_dir;
                    sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
                }
            } else {
                vel_x = other.chase_speed * _move_dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            }

            image_xscale = _move_dir;
            last_seen_player_x = obj_player.x;
        }

        return BTStates.Running;
    }

    static Draw = function(_inst_id) {
        if (!instance_exists(_inst_id)) return;
        
        with(_inst_id) {
            var _start_x = x + (image_xscale > 0 ? bbox_right : bbox_left);
            
            // Draw ray casts
            for (var i = 0; i < other.ray_count; i++) {
                var _angle = (-other.ray_angle_spread / 2) + (i * (other.ray_angle_spread / (other.ray_count - 1)));
                var _ray_length = other.ray_length;
                var _ray_x = _start_x + (cos(degtorad(_angle)) * _ray_length);
                var _ray_y = y + (sin(degtorad(_angle)) * _ray_length);
                
                var _steps = 10;
                var _found = false;
                var _end_x = _ray_x;
                var _end_y = _ray_y;
                
                // Check for collision along the ray
                for (var j = 0; j <= _steps; j++) {
                    var _check_x = lerp(_start_x, _ray_x, j / _steps);
                    var _check_y = lerp(y, _ray_y, j / _steps);
                    if (check_collision(_check_x - x, _check_y - y)) {
                        _found = true;
                        _end_x = _check_x;
                        _end_y = _check_y;
                        break;
                    }
                }
                
                // Draw the ray
                draw_set_alpha(0.5);
                draw_line_color(
                    _start_x, y,
                    _end_x, _end_y,
                    _found ? c_red : c_green,
                    _found ? c_red : c_green
                );
                draw_set_alpha(1);
            }
        }
    }

    static Clean = function() {
        // Cleanup code if needed
    }

	static check_obstacle_ahead = function(_id, _move_dir, _obstacle_ahead_threshold) {
	    with(_id) {
	        // Check immediate collisions first using existing system
	        for (var i = 1; i <= _obstacle_ahead_threshold; i++) {
	            var _check_x = x + _move_dir * i;
	            if (check_collision(_check_x - x, 0)) {
	                return true;
	            }
	        }
        
	        // Grid-based detection for longer range
	        if (instance_exists(global.collision_grid)) {
	            var _cell_size = global.collision_grid.cell_size;
	            var _current_cell_x = x div _cell_size;
	            var _current_cell_y = y div _cell_size;
            
	            for (var i = 1; i <= other.grid_look_ahead; i++) {
	                var _check_cell_x = _current_cell_x + (_move_dir * i);
	                if (!global.collision_grid.IsValidMove(_check_cell_x * _cell_size, _current_cell_y * _cell_size)) {
	                    return true;
	                }
	            }
	        }
	        return false;
	    }
	}

	static find_jump_path = function(_id, _target_x, _target_y) {
	    //if (global.collision_grid) return false;
    
	    with(_id) {
	        var _start_x = x;
	        var _start_y = y;
        
	        // First check if we need to jump (obstacle ahead)
	        if (other.check_obstacle_ahead(id, sign(_target_x - x), other.obstacle_ahead_threshold)) {
	            // Then check if we can make the jump
	            if (global.collision_grid.CanJumpTo(_start_x, _start_y, _target_x, _target_y)) {
	                return true;
	            }
	        }
	        return false;
	    }
	}
}