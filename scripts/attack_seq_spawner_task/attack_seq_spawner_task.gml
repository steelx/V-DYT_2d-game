/*
Make sure to add following line at Step and Draw event to stop processing during attack animation is running
	if (variable_instance_exists(id, "enabled") and !enabled) exit;
*/
function AttackSeqSpawnerTask(_seqeunce_file, _image_alpha_alarm_idx, _attack_alarm_idx, _attack_delay_seconds = 1.5): BTreeLeaf() constructor {
    name = "Attack Sequence Spawner Task";
	attack_cooldown = 0;
	attack_cooldown_duration = get_room_speed() * _attack_delay_seconds;
    
    // Animation management properties
    sequence_file = _seqeunce_file;
	image_alpha_alarm = _image_alpha_alarm_idx;
	attack_delay_alarm_idx = _attack_alarm_idx;
	
	_enable_self = function (_user) {
		with(_user) {
			enabled = true;
			image_index = sprites_map[$ CHARACTER_STATE.IDLE];
			image_alpha = 1;
			no_hurt_frames = 0;
		}
	};
	
	/// Disabled the Step event due to if (variable_instance_exists(id, "enabled") and !enabled) exit;
	_disable_self = function (_user) {
		with(_user) {
			enabled = false;
			alarm[other.image_alpha_alarm] = 1;//sets image alpha = 0
			vel_x = 0;
			vel_y = 0;
		}
	};
	
	static Init = function() {
		var _user = black_board_ref.user;
		if !variable_instance_exists(_user, "enabled") {
			variable_instance_set(_user, "enabled", true);
		}
		if !variable_instance_exists(_user, "sequence_spawner_id") {
			variable_instance_set(_user, "sequence_spawner_id", noone);
		}
		if !variable_instance_exists(_user, "enable_self") {
			// "enable_self" gets called from obj_sequence_spawner cleanup_sequence function
			variable_instance_set(_user, "enable_self", _enable_self);
		}

		if !variable_instance_exists(_user, "disable_self") {
			variable_instance_set(_user, "disable_self", _disable_self);
		}
		if !variable_instance_exists(_user, "attack_delay_alarm_idx") {
			// get reset from player super attack hitbox so enemy cant attack instantly
			variable_instance_set(_user, "attack_delay_alarm_idx", attack_delay_alarm_idx);
		}
	}
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
			if !enabled {
				// this useles but still kept for understanding as in step event we have below line
				// if (variable_instance_exists(id, "enabled") and !enabled) exit;
				return BTStates.Running;
			}
			
            // check attack cooldown
            if (alarm[other.attack_delay_alarm_idx] > 0 and is_on_ground()) {
                return BTStates.Failure;
            }
			
			// Start Attack animation
			var _dir = sign(obj_player.x - x);
            image_xscale = _dir >= 0 ? 1 : -1;
			
			alarm[other.attack_delay_alarm_idx] = other.attack_cooldown_duration;
			sequence_spawner_id = instance_create_layer(x, y, "Instances", obj_sequence_spawner);
			sequence_spawner_id.sequence = other.sequence_file;
			sequence_spawner_id.spawner = id;
			sequence_spawner_id.start_sequence();
			disable_self(id);
			
            return BTStates.Success;// continue with next in Sequence
        }
    }
	
	static Draw = function(id) {
		with(id) {
			if (variable_instance_exists(id, "enabled") and !enabled) exit;
		}
	}
}