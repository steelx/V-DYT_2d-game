function IdleTask(_alarm_idx, _ignore_player_in_air = false) : BTreeLeaf() constructor {
    name = "Idle Task";
	move_chance = 0.5;
	randomize();
	alarm_idx = _alarm_idx;
	_idle_timer = get_room_speed() * choose(2, 3);
	ignore_player_in_air = _ignore_player_in_air;
	
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
			if (player_detected(other.ignore_player_in_air)) {
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

function PatrolTask(_move_speed, _patrol_width, _idle_alarm_idx, _ignore_player_in_air = false) : BTreeLeaf() constructor {
    name = "Patrol Task";
    patrol_speed = _move_speed;
    patrol_width = _patrol_width;
    path = new PatrolPath();
    return_triggered = false;
	idle_alarm_idx = _idle_alarm_idx;
	ignore_player_in_air = _ignore_player_in_air;
	
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
            if (player_detected(other.ignore_player_in_air)) return BTStates.Failure;

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

function ReturnToOriginTask(_move_speed, _jump_force, _jump_height, _ignore_player_in_air = false) : BTreeLeaf() constructor {
    name = "Return To Origin Task";
    move_speed = _move_speed;
    jump_force = _jump_force;
    jump_height = _jump_height;
    ignore_player_in_air = _ignore_player_in_air;
    ray_length = 100;
    ray_count = 5;
    ray_angle_spread = 45;
    obstacle_ahead_threshold = 32;

    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
            // First check for player detection to allow combat interruption
            if (player_detected(other.ignore_player_in_air)) {
                vel_x = 0;
                image_xscale = sign(obj_player.x - x);
                return BTStates.Failure; // This will allow combat sequence to take over
            }

            var _dist_to_origin = abs(x - xstart);
            
            // If we're close enough to origin, consider it reached
            if (_dist_to_origin <= 16) {
                vel_x = 0;
                sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
                return BTStates.Success;
            }

            // Determine direction to origin
            var _move_dir = sign(xstart - x);
            
            // Check if we're stuck
            if (abs(vel_x) < 0.1 && is_on_ground()) {
                // If stuck and on ground, try to jump
                vel_y = -other.jump_force;
                sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
            }

            // Basic movement towards origin
            vel_x = other.move_speed * _move_dir;
            image_xscale = _move_dir;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];

            // Check for obstacle ahead
            var _obstacle_ahead = false;
            for (var i = 1; i <= other.obstacle_ahead_threshold; i++) {
                var _check_x = x + _move_dir * i;
                if (check_collision(_check_x - x, 0)) {
                    _obstacle_ahead = true;
                    break;
                }
            }

            if (_obstacle_ahead && is_on_ground()) {
                vel_y = -other.jump_force;
                sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
            }
        }
        
        return BTStates.Running;
    }

    static Draw = function(_inst_id) {
        if (!instance_exists(_inst_id)) return;
        
        with(_inst_id) {
            draw_set_color(c_yellow);
            draw_line(x, y, xstart, y);
            draw_set_color(c_white);
        }
    }
}
