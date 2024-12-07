function DetectPlayerTask(_visible_range, _detect_sprite = sprites_map[$ CHARACTER_STATE.IDLE], _can_see_in_air = false) : BTreeLeaf() constructor {
    name = "Detect Player Task";
	sprite = _detect_sprite;
	can_see_in_air = _can_see_in_air;
    
    static Process = function() {
        if (!instance_exists(obj_player)) return BTStates.Failure;

        var _user = black_board_ref.user;
        with(_user) {
			vel_x = 0;
			sprite_index = other.sprite;

			if (player_detected(visible_range, other.can_see_in_air)) {
				image_xscale = sign(obj_player.x - x);
                // Should return Success if player is detected to continue combat sequence
                return BTStates.Success;
            }
        }
        // Return Failure if player not detected, allowing tree to try patrol sequence
		return BTStates.Failure;
    }
}
