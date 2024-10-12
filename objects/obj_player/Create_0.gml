// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();

obj_camera.follow = obj_player;

// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 7;
move_speed = 1.6;

// Bounce Shader variables
trail_intensity = 0;
trail_color = make_color_rgb(255, 200, 0); // A golden color for the trail
use_trail_shader = false;
trail_positions = ds_list_create();
trail_count = 10; // Number of trail instances
in_launch_arc = false;// used in arc movement inside launchpad

// Jet pack variables
jetpack_max_fuel = 10;
jetpack_fuel = jetpack_max_fuel;
jetpack_fuel_consumption_rate = 1/60; // Consume 1 point per second
jetpack_max_height = room_height * 0.35;
jetpack_hover_amplitude = 2;
jetpack_hover_speed = 0.5;
space_hold_timer = get_room_speed();

function is_space_key_held() {
    return keyboard_check(vk_space)
}
