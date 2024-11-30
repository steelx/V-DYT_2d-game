function ChaseTask(_move_speed) : BTreeLeaf() constructor {
    name = "Chase Task";
    chase_speed = _move_speed;
    path_check_interval = 16; // How often to check for path obstacles
    last_path_check = 0;
    last_valid_x = undefined;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            var _dist = distance_to_object(obj_player);
            
            // If too far, stop chasing
            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }
            
            // If in attack range
            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Success;
            }
            
            // Store last seen position
            last_seen_player_x = obj_player.x;
            sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            
            // Path checking logic
            var _current_time = current_time;
            if (_current_time - other.last_path_check > other.path_check_interval) {
                other.last_path_check = _current_time;
                
                // Check if there's a valid path to the player
                if (!global.collision_grid.IsPathClear(id, obj_player.x, obj_player.y)) {
                    // If we can't reach the player, store last valid position and fail
                    if (other.last_valid_x != undefined) {
                        last_seen_player_x = other.last_valid_x;
                        last_seen_player_y = y;
                    }
                    vel_x = 0;
                    return BTStates.Failure;
                }
                
                // Store this position as last valid
                other.last_valid_x = x;
            }
            
            // Calculate movement
            var _target_x = obj_player.x;
            var _move_dir = sign(_target_x - x);
            
            // Check immediate movement safety
            if (global.collision_grid.IsMovementSafe(id, _move_dir)) {
                vel_x = other.chase_speed * _move_dir;
                image_xscale = sign(vel_x);
            } else {
                vel_x = 0;
                return BTStates.Failure;
            }
            
            return BTStates.Running;
        }
    }
}
