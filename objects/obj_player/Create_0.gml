// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();
image_xscale *= 1.2;
image_yscale *= 1.2;

max_hp = 5;
hp = max_hp;
previous_hp = hp; // To track health changes
hp_gain_animation_active = false;// to run HP gain animation

obj_camera.follow = obj_player;

sprites_map[$ CHARACTER_STATE.IDLE] = spr_player_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_player_walk;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_player_fall;
sprites_map[$ CHARACTER_STATE.FALL] = spr_player_fall;
sprites_map[$ CHARACTER_STATE.JETPACK_JUMP] = spr_player_jet_jump;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_hero_attack;
sprites_map[$ CHARACTER_STATE.SUPER_ATTACK] = spr_hero_super_attack;
sprites_map[$ CHARACTER_STATE.KNOCKBACK] = spr_player_hurt;


// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 7;
move_speed_init = 1.2;
move_speed = move_speed_init;
air_move_speed = 1.8;

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

#region Attack & Seqeunce spawner
// Attack / Super Attack
attack_key_held_timer = 0;
attack_fuel_max = 100;
attack_fuel = attack_fuel_max;
attack_fuel_consumption_rate = 10; // Consume points per super attack
attack_fuel_regeneration_rate = 0.5; // Regenerate 1 point per frame when not attacking

function is_attack_key_held() {
    return keyboard_check(vk_space);
}

function is_super_attack_key_held() {
    return keyboard_check(vk_shift);
}

enabled = true;
enable_self = function (_user) {
	with(_user) {
		enabled = true;
		image_alpha = 1;
		no_hurt_frames = 0;
		state = CHARACTER_STATE.IDLE;
	    sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
	}
};
	
// Disabled the Step event due to if (variable_instance_exists(id, "enabled") and !enabled) exit;
disable_self = function (_user) {
	with(_user) {
		enabled = false;
		alarm[PLAYER_IMAGE_ALPHA] = 1;//sets image alpha = 0
		vel_x = 0;
		vel_y = 0;
	}
};

spawn_super_attack = function(_sequence_file = seq_player_super_attack) {
	if (alarm[PLAYER_ATTACK_DELAY] > 0) {
		return;
	}
	
	alarm[PLAYER_ATTACK_DELAY] = get_room_speed() * 1;// start attack delay timer
	with (instance_create_layer(x, y, "Instances", obj_sequence_spawner)) {
		sequence = _sequence_file;
		spawner = other;
		start_sequence();
	}
	disable_self(id);
};

#endregion