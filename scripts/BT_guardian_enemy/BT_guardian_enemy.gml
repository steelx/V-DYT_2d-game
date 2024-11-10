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
            var _in_view_arc = false;
            if (image_xscale > 0) {
                _in_view_arc = (_dir_to_player >= 270 || _dir_to_player <= 90);
            } else if (image_xscale < 0) {
                _in_view_arc = (_dir_to_player >= 90 && _dir_to_player <= 270);
            }
            
            if (!_player_above && _within_range && _in_view_arc) {
                last_seen_player_x = obj_player.x;
                _result = BTStates.Success;
            }
        }
        
        return _result;
    }
}

function GuardianAttackTask() : BTreeLeaf() constructor {
    name = "Guardian Attack Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
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
            
            return BTStates.Failure; // Can't attack, let chase happen
        }
    }
}

function GuardianChaseTask(_move_speed) : BTreeLeaf() constructor {
    name = "Guardian Chase Task";
    chase_speed = _move_speed;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            var _dist = distance_to_object(obj_player);
            
            // If in attack range, let attack task take over
            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Failure; // Important: Return FAILURE so selector tries attack
            }
            
            // If too far, stop chasing
            if (_dist >= visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }
            
            // Continue chase
            sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            vel_x = other.chase_speed * sign(obj_player.x - x);
            image_xscale = sign(vel_x);
            return BTStates.Running;
        }
    }
}


// Add detection to patrol task
function GuardianPatrolTask(_move_speed) : BTreeLeaf() constructor {
    name = "Guardian Patrol Task";
    patrol_speed = _move_speed;
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            // First check if player is detected
            if (check_player_visibility()) {
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
