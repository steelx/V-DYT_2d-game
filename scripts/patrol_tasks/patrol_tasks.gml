function IdleTask(_alarm_idx) : BTreeLeaf() constructor {
    name = "Idle Task";
	move_chance = 0.5;
	randomize();
	alarm_idx = _alarm_idx;
	_idle_timer = get_room_speed() * choose(2, 3);
	
	static Init = function() {
		var _user = black_board_ref.user;
		with(_user) {
			if !variable_instance_exists(_user, "can_move") {
				variable_instance_set(_user, "can_move", false);
			}
			if !variable_instance_exists(_user, "idle_timer") {
				variable_instance_set(_user, "idle_timer", other._idle_timer);
			}
			alarm[other.alarm_idx] = other._idle_timer;
		}
        status = BTStates.Running;
    }
	
	static SetIdleCanMove = function() {
		can_move = false;
		alarm[alarm_idx] = idle_timer;
	}
    
    static Process = function() {
        if (!instance_exists(obj_player)) return BTStates.Failure;

        var _user = black_board_ref.user;
        with(_user) {
			vel_x = 0;
			sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
			if (player_detected()) {
				image_xscale = sign(obj_player.x - x);
                // Failure; if player is detected to continue Combat sequence
                return BTStates.Failure;
            }
			
			if can_move and (random(1) > other.move_chance) {
				return BTStates.Success;// Go to Patrol
			}
        }
        
		return BTStates.Running;
    }
}

function PatrolTask(_move_speed, _patrol_width, _idle_alarm_idx) : BTreeLeaf() constructor {
    name = "Patrol Task";
    patrol_speed = _move_speed;
    patrol_width = _patrol_width;
    path = new PatrolPath();
    return_triggered = false;
	idle_alarm_idx = _idle_alarm_idx;
	
	static Init = function() {
        var _user = black_board_ref.user;
		var _start_x = _user.xstart - patrol_width/2;
        path.GeneratePoints(_start_x, patrol_width, 30);
        return_triggered = false;
        status = BTStates.Running;
		with(_user) {
			sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
		}
    }
    
    static Process = function() {
		if !instance_exists(obj_player) return BTStates.Success;// Idle

        var _user = black_board_ref.user;
        with(_user) {
            // Check player detection
            if (player_detected()) return BTStates.Failure;

            var _target_x = other.path.GetCurrentPoint();
            var _distance = abs(x - _target_x);

            // Update path position
            if (_distance < 5) {
                if (other.path.IsInReturnZone() && !other.return_triggered) {
                    other.path.MoveToEnd();
                    other.return_triggered = true;
					// run Idle
					alarm[other.idle_alarm_idx] = idle_timer;
					can_move = false;
					return BTStates.Success;// exit the Patrol Sequence
                } else {
                    if (other.return_triggered) {
                        other.path.MovePrevious();
                        if (other.path.current_index == 0) {
                            other.return_triggered = false;
                        }
                    } else {
                        other.path.MoveNext();
                    }
                }
            }

            // Move character
			move_to_point(_target_x, other.patrol_speed);
            return BTStates.Running;
        }
    }
    
	static Draw = function(_inst_id) {
        if (!instance_exists(_inst_id)) return;
        
        with(_inst_id) {
            draw_set_alpha(0.5);
            other.path.DrawPath(y);
            
            draw_set_alpha(1);
            other.path.DrawPoints(y, 0.5);
            
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }
}
