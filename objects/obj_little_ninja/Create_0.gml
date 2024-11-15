/// @description obj_little_ninja Create event
// inherits enemy parent, and also able to spawn attack sequence
event_inherited();

defeated_object = obj_enemy1_defeated;
max_hp = 1;
hp = max_hp;

max_hp = 10;
hp = max_hp;
damage = 2;
visible_range = 60;// how far enemy can see
attack_range = 40;

defeated_object = obj_guardian_defeated;
move_speed = 1;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_little_ninja_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_little_ninja_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_little_ninja_idle;


#region Attack Sequence
// disable guardian enemy when attack sequence is running
// we hide this object when enabled is false
enabled = true;

enable_self = function () {
	enabled = true;
	image_alpha = 1;
	state = CHARACTER_STATE.IDLE;
	image_index = spr_guardian_idle;
	alarm_set(1, 1);
};

disable_self = function () {
	enabled = false;
	alarm[2] = 1;
	vel_x = 0;
	vel_y = 0;
};

// Playing & Managing the Attack Animation
active_attack_sequence = noone;

start_animation = function (_sequence) {
	active_attack_sequence = instance_create_layer(x, y, "Instances", obj_sequence_spawner);
    with (active_attack_sequence) {
		sequence = _sequence;
		spawner = other.id;
		start_sequence();
	}
	disable_self();
	return active_attack_sequence;
};

check_animation = function () {
    if (instance_exists(active_attack_sequence)) {
        if (active_attack_sequence.check_sequence()) {
            active_attack_sequence = noone;
            enable_self();
        }
    }
};
#endregion

#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

var _knockback_sequence = new BTreeSequence("knockback_sequence");
var _patrol_sequence = new BTreeSequence("patrol_sequence");
var _attack_sequence = new BTreeSequence("attack_sequence");

var _idle_task = new IdleTask(1);
var _patrol_move_task = new PatrolTask(move_speed*0.8, 96, 1);

var _detect_player = new DetectPlayerTask(spr_little_ninja_idle);

// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

_patrol_sequence.ChildAdd(_idle_task);
_patrol_sequence.ChildAdd(_patrol_move_task);

_attack_sequence.ChildAdd(_detect_player);

_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_patrol_sequence);
_selector_root.ChildAdd(_attack_sequence);

// Initialize the tree
bt_root.Init();

#endregion