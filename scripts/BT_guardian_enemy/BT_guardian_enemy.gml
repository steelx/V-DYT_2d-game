/// @description Guardian Enemy Behavior Tree Tasks
function GuardianIdleTask() : BTreeLeaf() constructor {
    name = "Guardian Idle Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        _user.vel_x = 0;
        _user.sprite_index = _user.sprites_map[$ CHARACTER_STATE.IDLE];
        
        if (_user.roam_count > 0) {
            _user.roam_count--;
            return BTStates.Running;
        }
        
        return BTStates.Success;
    }
}


function GuardianDetectPlayerTask(_visible_range) : BTreeLeaf() constructor {
    name = "Guardian Detect Player Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        var _result = BTStates.Failure;
        
        with(_user) {
            var _player_above = obj_player.y < y - sprite_height/2;
            var _within_range = distance_to_object(obj_player) < visible_range;
            var _dir_to_player = point_direction(x, y, obj_player.x, obj_player.y);
            
            // Check if player is in the correct direction based on facing
            var _in_view_arc = is_player_facing();
            
            if (!_player_above && _within_range && _in_view_arc) {
                last_seen_player_x = obj_player.x;
                _result = BTStates.Success;
            }
        }
        
        return _result;
    }
}

// 1 Attack task is part of combat selector, 
// which mean if Failure it will go next in selector, and Success means goes back to Detector state
function GuardianAttackTask() : BTreeLeaf() constructor {
    name = "Guardian Attack Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
			if (instance_exists(active_attack_sequence)) {
				return BTStates.Success;
			}
			
            var _dist = distance_to_object(obj_player);
            if (_dist <= attack_range && can_attack) {
                // Stop and face player
                vel_x = 0;
                image_xscale = sign(obj_player.x - x);
                
                // Start attack
                can_attack = false;
                alarm[4] = attack_delay;
                start_animation(seq_guardian_attack);
                return BTStates.Running;
            }
            
            return BTStates.Success; // Choose next in Selector, Chase
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
                return BTStates.Success;
            }
			
			// If in attack range, Failure goes back to Detect seq, and comes back to Attack
			// Since Attack is 1st node in selector
            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Failure;
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

