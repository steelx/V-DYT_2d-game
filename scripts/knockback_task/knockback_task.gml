
function KnockbackTask() : BTreeLeaf() constructor {
    name = "Knockback Task";
    is_active = false;
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
			if !variable_instance_exists(_user, "knockback_sequence") {
				variable_instance_set(_user, "knockback_sequence", noone);
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
            if (!other.is_active) {
                return BTStates.Failure;
            }
            
            // Apply knockback velocity with friction
            vel_x = 0;
            x += other.knockback_vel_x;
            other.knockback_vel_x = approach(other.knockback_vel_x, 0, other.knockback_friction);
			image_speed = 0;
            
            // Keep running until knockback completely stops
            if (abs(other.knockback_vel_x) < 0.1) {
                other.is_active = false;
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
        is_active = true;
        knockback_vel_x = lengthdir_x(_speed, _direction);
    }
}