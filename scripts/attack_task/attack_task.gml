function AttackWithAnimationFrameTask(_attack_anim_frame, _attack_delay_seconds = 2) : BTreeLeaf() constructor {
    name = "Attack Task";
    attack_frame = _attack_anim_frame;
    attack_cooldown_duration = get_room_speed() * _attack_delay_seconds;
    
    static Init = function() {
        var _user = black_board_ref.user;
        if !variable_instance_exists(_user, "attack_cooldown") {
            variable_instance_set(_user, "attack_cooldown", 0);
        }
        if !variable_instance_exists(_user, "current_attack_frame") {
            variable_instance_set(_user, "current_attack_frame", -1);
        }
		with(_user) {
			sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
		}
    }
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Check attack cooldown
            if (attack_cooldown > 0) {
                attack_cooldown--;
                return BTStates.Failure;
            }
            
            // Check if we can attack
            if (!is_on_ground()) {
                return BTStates.Failure;
            }
            
            // Face the player
            var _dir = sign(obj_player.x - x);
            image_xscale = _dir >= 0 ? 1 : -1;
            
            // If we've reached the attack frame, spawn the arrow
            if (image_index >= other.attack_frame && current_attack_frame != image_index) {
                current_attack_frame = image_index;
                
                // Spawn arrow with calculated trajectory
                var _spawn_x = x + (32 * image_xscale);
                var _spawn_y = bbox_top - 16;
                
                with (instance_create_layer(_spawn_x, _spawn_y, "Player", obj_arrow)) {
                    target_x = obj_player.x;
                    target_y = obj_player.y - 32;
                    
                    // Calculate trajectory
                    var _distance = point_distance(_spawn_x, _spawn_y, target_x, target_y);
                    var _time = _distance / 16;
                    var _upward_boost = 4;
                    
                    angle = point_direction(_spawn_x, _spawn_y, target_x, target_y);
                    vel_x = lengthdir_x(_distance / _time, angle);
                    vel_y = lengthdir_y(_distance / _time, angle) - _upward_boost;
                    image_angle = angle;
                }
                
                // Set cooldown
                attack_cooldown = other.attack_cooldown_duration;
                return BTStates.Success;
            }
            
            // If we haven't reached the attack frame yet
            return BTStates.Running;
        }
    }
    
    static Draw = function(_instance_id) {
        with(_instance_id) {
            if (attack_cooldown > 0) {
                // Optionally draw cooldown indicator
                draw_set_color(c_red);
                draw_text(x, y - sprite_height/2, "Reloading: " + string(attack_cooldown));
                draw_set_color(c_white);
            }
        }
    }
}
