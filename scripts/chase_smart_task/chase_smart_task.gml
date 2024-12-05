function ChaseSmartTask(_move_speed, _jump_force, _jump_height) : BTreeLeaf() constructor {
    name = "Chase Smart Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    jump_height = _jump_height;
    ray_length = 100;
    ray_count = 8;
    ray_angle_spread = 80;
    obstacle_ahead_threshold = 32;
    grid_look_ahead = 4;

    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            var _dist = distance_to_object(obj_player);
            if (_dist <= attack_range) or (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }
            
            // Check if player is directly above on a platform
            var _player_height_diff = obj_player.y - y;
            var _horizontal_dist = abs(obj_player.x - x);
            if (_player_height_diff < -other.jump_height && _horizontal_dist < sprite_width) {
                // Check if there's an obstacle between player and enemy
                var _obstacle = global.collision_grid.GetObstacleAtPosition(x, obj_player.y);
                if (_obstacle != noone) {
                    vel_x = 0;
                    last_seen_player_x = obj_player.x;
                    return BTStates.Failure; // Trigger alert sequence instead
                }
            }
            
            var _move_dir = sign(obj_player.x - x);
            var _obstacle_ahead = other.check_obstacle_ahead(id, _move_dir, other.obstacle_ahead_threshold);
			var _player_above = obj_player.y < y - sprite_height/2;
            
            if (_obstacle_ahead) {
                // Try to find a jump path using the grid system
                if (global.collision_grid.CanJumpTo(x, y, obj_player.x, obj_player.y)) {
                    vel_y = -other.jump_force;
                    vel_x = other.chase_speed * _move_dir;
                    sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
                } else {
                    // Find alternative path or maintain distance
                    var _min_chase_distance = 32; // Minimum distance to maintain
                    if (_horizontal_dist < _min_chase_distance) {
                        vel_x = -other.chase_speed * _move_dir; // Move away slightly
                    } else {
                        vel_x = other.chase_speed * _move_dir;
                    }
                    sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
                }
            } else if (!_player_above) {
                vel_x = other.chase_speed * _move_dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            }
            
            image_xscale = _move_dir;
            last_seen_player_x = obj_player.x;
        }
        
        return BTStates.Running;
    }
    
    static check_obstacle_ahead = function(_id, _move_dir, _obstacle_ahead_threshold) {
        with(_id) {
            // Check immediate obstacles using collision grid
            var _current_cell_x = x div global.collision_grid.cell_size;
            var _current_cell_y = y div global.collision_grid.cell_size;
            
            // Check a few cells ahead
            for(var i = 1; i <= other.grid_look_ahead; i++) {
                var _check_x = x + (_move_dir * i * global.collision_grid.cell_size);
                var _obstacle = global.collision_grid.GetObstacleAtPosition(_check_x, y);
                
                if (_obstacle != noone) {
                    return true;
                }
                
                // Also check grid for tile-based obstacles
                if (!global.collision_grid.IsValidMove(_check_x, y)) {
                    return true;
                }
            }
            
            return false;
        }
    }
    
    static Draw = function(_inst_id) {
        if (!instance_exists(_inst_id)) return;
        
        with(_inst_id) {
            draw_set_alpha(0.5);
            
            // Draw chase range
            draw_circle_color(x, y, other.ray_length, c_blue, c_blue, true);
            
            // Draw direction to player if visible
            if (instance_exists(obj_player)) {
                draw_line_color(x, y, obj_player.x, obj_player.y, c_green, c_green);
            }
            
            draw_set_alpha(1);
        }
    }
}
