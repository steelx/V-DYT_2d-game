function CheckLastSeenTask() : BTreeLeaf() constructor {
    name = "Check Last Seen Task";
	
	static Init = function() {
		var _user = black_board_ref.user;
		if (!variable_instance_exists(_user, "last_seen_player_x")) {
			variable_instance_set(_user, "last_seen_player_x", noone);
		}
	}
    
    static Process = function() {
		if (!instance_exists(obj_player)) return BTStates.Failure;
        var _user = black_board_ref.user;
        
        with(_user) {
			vel_x = 0;
			sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
			
            if (last_seen_player_x != noone) {
				image_xscale = sign(x - last_seen_player_x) >= 0 ? 1 : -1;
				return BTStates.Success;
            }
        }
        
        return BTStates.Failure;
    }
}

function MoveToLastSeenTask() : BTreeLeaf() constructor {
    name = "Move To Last Seen Task";
    
    static Process = function() {
		if (!instance_exists(obj_player)) return BTStates.Failure;
        var _user = black_board_ref.user;

        with(_user) {
			// Check if we can actually reach the last seen position
            if (!can_reach_position(last_seen_player_x)) {
                // If we can't reach it, clear the last seen position and fail the task
                last_seen_player_x = noone;
                vel_x = 0;
                return BTStates.Failure;
            }
            // Check if we reached the last seen position
            var _dist_to_last_seen = abs(x - last_seen_player_x);
            if (_dist_to_last_seen <= global.tile_size) { // Within 16 pixels threshold
                vel_x = 0;
                return BTStates.Success; // Move to search area task
            }
            
            // Move towards last seen position
            var _dir = sign(last_seen_player_x - x);
            vel_x = move_speed * _dir;
			image_xscale = _dir > 0 ? 1 : -1;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            
            return BTStates.Running;
        }
    }
}

function SearchAreaTask(_search_radius, _search_secs = 3.0) : BTreeLeaf() constructor {
    name = "Search Area Task";
    search_radius = _search_radius;
    search_time = get_room_speed() * _search_secs;
    current_search_time = 0;
    search_direction = 1;
    
    static Process = function() {
        var _user = black_board_ref.user;
        
        with(_user) {
			last_seen_player_x = noone;
			var _player_above = obj_player.y < y - sprite_height/2;
			var _is_visible = player_within_range(visible_range);
            // If we have a last seen position and player not in range
            if (_is_visible and !_player_above) {
                other.current_search_time = 0;
                return BTStates.Failure; // Go back to combat if player spotted
            }
            
			// not visible, continue search
            other.current_search_time++;
            
            // Alternate direction every second
            if (other.current_search_time % get_room_speed() == 0) {
                other.search_direction *= -1;
            }
            
            // Move back and forth in search area
            vel_x = other.search_direction * (move_speed*0.5);
            image_xscale = other.search_direction;
            sprite_index = sprites_map[$ CHARACTER_STATE.MOVE];
            
            // If search time is up, clear last seen position and return to patrol
            if (other.current_search_time >= other.search_time) {
                other.current_search_time = 0;
                return BTStates.Success;
            }
            
            return BTStates.Running;
        }
    }
}