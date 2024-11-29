function DodgeTask(_dodge_alarm_idx, _attack_alarm_idx, _dodge_delay = 3, _dodge_sprite = undefined) : BTreeLeaf() constructor {
    name = "Dodge Task";
    attack_alarm_idx = _attack_alarm_idx;
    dodge_alarm_idx = _dodge_alarm_idx;
    dodge_delay = get_room_speed() * _dodge_delay;
    dodge_sprite = _dodge_sprite;
    
    // Dodge parameters
    dodge_initial_speed = 4;
    dodge_height = 32;      // Height of the dodge arc
    
    // State variables
    is_dodging = false;
    dodge_path = undefined;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            sprite_index = other.dodge_sprite == undefined ? sprites_map[$ CHARACTER_STATE.IDLE] : other.dodge_sprite;
            
            // Start new dodge
            if (!other.is_dodging) {
                // Check dodge conditions
			    if (alarm[other.dodge_alarm_idx] > 0 || alarm[other.attack_alarm_idx] <= 0) {
			        return BTStates.Failure;
			    }
    
			    // Initialize dodge path
			    var _dir = sign(x - obj_player.x);
			    if (_dir == 0) _dir = image_xscale;
    
			    var _dodge_distance = 64; // Adjust this value as needed
			    var _end_x = x + (_dodge_distance * _dir);
    
			    // Create and setup arch path
			    other.dodge_path = new ArcPath();
			    other.dodge_path._inst = _user; // Set the blackboard reference
    
			    // Try to generate the path
			    if (!other.dodge_path.GenerateArc(
			        x, y,                  // Start position
			        _end_x, y,             // End position
			        other.dodge_height,    // Arc height
			        15                     // Number of points
			    )) {
			        // Path generation failed, clean up and return failure
			        other.dodge_path.Clean();
			        other.dodge_path = undefined;
			        return BTStates.Failure;
			    }
    
			    // Start dodge
			    other.is_dodging = true;
			    sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
			    image_xscale = _dir;
			    alarm[other.dodge_alarm_idx] = other.dodge_delay;
			    play_priority_sound(snd_enemy_dodge, SoundPriority.COMBAT);
            }
            
            // Process ongoing dodge
            if (other.is_dodging) {
                var _current_point = other.dodge_path.GetCurrentPoint();
                if (_current_point == undefined) {
                    other.is_dodging = false;
                    other.dodge_path.Clean();
                    other.dodge_path = undefined;
                    return BTStates.Success;
                }
                
                // Move to next point
                x = _current_point.x;
                y = _current_point.y;
                
                // Check if we're about to fall
                var _next_point = other.dodge_path.GetNextPoint();
                if (_next_point != noone) {
                    // Temporarily move to check ground
                    var _orig_x = x, _orig_y = y;
                    x = _next_point.x;
                    y = _next_point.y;
                    
                    // Check for ground below
                    var _found_ground = false;
                    for(var i = 0; i < 32; i++) {
                        if (check_collision(0, i)) {
                            _found_ground = true;
                            break;
                        }
                    }
                    
                    // Reset position
                    x = _orig_x;
                    y = _orig_y;
                    
                    // If no ground found, stop dodging
                    if (!_found_ground) {
                        other.is_dodging = false;
                        other.dodge_path.Clean();
                        other.dodge_path = undefined;
                        return BTStates.Success;
                    }
                }
                
                if (!other.dodge_path.MoveNext()) {
                    other.is_dodging = false;
                    other.dodge_path.Clean();
                    other.dodge_path = undefined;
                    return BTStates.Success;
                }
                
                return BTStates.Running;
            }
        }
        return BTStates.Success;
    }
    
    static Draw = function(_user) {
        if (is_dodging && dodge_path != undefined) {
            dodge_path.DrawPath();
        }
    }
}
