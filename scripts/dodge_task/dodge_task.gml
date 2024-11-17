function DodgeTask(_dodge_alarm_idx, _attack_alarm_idx, _dodge_delay = 3): BTreeLeaf() constructor {
    name = "Dodge Task";
	attack_alarm_idx = _attack_alarm_idx;
	dodge_alarm_idx = _dodge_alarm_idx;
	dodge_delay = get_room_speed() * _dodge_delay;
	
	dodge_speed = 6;
	dodge_jump_force = -8;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Check if we can dodge
            if (alarm[other.dodge_alarm_idx] > 0) {
                return BTStates.Failure;
            }
            
            // NO dodge if attack cooldown is over or Not on ground
            if (alarm[other.attack_alarm_idx] <= 0 || !is_on_ground()) {
                return BTStates.Failure;
            }
            
            // Determine direction to dodge (away from player)
            var _dir = sign(x - obj_player.x);
            if (_dir == 0) _dir = image_xscale;
            
            // Apply dodge movement
            vel_x = move_speed * other.dodge_speed * _dir;
            vel_y = other.dodge_jump_force;
            
            // Update sprite and cooldown
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            image_xscale = _dir;
            alarm[other.dodge_alarm_idx] = other.dodge_delay;
            
            return BTStates.Success;
        }
    }
}
