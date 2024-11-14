/// @description Guardian Enemy Behavior Tree Tasks
#region Patrol sequence
function GuardianIdleTask() : BTreeLeaf() constructor {
    name = "Guardian Idle Task";
	idle_timeout = get_room_speed() * 2;
	idle_timer = 0;
	
	static Init = function() {
		idle_timer = 0;
        status = BTStates.Running;
    }
    
    static Process = function() {
		if !instance_exists(obj_player) return BTStates.Success;
		idle_timer++;
        var _user = black_board_ref.user;
        _user.vel_x = 0;
        _user.sprite_index = _user.sprites_map[$ CHARACTER_STATE.IDLE];
		
		with(_user) {
			var _player_above = obj_player.y < (y - sprite_height/2);
			var _is_visible = player_within_range(visible_range/2);
			if (_is_visible and !_player_above) {
	            return BTStates.Failure; // Exit Patrol Sequence
	        }
		}

        return BTStates.Success;
    }
}

function GuardianPatrolTask(_move_speed, _patrol_width = 96, _point_spacing = 8) : BTreeLeaf() constructor {
    name = "Guardian Patrol Task";
    patrol_speed = _move_speed;
    current_point_index = 0;
    waypoint_radius = 2;
    waypoint_color = c_yellow;
    path_color = c_lime;
    patrol_width = _patrol_width;
    search_point_spacing = _point_spacing;
	
	patrol_timeout = get_room_speed() * 3;
	patrol_timer = 0;
	
	static Init = function() {
        patrol_timer = 0;
        var _user = black_board_ref.user;
        with(_user) {
            generate_search_path(other.patrol_width, other.search_point_spacing);
        }
		status = BTStates.Running;
    }
    
    static Process = function() {
		if !instance_exists(obj_player) return BTStates.Success;// Idle
		patrol_timer++;
        var _user = black_board_ref.user;
        with(_user) {
            // First check if player is detected
            var _player_above = obj_player.y < y - sprite_height/2;
            var _is_visible = player_within_range(visible_range);
            
            if (_is_visible and !_player_above) {
                return BTStates.Failure; // Exit patrol to allow combat sequence
            }
            
            // Get current target point
            var _target_point_x = ds_list_find_value(search_path_points, other.current_point_index);
            var _distance_to_point = point_distance(x, y, _target_point_x, y);
            
            // If close enough to current point, move to next point
            if (_distance_to_point < 5) {
                other.current_point_index++;
                if (other.current_point_index >= ds_list_size(search_path_points)) {
                    other.current_point_index = 0; // Loop back to start
                }
            }
            
			// Move towards the current point
			var _move_direction = sign(_target_point_x - x);
	        vel_x = other.patrol_speed * _move_direction;
            image_xscale = _move_direction;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            return BTStates.Success;
        }
    }
	
	Draw = function() {
		// Draw waypoints and path
        DrawWaypoints();
	}
    
    static DrawWaypoints = function() {
        var _user = black_board_ref.user;
        with(_user) {
            // Draw connecting lines between points
            draw_set_color(other.path_color);
            draw_set_alpha(0.5);
            
            var _size = ds_list_size(search_path_points);
            for(var i = 0; i < _size - 1; i++) {
                var _point1 = ds_list_find_value(search_path_points, i);
                var _point2 = ds_list_find_value(search_path_points, i + 1);
                draw_line_colour(_point1, y, _point2, y, c_red, c_green);
            }
            
            // Draw waypoints
            draw_set_color(other.waypoint_color);
            draw_set_alpha(1);
            
            for(var i = 0; i < _size; i++) {
                var _point = ds_list_find_value(search_path_points, i);
                
                // Current target point is bigger and different color
                if (i == other.current_point_index) {
                    draw_set_color(c_red);
                    draw_circle(_point, y, other.waypoint_radius + 2, false);
                    draw_set_color(other.waypoint_color);
                } else {
                    draw_circle(_point, y, other.waypoint_radius, false);
                }
            }
            
            // Reset draw properties
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }
}



#endregion

#region Combat Selector (Atleast 1 must Success)

function GuardianDetectPlayerTask() : BTreeLeaf() constructor {
    name = "Guardian Detect Player Task";
    
    static Process = function() {
        if (!instance_exists(obj_player)) return BTStates.Failure;

        var _user = black_board_ref.user;
        with(_user) {
			vel_x = 0;
			sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
			var _player_above = obj_player.y < y - sprite_height/2;
			var _is_visible = player_within_range(visible_range);
			
			if (_is_visible and !_player_above) {
				image_xscale = sign(obj_player.x - x);
                // Should return Success if player is detected to continue combat sequence
                return BTStates.Success;
            }
        }
        // Return Failure if player not detected, allowing tree to try patrol sequence
		return BTStates.Failure;
    }
}

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
}

