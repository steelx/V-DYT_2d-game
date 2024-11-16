function DetectPlayerTask(_detect_sprite = sprites_map[$ CHARACTER_STATE.IDLE]) : BTreeLeaf() constructor {
    name = "Detect Player Task";
	sprite = _detect_sprite;
    
    static Process = function() {
        if (!instance_exists(obj_player)) return BTStates.Failure;

        var _user = black_board_ref.user;
        with(_user) {
			vel_x = 0;
			sprite_index = other.sprite;

			if (player_detected()) {
				image_xscale = sign(obj_player.x - x);
                // Should return Success if player is detected to continue combat sequence
                return BTStates.Success;
            }
        }
        // Return Failure if player not detected, allowing tree to try patrol sequence
		return BTStates.Failure;
    }
}
