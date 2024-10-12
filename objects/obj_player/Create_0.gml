// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();

obj_camera.follow = obj_player;

// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 10;
move_speed = 1.7;

// Bounce Shader variables
trail_intensity = 0;
trail_color = make_color_rgb(255, 200, 0); // A golden color for the trail
use_trail_shader = false;
trail_positions = ds_list_create();
trail_count = 10; // Number of trail instances
in_launch_arc = false;// used in arc movement inside launchpad

// Jet pack variables
jetpack_fuel = 10;
jetpack_max_fuel = 10;
jetpack_fuel_consumption_rate = 1/60; // Consume 1 point per second
jetpack_max_height = room_height * 0.3;
jetpack_hover_amplitude = 2;
jetpack_hover_speed = 0.1;
space_hold_timer = get_room_speed();

function is_space_key_held() {
    return keyboard_check(vk_space)
}
