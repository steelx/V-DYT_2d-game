function DodgeTask(_dodge_alarm_idx, _attack_alarm_idx, _dodge_delay = 3) : BTreeLeaf() constructor {
    name = "Dodge Task";
    attack_alarm_idx = _attack_alarm_idx;
    dodge_alarm_idx = _dodge_alarm_idx;
    dodge_delay = get_room_speed() * _dodge_delay;
    
    // Dodge parameters
    dodge_initial_speed = 4;    // Initial dodge speed
    dodge_friction = 0.2;       // How quickly dodge slows down
    dodge_jump_force = -6;      // Upward force
    dodge_gravity = 0.4;        // Custom gravity during dodge
    dodge_duration = 20;        // Frames the dodge lasts
    
    // State variables
    is_dodging = false;
    dodge_timer = 0;
    dodge_vel_x = 0;
    dodge_vel_y = 0;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Start new dodge
            if (!other.is_dodging) {
                // Check if we can dodge
                if (alarm[other.dodge_alarm_idx] > 0) {
                    return BTStates.Failure;
                }
                
                // No dodge if attack cooldown is over or not on ground
                if (alarm[other.attack_alarm_idx] <= 0 || !is_on_ground()) {
                    return BTStates.Failure;
                }
                
                // Initialize dodge
                var _dir = sign(x - obj_player.x);
                if (_dir == 0) _dir = image_xscale;
                
                // Set up dodge state
                other.is_dodging = true;
                other.dodge_timer = other.dodge_duration;
                other.dodge_vel_x = move_speed * other.dodge_initial_speed * _dir;
                other.dodge_vel_y = other.dodge_jump_force;
                
                // Update sprite and cooldown
                sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
                image_xscale = _dir;
                alarm[other.dodge_alarm_idx] = other.dodge_delay;
				play_priority_sound(snd_enemy_dodge, SoundPriority.COMBAT);
            }
            
            // Process ongoing dodge
            if (other.is_dodging) {
                // Apply movement
                x += other.dodge_vel_x;
                y += other.dodge_vel_y;
                
                // Apply physics
                other.dodge_vel_x = approach(other.dodge_vel_x, 0, other.dodge_friction);
                other.dodge_vel_y += other.dodge_gravity;
                
                // Handle collision with ground
                if (is_on_ground() && other.dodge_vel_y > 0) {
                    other.dodge_vel_y = 0;
                }
                
                // Update timer
                other.dodge_timer--;
                if (other.dodge_timer <= 0) {
                    other.is_dodging = false;
                    return BTStates.Success;
                }
                
                return BTStates.Running;
            }
        }
        
        return BTStates.Success;
    }
}
