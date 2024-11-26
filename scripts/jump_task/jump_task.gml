/// @desc JumpChase Task: Extends chase behavior with platform jumping
function JumpChaseTask(_move_speed, _jump_force) : BTreeLeaf() constructor {
    name = "Jump Chase Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        // If not jumping, continue with regular chase behavior
        with (_user) {
			// Check if player is on a platform above us
	        if (is_player_on_platform_above()) {
	            // Jump towards the player
	            if (perform_jump(jump_force)) {
	                // Successfully started jumping, continue chasing
	                return BTStates.Running;
	            }
	        }
			
            var _dist = distance_to_object(obj_player);
            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }
            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Success;
            }
            // Chase the player
            vel_x = other.chase_speed * sign(obj_player.x - x);
            image_xscale = sign(vel_x);
            return BTStates.Running;
        }
    }
}

/// @desc Checks if the player is on a platform above the enemy
function is_player_on_platform_above() {
    // Raycast up from the enemy's position to detect platforms
    var _ray_length = 64; // Adjust based on your platform heights
    var _platform_found = false;
    
    // Check if the player is within a reasonable horizontal distance
    if (abs(obj_player.x - x) < visible_range) {
        // Perform the raycast
        with (obj_player) {
            if (place_meeting(x, y - _ray_length, obj_platform)) {
                _platform_found = true;
            }
        }
    }
    
    return _platform_found;
}

/// @desc Attempts to perform a jump with the given force
function perform_jump(_jump_force) {
    if (is_on_ground()) {
        vel_y = -_jump_force;
        return true;
    }
    return false;
}
