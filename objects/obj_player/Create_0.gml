// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();
image_xscale *= 1.2;
image_yscale *= 1.2;

max_hp = 5;
hp = max_hp;
previous_hp = hp; // To track health changes
hp_gain_animation_active = false;// to run HP gain animation

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

// red border shader
red_border_intensity = 0;
red_border_active = false;

// Jet pack variables
jetpack_max_fuel = 10;
jetpack_fuel = jetpack_max_fuel;
jetpack_fuel_consumption_rate = 1/60; // Consume 1 point per second
jetpack_fuel_regeneration_rate = 0.2/60; // regeneration 0.2 point per frame
jetpack_max_height = 250;//height from top px
jetpack_hover_amplitude = 2;
jetpack_hover_speed = 0.1;
jump_key_held_timer = 0;

function is_jump_key_held() {
    return keyboard_check(vk_up);
}

// Attack / Super Attack
attack_key_held_timer = 0;
attack_fuel_max = 100;
attack_fuel = attack_fuel_max;
attack_fuel_consumption_rate = 100; // Consume points per super attack
attack_fuel_regeneration_rate = 0.1; // Regenerate 1 point per frame when not attacking

function is_attack_key_held() {
    return keyboard_check(vk_space);
}

function is_super_attack_key_held() {
    return keyboard_check(vk_shift);
}
