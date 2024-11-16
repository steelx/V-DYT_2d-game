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

// 2 Chase task is part of combat selector (Only if Attack fails), 
// which mean if Failure it goes back to GuardianDetectPlayerTask
function GuardianChaseTask(_move_speed) : BTreeLeaf() constructor {
    name = "Guardian Chase Task";
    chase_speed = _move_speed;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            var _dist = distance_to_object(obj_player);
            
            // If too far, stop chasing
            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;// (1st fail goes to Attack Sequence, attack fail goes to Patrol)
            }
			
			// If in attack range, Failure goes back to Detect seq, and comes back to Attack
			// Since Attack is 1st node in selector
            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Success; // Success to try next in Combat Sequence
            }
            
            // Continue chase
			last_seen_player_x = obj_player.x;
            sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            vel_x = other.chase_speed * sign(obj_player.x - x);
            image_xscale = sign(vel_x);
            return BTStates.Running;
        }
    }
}

#endregion

#region Alert sequence

function GuardianCheckLastSeenTask() : BTreeLeaf() constructor {
    name = "Guardian Check Last Seen Task";
	
	static Init = function() {
		var _user = black_board_ref.user;
		if (variable_instance_exists(_user, "last_seen_player_x")) {
			variable_instance_set(_user, "last_seen_player_x", noone);
		}
	}
    
    static Process = function() {
		if (!instance_exists(obj_player)) return BTStates.Failure;
        var _user = black_board_ref.user;
        
        with(_user) {
			sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
            if (last_seen_player_x != noone) {
				return BTStates.Success;
            }
        }
        
        return BTStates.Failure;
    }
}

function GuardianMoveToLastSeenTask() : BTreeLeaf() constructor {
    name = "Guardian Move To Last Seen Task";
    
    static Process = function() {
		if (!instance_exists(obj_player)) return BTStates.Failure;
        var _user = black_board_ref.user;

        with(_user) {
            // Check if we reached the last seen position
            var _dist_to_last_seen = abs(x - last_seen_player_x);
            if (_dist_to_last_seen <= global.tile_size) { // Within 16 pixels threshold
                vel_x = 0;
                return BTStates.Success; // Move to search area task
            }
            
            // Move towards last seen position
            var _dir = sign(last_seen_player_x - x);
            vel_x = move_speed * _dir;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            
            return BTStates.Running;
        }
    }
}

function GuardianSearchAreaTask(_search_radius) : BTreeLeaf() constructor {
    name = "Guardian Search Area Task";
    search_radius = _search_radius;
    search_time = get_room_speed() * 3; // 3 seconds of searching
    current_search_time = 0;
    search_direction = 1;
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
			last_seen_player_x = noone;
			var _player_above = obj_player.y < y - sprite_height/2;
			var _is_visible = player_within_range(visible_range);
            // If we have a last seen position and player not in range
            if (_is_visible and !_player_above) {
                other.current_search_time = 0;
                return BTStates.Failure; // Go back to combat if player spotted
            }
            
			// not visible, continue search
            other.current_search_time++;
            
            // Alternate direction every second
            if (other.current_search_time % get_room_speed() == 0) {
                other.search_direction *= -1;
            }
            
            // Move back and forth in search area
            vel_x = other.search_direction * move_speed;
            image_xscale = other.search_direction;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            
            // If search time is up, clear last seen position and return to patrol
            if (other.current_search_time >= other.search_time) {
                other.current_search_time = 0;
                return BTStates.Success;
            }
            
            return BTStates.Running;
        }
    }
}

#endregion
