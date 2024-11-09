/// @desc obj_enemy_parent -> inheriting obj_character_parent

event_inherited();

// This is the amount of damage the enemy does to the player.
damage = 1;
visible_range = 64;// how far enemy can see
attack_range = 42;

// This sets the movement speed for the enemies.
move_speed = 1.5;

// This applies either move_speed or negative move_speed to the enemy's X velocity. This way the enemy will
// either move left or right (at random).
vel_x = choose(-move_speed, move_speed);

// This sets the friction to 0 so the enemy never comes to a stop.
friction_power = 0;

prev_states = [];
change_state = function(_state) {
	state = _state;
	if (array_length(prev_states) < 5) {
		array_push(prev_states, _state);
	} else {
		array_shift(prev_states);
		array_push(prev_states, _state);
		show_debug_message($"prev_states: {prev_states}");
	}
};

#region Search behavior
// allows enemy to search for player if had attacked him last step
enable_smart = false;

// Variables for smart behavior
alert_count_init = get_room_speed() * 2;
alert_count = alert_count_init;
search_count_init = get_room_speed() * 5;
search_count = search_count_init;
search_direction = image_xscale;
search_target_x = x;
original_x = x;
last_seen_player_x = 0;

search_path_points = ds_list_create();
current_path_point = 0;
patrol_width = 128; // How far to patrol from original position
search_point_spacing = 32; // Distance between search points
#endregion