function LittleNinjaIdleTask() : BTreeLeaf() constructor {
    name = "LittleNinja Idle Task";
	move_chance = 0.5;
	randomize();
    
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

function LittleNinjaPatrolTask(_move_speed, _patrol_width = 96) : BTreeLeaf() constructor {
    name = "Little Ninja Patrol Task";
    patrol_speed = _move_speed;
    patrol_width = _patrol_width;
    path = new PatrolPath();
    return_triggered = false;

    static Init = function() {
        var _user = black_board_ref.user;
        var _start_x = _user.x - patrol_width/2;
        path.GeneratePoints(_start_x, patrol_width);
        return_triggered = false;
        status = BTStates.Running;
    }

    static Process = function() {
        if (!instance_exists(obj_player)) return BTStates.Success;
        
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
					alarm[1] = idle_timer;
					can_move = false;
					return BTStates.Success;
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

    static Clean = function() {
        path.Clean();
    }
}
