function ArcherAttackTask(_attack_anim_frame, _attack_alarm_idx, _attack_delay_seconds = 1.5) : BTreeLeaf() constructor {
    name = "Archer Attack Task";
    attack_frame = _attack_anim_frame;
    attack_cooldown_duration = get_room_speed() * _attack_delay_seconds;
	attack_delay_alarm_idx = _attack_alarm_idx;
    
    // Constants for trajectory calculation
    min_range = 64;  // Minimum effective range
    max_range = 400; // Maximum effective range
    min_speed = 8;   // Minimum arrow speed
    max_speed = 16;  // Maximum arrow speed
    
    static calculateTrajectory = function(_start_x, _start_y, _target_x, _target_y, _grav) {
        var _distance = point_distance(_start_x, _start_y, _target_x, _target_y);
        var _angle = point_direction(_start_x, _start_y, _target_x, _target_y);
        
        // Adjust trajectory based on distance
        var _distance_ratio = clamp(_distance / max_range, 0, 1);
        var _speed = lerp(min_speed, max_speed, _distance_ratio);
        
        // Calculate arc height based on distance
        var _arc_height = lerp(2, 4, _distance_ratio);
        
        // Short range adjustments
        if (_distance < min_range) {
            // For very close targets, use a steeper angle
            _arc_height = 3;
            _speed *= 0.75; // Reduce speed for close targets
            
            // Adjust target point to be slightly above the player
            var _height_adjust = lerp(64, 32, _distance / min_range);
            _target_y -= _height_adjust;
            
            // Recalculate angle with new target point
            _angle = point_direction(_start_x, _start_y, _target_x, _target_y);
        }
        
        // Calculate time of flight based on distance and speed
        var _time = _distance / _speed;
        
        // Calculate initial velocities with arc adjustment
        var _vel_x = lengthdir_x(_speed, _angle);
        var _vel_y = lengthdir_y(_speed, _angle) - _arc_height;
        
        return {
            vel_x: _vel_x,
            vel_y: _vel_y,
            angle: _angle,
            speed: _speed
        };
    }
    
    static Init = function() {
        var _user = black_board_ref.user;
        if !variable_instance_exists(_user, "current_attack_frame") {
            variable_instance_set(_user, "current_attack_frame", -1);
        }
    }
    
    static Process = function() {
		var _task = self;
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Check attack cooldown
            if (alarm[other.attack_delay_alarm_idx] > 0 or !is_on_ground()) {
                return BTStates.Failure;
            }
            
			sprite_index = sprites_map[$ CHARACTER_STATE.ATTACK];
			
            // Face the player
            var _dir = sign(obj_player.x - x);
            image_xscale = _dir >= 0 ? 1 : -1;
			
            // If we've reached the attack frame, spawn the arrow
            if (image_index >= other.attack_frame && current_attack_frame != image_index) {
                current_attack_frame = image_index;
				image_index = 0;
                alarm[other.attack_delay_alarm_idx] = other.attack_cooldown_duration;
                
                var _spawn_x = x + (32 * image_xscale);
                var _spawn_y = y - 16;
                with (instance_create_layer(_spawn_x, _spawn_y, "Player", obj_guided_arrow)) {
                    init_path(_spawn_x, _spawn_y, obj_player.x, obj_player.y);
                }
            }
            
            // if we can or cannot attack we move
            return BTStates.Success;
        }
    }
}