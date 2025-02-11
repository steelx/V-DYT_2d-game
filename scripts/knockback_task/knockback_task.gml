
function KnockbackTask() : BTreeLeaf() constructor {
    name = "Knockback Task";
    knockback_vel_x = 0;
	knockback_friction = 0.5; // Adjust as needed
	
	_apply_knockback = function(_hit_direction, _knockback_speed = 2) {
	    // Trigger knockback through behavior tree
	    TriggerKnockback(_hit_direction, _knockback_speed);
	};
	
	static Init = function() {
		is_active = false;
        knockback_vel_x = 0;
		var _user = black_board_ref.user;
		with(_user) {
			if !variable_instance_exists(_user, "knockback_active") {
				variable_instance_set(_user, "knockback_active", false);
			}
			if !variable_instance_exists(_user, "apply_knockback") {
				variable_instance_set(_user, "apply_knockback", other._apply_knockback);
			}
		}
	}
    
    static Process = function() {
        var _user = black_board_ref.user;
        with(_user) {
            // If knockback hasn't been triggered, don't process (TriggerKnockback)
            if (!knockback_active) {
                return BTStates.Failure;
            }
            
            vel_x = 0;
			image_speed = 0;
			
			// Apply knockback movement with collision checking
			other.knockback_vel_x = apply_knockback_movement(other.knockback_vel_x);
            
            // Keep running until knockback completely stops
            if (abs(other.knockback_vel_x) < 0.1) {
                knockback_active = false;
                other.knockback_vel_x = 0;
				image_speed = 1;
                return BTStates.Failure; // Only exit knockback when it's completely done
            }
            
            // Stay in knockback state while active
            return BTStates.Running;
        }
    }
    
    // Method to trigger knockback from outside
    static TriggerKnockback = function(_direction, _speed) {
        black_board_ref.user.knockback_active = true;
        knockback_vel_x = lengthdir_x(_speed, _direction);
    }
}