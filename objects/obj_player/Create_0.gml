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

sprite_without_sword = {};
sprite_without_sword[$ CHARACTER_STATE.IDLE] = spr_hero_idle_without_sword;
sprite_without_sword[$ CHARACTER_STATE.MOVE] = spr_hero_run_without_sword;
sprite_without_sword[$ CHARACTER_STATE.JUMP] = spr_player_fall;
sprite_without_sword[$ CHARACTER_STATE.FALL] = spr_player_fall;
sprite_without_sword[$ CHARACTER_STATE.JETPACK_JUMP] = spr_player_jet_jump;
sprite_without_sword[$ CHARACTER_STATE.ATTACK] = spr_hero_idle_without_sword;
sprite_without_sword[$ CHARACTER_STATE.SUPER_ATTACK] = spr_hero_idle_without_sword;
sprite_without_sword[$ CHARACTER_STATE.KNOCKBACK] = spr_player_hurt;

update_player_sprites = function(_state = CHARACTER_STATE.IDLE) {
	sprite_index = obj_inventory.has_sword ? sprites_map[$ _state] : sprite_without_sword[$ _state];
}


// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 7;
move_speed_init = 1.2;
move_speed = move_speed_init;
air_move_speed = 1.8;

jetpack = new JetpackSystem(id);

function is_jump_key_held() {
    return keyboard_check(vk_up) or keyboard_check_pressed(ord("W"));
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
	    sprite_index = obj_inventory.has_sword ? sprites_map[$ CHARACTER_STATE.IDLE] : spr_hero_idle_without_sword;
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


sequence_spawner = function(_seq_file) {
	with (instance_create_layer(x, y, "Instances", obj_sequence_spawner)) {
		sequence = _seq_file;
		spawner = other;
		start_sequence();
	}
	disable_self(id);
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
	sequence_spawner(seq_player_blitz_attack);
};

spawn_throw_sword_attack = function() {
	state = CHARACTER_STATE.ATTACK;
	sequence_spawner(seq_player_throw_sword);
};

#endregion