function GuardianCheckAttackRangeTask(_attack_range = 40): BTreeLeaf() constructor {
	name = "Guardian Attack Range Task";
	attack_range = _attack_range;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			var _player_above = obj_player.y < y - sprite_height/2;
			var _dist = distance_to_object(obj_player);
            if (_dist <= other.attack_range and !_player_above) {
				return BTStates.Success;// Success means next in Sequence i.e. Attack
			}

			return BTStates.Failure;
		}
	}
}

/*
Attack Task is inside a Sequence (Combat Sequence),
and in a Sequence, if ANY child fails, the entire sequence fails (hence it would go to Patrol)
thats why if we need to go go Chase we need to return Success if player is not in attack range.
*/
function GuardianAttackTask(_seqeunce_file, _animation_duration_seconds = 1.5): BTreeLeaf() constructor {
    name = "Guardian Attack Task";
    
    // Animation management properties
    sequence_file = _seqeunce_file;
    sequence_layer = -1;
    active_sequence = noone;
    animation_timer = 0;
    animation_duration = get_room_speed() * _animation_duration_seconds;
	
	attack_cooldown = 0;
	attack_cooldown_duration = get_room_speed() * 1.5;
    
    static start_sequence = function(_user, _sequence) {
        sequence_layer = layer_create(_user.depth - 1);
        active_sequence = layer_sequence_create(sequence_layer, _user.x, _user.y, _sequence);
        layer_sequence_xscale(active_sequence, _user.image_xscale);
        animation_timer = animation_duration;
		
		// reset attack cooldown
		attack_cooldown = attack_cooldown_duration;
        
        // Disable the user object during animation
        with(_user) {
            enabled = false;
            vel_x = 0;
            vel_y = 0;
            image_alpha = 0;
        }
    }
    
    static cleanup_sequence = function(_user) {
        if (active_sequence != noone) {
            layer_sequence_destroy(active_sequence);
            active_sequence = noone;
        }
        if (sequence_layer != -1) {
            layer_destroy(sequence_layer);
            sequence_layer = -1;
        }
        
        // Re-enable the user object
        with(_user) {
            enabled = true;
            image_alpha = 1;
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_guardian_idle;
        }
    }
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Update attack cooldown
            if (other.attack_cooldown > 0) {
                other.attack_cooldown--;
            }
			
			// face player
			var _dir = sign(obj_player.x - x);
            image_xscale = _dir >= 0 ? 1 : -1;
            
            // Check if we're currently in an animation
            if (other.sequence_layer != -1) {
                // Update animation timer
                other.animation_timer--;
                
                if (other.animation_timer <= 0) {
                    // Animation duration finished, clean up
                    other.cleanup_sequence(_user);
                    
                    // After attack ends, always return Failure to allow chase
                    return BTStates.Failure;
                }
                return BTStates.Running;
            }
            
			if (other.attack_cooldown <= 0) {
                other.start_sequence(id, other.sequence_file);
                return BTStates.Running;
            }
			
			last_seen_player_x = obj_player.x;
            return BTStates.Success;// Now go to Move to attack position
        }
    }
    
    static OnTerminate = function() {
        // Clean up if task is terminated while animation is running
        if (active_sequence != noone) {
            cleanup_sequence(black_board_ref.user);
        }
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

#region Knockback

function GuardianKnockbackTask() : BTreeLeaf() constructor {
    name = "Guardian Knockback Task";
    is_active = false;
    knockback_vel_x = 0;
	knockback_friction = 0.5; // Adjust as needed
    
    static Start = function() {
        is_active = false;
        knockback_vel_x = 0;
    }
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            // If knockback hasn't been triggered, don't process
            if (!other.is_active) {
                return BTStates.Failure;
            }
            
            // Apply knockback velocity with friction
            vel_x = 0;
            x += other.knockback_vel_x;
            other.knockback_vel_x = approach(other.knockback_vel_x, 0, other.knockback_friction);
            
            // Keep running until knockback completely stops
            if (abs(other.knockback_vel_x) < 0.1) {
                other.is_active = false;
                other.knockback_vel_x = 0;
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


// Knockback Sequence Container
function GuardianKnockbackSequenceContainer() : BTreeSequence() constructor {
    name = "Guardian Knockback Sequence";
    
    // Create child tasks
    knockback_task = new GuardianKnockbackTask();
    //knockback_succeeder = new BTreeSucceeder();
    
    // Add children in sequence
    ChildAdd(knockback_task);
    //ChildAdd(knockback_succeeder);
    
    // Expose method to trigger knockback
    static TriggerKnockback = function(_direction, _speed) {
        knockback_task.TriggerKnockback(_direction, _speed);
    }
}
#endregion


#region Alert sequence

function GuardianCheckLastSeenTask() : BTreeLeaf() constructor {
    name = "Guardian Check Last Seen Task";
    
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
