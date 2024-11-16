/// @desc obj_enemy_parent Create event
// inheriting obj_character_parent
event_inherited();

// This is the amount of damage the enemy does to the player.
damage = 1;
visible_range = 64;// how far enemy can see
attack_range = 42;
last_seen_player_x = noone;

// This sets the movement speed for the enemies.
move_speed = 1.5;
roam_count_max = get_room_speed();
roam_count = roam_count_max;

// This applies either move_speed or negative move_speed to the enemy's X velocity. This way the enemy will
// either move left or right (at random).
vel_x = choose(-move_speed, move_speed);

// This sets the friction to 0 so the enemy never comes to a stop.
friction_power = 0;
knockback_active = false; // for BT objects

#region states map
// State history (last 3 states)
prev_states = array_create(3, CHARACTER_STATE.IDLE);

// update these in child objects
sprites_map = {};// CHARACTER_STATE length
sprites_map[$ CHARACTER_STATE.IDLE] = spr_player_idle;

#endregion

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

last_seen_player_x = 0;

search_path_points = ds_list_create();
current_path_point = 0;
patrol_width = 128; // How far to patrol from original position
search_point_spacing = 32; // Distance between search points
#endregion