function CheckAttackRangeTask(_attack_range = 40, _can_see_in_air = false): BTreeLeaf() constructor {
	name = "Check Attack Range Task";
	attack_range = _attack_range;
	can_see_in_air = _can_see_in_air;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			if (variable_instance_exists(id, "knockback_active") and knockback_active) {
				return BTStates.Failure;
			}

			var _buffer_range = other.attack_range+global.tile_size;
			if (player_detected(_buffer_range, other.can_see_in_air)) {
				return BTStates.Success;
			}

			return BTStates.Failure;
		}
	}
}
