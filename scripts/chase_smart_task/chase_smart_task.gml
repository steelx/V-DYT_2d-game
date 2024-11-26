/*
The ChaseSmartTask will:

Determine the direction to the player.
Cast rays to check for potential landing points for jumping.
Decide whether to jump or move horizontally based on the ray casting results.
*/
function ChaseSmartTask(_move_speed, _jump_force, _jump_height) : BTreeLeaf() constructor {
    name = "Chase Smart Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    jump_height = _jump_height;
    ray_length = 100; // Length of the ray to cast ahead
    ray_count = 5; // Number of rays to cast
    ray_angle_spread = 45; // Angle spread for the rays (in degrees)

    static Init = function() {
		var _user = black_board_ref.user;
		with(_user) {
			if !variable_instance_exists(id, "last_seen_player_x") {
				variable_instance_set(id, "last_seen_player_x", noone);
			}
		}
    }

    static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(_user) || !instance_exists(obj_player)) {
            return BTStates.Failure;
        }

        with(_user) {
            var _dist = distance_to_object(obj_player);

            if (_dist > visible_range) {
                vel_x = 0;
                return BTStates.Failure;
            }

            if (_dist <= attack_range) {
                vel_x = 0;
                return BTStates.Success;
            }

            // Determine direction to player
            var _player_x = obj_player.x;
            var _player_y = obj_player.y;
            var _move_dir = sign(_player_x - x);

            // Ray casting to check for jump opportunities
            var _has_jump_opportunity = false;
            var _jump_target_x = x;
            var _jump_target_y = y;

            for (var i = 0; i < other.ray_count; i++) {
                var _angle = (-other.ray_angle_spread / 2) + (i * (other.ray_angle_spread / (other.ray_count - 1)));
                var _ray_x = x + (cos(degtorad(_angle)) * other.ray_length);
                var _ray_y = y + (sin(degtorad(_angle)) * other.ray_length);

                var _land_x = 0;
                var _land_y = 0;

                var _steps = 10;
                var _found = false;
                for (var j = 0; j <= _steps; j++) {
                    var _check_x = lerp(x, _ray_x, j / _steps);
                    var _check_y = lerp(y, _ray_y, j / _steps);

                    if (check_collision(_check_x - x, _check_y - y)) {
                        _found = true;
                        _land_x = _check_x;
                        _land_y = _check_y;
                        break;
                    }
                }

                if (_found) {
                    var _height_diff = _land_y - y;
                    if (_height_diff <= other.jump_height && _height_diff > 0) {
                        _has_jump_opportunity = true;
                        _jump_target_x = _land_x;
                        _jump_target_y = _land_y;
                        break;
                    }
                }
            }

            // Perform jump if possible
            if (_has_jump_opportunity) {
                vel_y = -other.jump_force;
                vel_x = approach(vel_x, other.chase_speed * _move_dir, 0.5);
                image_xscale = _move_dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
            } else {
                // Move horizontally towards player
                vel_x = approach(vel_x, other.chase_speed * _move_dir, 0.5);
                image_xscale = _move_dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.CHASE];
            }

            last_seen_player_x = obj_player.x;
        }

        return BTStates.Running;
    }

    static Draw = function(_inst_id) {
        if (instance_exists(_inst_id)) {
            with(_inst_id) {
                draw_set_color(c_blue);

                for (var i = 0; i < other.ray_count; i++) {
                    var _angle = (-other.ray_angle_spread / 2) + (i * (other.ray_angle_spread / (other.ray_count - 1)));
                    var _ray_x = x + (cos(degtorad(_angle)) * other.ray_length);
                    var _ray_y = y + (sin(degtorad(_angle)) * other.ray_length);

                    draw_line(x, y, _ray_x, _ray_y);
                }

                draw_set_color(c_white);
            }
        }
    }

    static Clean = function() {
        // Cleanup code if needed
    }
}
