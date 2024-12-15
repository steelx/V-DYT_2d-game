// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();
image_xscale *= 1.2;
image_yscale *= 1.2;

max_hp = 5;
hp = max_hp;
previous_hp = hp; // To track health changes
hp_gain_animation_active = false;// to run HP gain animation

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
jetpack = {
    max_fuel: 1000,
    fuel: 1000,
    fuel_consumption_rate: 1/60, // Consume 1 point per second
    fuel_regeneration_rate: 0.5/60, // Regeneration 0.5 point per second
    max_height: 96, // Maximum height from ground
    hover_amplitude: 2,
    hover_speed: 4, // Speed of bobbing
    bob_range: 3, // Maximum pixels to bob up and down
    horizontal_momentum: 0,
    max_horizontal_speed: 3,
    acceleration: 0.2,
    deceleration: 0.1,
    ground_reference_y: y,
    hover_height: 96, // Desired height above ground
    ground_check_distance: 100, // How far down to check for ground
    min_height: 48, // Minimum hover height when no ground is found
    max_vertical_speed: 1.5,
    hover_strength: .9, // Strength of the jetpack thrust
    last_ground_y: y,
	hover_direction: 1,
	hover_y_offset: 0
};

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
attack_fuel_max = 10;
attack_fuel = attack_fuel_max;
attack_fuel_consumption_rate = 10; // Consume points per super attack
attack_fuel_regeneration_rate = 1/60; // Regenerate 1 point per frame when not attacking

if (!instance_exists(obj_inventory)) {
    instance_create_layer(0, 0, "Player", obj_inventory);
}

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

spawn_super_attack = function() {
	if (alarm[PLAYER_ATTACK_DELAY] > 0 or no_hurt_frames > 0) {
		// draw denied feedback
		var _wait_for_sec = no_hurt_frames / get_room_speed();//since we need to set as seconds
		show_popup_notifications([
			["[c_red]Supper Attack Not Ready[]", _wait_for_sec],
			["[wave]Supper Attack [c_green]Ready![]", 1],
		]);
		return;
	}
	if (attack_fuel < attack_fuel_consumption_rate) {
		// denied feedback
		show_popup_notifications([
			["[c_red]Super Attack is re-generating![]", 2]
		]);
		return;
	}
	
	state = CHARACTER_STATE.SUPER_ATTACK;
	attack_fuel -= attack_fuel_consumption_rate;
	add_screenshake(0.2, 1.5);
	alarm[PLAYER_ATTACK_DELAY] = get_room_speed() * 1;// start attack delay timer
	sequence_spawner(seq_player_super_attack);
};

spawn_blitz_attack = function() {
	var _fuel = obj_inventory.blitz_points;
	if (_fuel <= 0) {
		// denied feedback
		show_popup_notifications([
			["[c_red]Needs Blitz Attack Fuel[]", 2],
			["[wave]Enemies drop [c_green]fuel[] randomly when they die!", 1],
		]);
		return;
	}
	if (no_hurt_frames > 0) {
		// denied feedback
		var _wait_for_sec = no_hurt_frames / get_room_speed();//since we need to set as seconds
		show_popup_notifications([
			["[c_red]Cant attack during Hurt state[]", _wait_for_sec],
			["[wave]Attack [c_green]Ready[]", 1],
		]);
		return;
	}
	
	state = CHARACTER_STATE.ATTACK;
	obj_inventory.blitz_points -= 1;
	add_screenshake(0.2, 1.5);
	sequence_spawner(seq_player_blitz_attack);
};

sequence_spawner = function(_seq_file) {
	with (instance_create_layer(x, y, "Instances", obj_sequence_spawner)) {
		sequence = _seq_file;
		spawner = other;
		start_sequence();
	}
	disable_self(id);
};

#endregion