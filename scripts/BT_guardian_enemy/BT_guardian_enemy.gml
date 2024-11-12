/// @description Guardian Enemy Behavior Tree Tasks
#region Patrol sequence
function GuardianIdleTask() : BTreeLeaf() constructor {
    name = "Guardian Idle Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        _user.vel_x = 0;
        _user.sprite_index = _user.sprites_map[$ CHARACTER_STATE.IDLE];
		
		with(_user) {
			if (check_player_visibility() or last_seen_player_x != noone) {
				last_seen_player_x = noone;
	            return BTStates.Failure; // Exit Patrol Sequence
	        }
        
	        if (roam_count > 0) {
	            roam_count--;
	            return BTStates.Running;
	        }
		}
        
        return BTStates.Success;
    }
}


function GuardianPatrolTask(_move_speed) : BTreeLeaf() constructor {
    name = "Guardian Patrol Task";
    patrol_speed = _move_speed;
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            // First check if player is detected
            if (check_player_visibility() or last_seen_player_x != noone) {
				last_seen_player_x = noone;
                return BTStates.Failure; // Exit patrol to allow combat sequence
            }
            
            var _distance_from_start = abs(x - xstart);
            
            if (_distance_from_start > patrol_width) {
                var _return_direction = sign(xstart - x);
                vel_x = other.patrol_speed * _return_direction;
                image_xscale = _return_direction;
            } else {
                vel_x = other.patrol_speed * image_xscale;
            }
            
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            return BTStates.Success;
        }
    }
}

#endregion

#region Combat seqeunce (ALL must Success)

function GuardianDetectPlayerTask(_visible_range) : BTreeLeaf() constructor {
    name = "Guardian Detect Player Task";
	visible_range = _visible_range;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            var _player_above = obj_player.y < y - sprite_height/2;
            var _within_range = distance_to_object(obj_player) < other.visible_range;
            // Check if player is in the correct direction based on facing
            var _in_view = is_player_facing();
            
            if (!_player_above and _within_range and _in_view) {
                // Should return Success if player is detected to continue combat sequence
                return BTStates.Success;
            }
        }
        
        // Return Failure if player not detected, allowing tree to try patrol sequence
        return BTStates.Failure;
    }
}

function GuardianCheckAttackRangeTask(_attack_range = 40): BTreeLeaf() constructor {
	name = "Guardian Attack Range Task";
	attack_range = _attack_range;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			var _dist = distance_to_object(obj_player);
            if (_dist <= other.attack_range) {
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
function GuardianAttackTask(_seqeunce_file, _animation_duration_seconds): BTreeLeaf() constructor {
    name = "Guardian Attack2 Task";
    
    // Animation management properties
    sequence_file = _seqeunce_file;
    sequence_layer = -1;
    active_sequence = noone;
    animation_timer = 0;
    animation_duration = get_room_speed() * _animation_duration_seconds;
	
	attack_cooldown = 0;
	attack_cooldown_duration = get_room_speed() * 2; // 2 seconds between attacks
    
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
            image_xscale = sign(obj_player.x - x);
            
            // Check if we're currently in an animation
            if (other.sequence_layer != -1) {
                // Update animation timer
                other.animation_timer--;
                
                if (other.animation_timer <= 0) {
                    // Animation duration finished, clean up
                    other.cleanup_sequence(_user);
                    
                    // Check if we can start another attack
                    if (other.attack_cooldown <= 0 && distance_to_object(obj_player) <= attack_range) {
                        other.start_sequence(id, other.sequence_file);
                        return BTStates.Running;
                    } else {
                        return BTStates.Failure; // Failure to allow Chase
                    }
                }
                return BTStates.Running;
            }
            // No active animation, check if we can start a new attack
            if (other.attack_cooldown <= 0) {
                // Start attack sequence
                other.start_sequence(id, other.sequence_file);
                return BTStates.Running;
            }
            
             // Failure, exit the Sequence -> next Chase Sequence
            return BTStates.Failure;
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
            if (_dist >= visible_range) {
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

// Knockback Task without state dependency
function GuardianKnockbackTask() : BTreeLeaf() constructor {
    name = "Guardian Knockback Task";
    is_active = false;
    knockback_vel_x = 0;
    
    static Start = function() {
        is_active = false;
        knockback_vel_x = 0;
    }
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            // If knockback hasn't been triggered, don't process
            if (!other.is_active) {
                return BTStates.Failure;// Failure to move to Combat
            }
            
            // Apply knockback velocity with friction
			vel_x = 0;
            x += other.knockback_vel_x;
            other.knockback_vel_x = approach(other.knockback_vel_x, 0, knockback_friction);
            
            // Check if knockback has ended
            if (abs(other.knockback_vel_x) < 0.1) {
                other.is_active = false;
                other.knockback_vel_x = 0;
                return BTStates.Failure;// Failure to move to Combat
            }
            
            // Override normal movement during knockback
            vel_x = 0;
            
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
