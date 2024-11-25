/// @description Guardian Enemy Behavior Tree Tasks

#region Combat Selector (Atleast 1 must Success)

function GuardianMovetoAttackPositionTask(_ideal_distance = 40) : BTreeLeaf() constructor {
    name = "Guardian Move to Attack Position Task";
    ideal_attack_distance = _ideal_distance;
    position_threshold = 10; // Tolerance range for positioning
    stored_target_x = noone; // Store the initial target position
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            if (!instance_exists(obj_player)) return BTStates.Failure;
            
            // Store the target position only when we start moving
            if (other.stored_target_x == noone) {
                other.stored_target_x = last_seen_player_x;
            }
            
            var _distance_to_target = point_distance(x, y, other.stored_target_x, y);
            var _direction_to_target = sign(other.stored_target_x - x);
            
            // Set facing direction regardless of movement
            image_xscale = _direction_to_target;
            
            // Check if we've reached the desired position
            if (abs(_distance_to_target - other.ideal_attack_distance) <= other.position_threshold) {
                vel_x = 0;
                sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                other.stored_target_x = noone; // Reset stored position
                return BTStates.Success; // Return Success to allow immediate attack
            }
            
            // Determine movement direction
            if (_distance_to_target < other.ideal_attack_distance) {
                // Too close, move away
                vel_x = -move_speed * _direction_to_target;
            } else {
                // Too far, move closer
                vel_x = move_speed * _direction_to_target;
            }
			
            return BTStates.Running;
        }
    }

    static OnTerminate = function() {
        stored_target_x = noone; // Reset stored position when task terminates
    }
	
	static Clean = function() {
        OnTerminate();
    }
}

#endregion
