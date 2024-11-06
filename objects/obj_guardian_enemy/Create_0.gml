/// @description obj_guardian_enemy
// inherits enemy parent, and also able to spawn attack sequence

// Inherit the parent event
event_inherited();
max_hp = 3;
hp = max_hp;
damage = 2;
visible_range = 64;// how far enemy can see
attack_range = 42;

defeated_object = obj_guardian_defeated;
move_speed = 1.5;

// Roam behaviour
move_chance = 0.5;
roam_counter_init = 120;
roam_counter = roam_counter_init;
roam_timer = get_room_speed();
alarm_set(1, roam_timer);

#region Attack Sequence
// disable guardian enemy when attack sequence is running
// we hide this object when enabled is false
enabled = true;

enable_self = function () {
	enabled = true;
	image_alpha = 1;
	state = CHARACTER_STATE.IDLE;
	image_index = spr_guardian_idle;
	alarm_set(1, roam_timer*choose(2, 3));
};

disable_self = function () {
	enabled = false;
	alarm[2] = 1;
	vel_x = 0;
	vel_y = 0;
};

// Playing & Managing the Attack Animation
active_animation = -1;
sequence_layer = -1;
active_sequence = -1;

start_animation = function (_sequence) {
	active_animation = _sequence;
	sequence_layer = layer_create(depth);
	active_sequence = layer_sequence_create(sequence_layer, x, y, _sequence);
	layer_sequence_xscale(active_sequence, image_xscale);
	
	disable_self();
}

check_animation = function () {
	if (active_sequence == undefined) return;
	
	if (layer_sequence_is_finished(active_sequence)) {
		layer_sequence_destroy(active_sequence);
		layer_destroy(sequence_layer);
		
		active_animation = -1;
		active_sequence = -1;
		sequence_layer = -1;
		
		enable_self();
	}
}
#endregion