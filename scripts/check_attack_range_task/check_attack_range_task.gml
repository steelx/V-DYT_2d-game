function CheckAttackRangeTask(_attack_range = 40, _ignore_player_in_air = false): BTreeLeaf() constructor {
	name = "Check Attack Range Task";
	attack_range = _attack_range;
	ignore_player_in_air = _ignore_player_in_air;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			var _player_above = obj_player.y < y - sprite_height/2;
			var _dist = distance_to_object(obj_player);
			if (other.ignore_player_in_air and _dist <= other.attack_range) {
				// can see player in air too
				return BTStates.Success;
			} else if (_dist <= other.attack_range and !_player_above) {
				return BTStates.Success;// Success means next in Sequence i.e. Attack
			}

			return BTStates.Failure;
		}
	}
}
