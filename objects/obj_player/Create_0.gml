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
move_speed_init = 1.2;
move_speed = move_speed_init;
air_move_speed = 1.8;


// red border shader
red_border_intensity = 0;
red_border_active = false;

// Jet pack variables
jetpack_max_fuel = 10;
jetpack_fuel = jetpack_max_fuel;
jetpack_fuel_consumption_rate = 1/60; // Consume 1 point per second
jetpack_fuel_regeneration_rate = 0.5/60; // regeneration 0.5 point per frame
jetpack_max_height = 250;//height from top px
jetpack_hover_amplitude = 2;
jetpack_hover_speed = 0.1;
jump_key_held_timer = 0;

function is_jump_key_held() {
    return keyboard_check(vk_up);
}

knockback_vel_x = 0;
knockback_friction = 0.5;

apply_knockback = function(_hit_direction, _knockback_speed = 2) {
	knockback_vel_x = lengthdir_x(_knockback_speed, _hit_direction);
	state = CHARACTER_STATE.KNOCKBACK;
	image_index = 0;
	no_hurt_frames = get_room_speed() * 2; // 2 second of invincibility
	audio_play_sound(snd_life_lost_01, 0, 0);
};

// Attack / Super Attack
attack_key_held_timer = 0;
attack_fuel_max = 100;
attack_fuel = attack_fuel_max;
attack_fuel_consumption_rate = 100; // Consume points per super attack
attack_fuel_regeneration_rate = 0.5; // Regenerate 1 point per frame when not attacking

function is_attack_key_held() {
    return keyboard_check(vk_space);
}

function is_super_attack_key_held() {
    return keyboard_check(vk_shift);
}
