function CheckAttackRangeTask(_attack_range = 40, _ignore_player_in_air = false): BTreeLeaf() constructor {
	name = "Check Attack Range Task";
	attack_range = _attack_range;
	ignore_player_in_air = _ignore_player_in_air;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			if (variable_instance_exists(id, "knockback_active") and knockback_active) {
				return BTStates.Failure;
			}

			var _player_above = obj_player.y < y - sprite_height/2;
			var _dist = distance_to_object(obj_player);
			var _buffer_range = vel_x == 0 ? other.attack_range : other.attack_range+global.tile_size;
			if (other.ignore_player_in_air and _dist <= _buffer_range) {
				// can see player in air too
				return BTStates.Success;
			} else if (_dist <= _buffer_range and !_player_above) {
				return BTStates.Success;// Success means next in Sequence i.e. Attack
			}

			return BTStates.Failure;
		}
	}
}
