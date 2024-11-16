function CheckAttackRangeTask(_attack_range = 40): BTreeLeaf() constructor {
	name = "Check Attack Range Task";
	attack_range = _attack_range;
	
	static Process = function() {
		var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
		
		with(_user) {
			var _player_above = obj_player.y < y - sprite_height/2;
			var _dist = distance_to_object(obj_player);
            if (_dist <= other.attack_range and !_player_above) {
				return BTStates.Success;// Success means next in Sequence i.e. Attack
			}

			return BTStates.Failure;
		}
	}
}
