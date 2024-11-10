/// @description obj_guardian_enemy
// inherits enemy parent, and also able to spawn attack sequence

// Inherit the parent event
event_inherited();
max_hp = 20;
hp = max_hp;
damage = 2;
visible_range = 120;// how far enemy can see
attack_range = 42;

defeated_object = obj_guardian_defeated;
move_speed = 1.5;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_guardian_idle;

enable_smart = true;

// attack timer
can_attack = false;
attack_delay = get_room_speed() * 2;
alarm[4] = attack_delay;

// Roam behaviour
move_chance = 1;
state = CHARACTER_STATE.IDLE;
move_chance = 0.5;


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

/*
Behaviour tree :: State Flow =>
// Tree Structure:
Root
└── Selector (Root)
    ├── Sequence (Combat)            // Combat (if attack and chase Fail) Failiure -> goes to Patrol
    │   ├── DetectPlayer            // Must succeed to continue combat
    │   └── Selector (Combat Actions) // Try Attack OR Chase
    │       ├── Attack              // Try first
    │       └── Chase               // Fallback if attack fails
    └── Sequence (Patrol)           // Patrol Failiure -> goes to Combat
        ├── Idle                    // Must succeed to continue patrol
        └── Patrol                  // Next patrol action

// Example flow:
1. DetectPlayer returns Failure
   -> Combat Sequence fails
   -> Root Selector tries Patrol Sequence

2. DetectPlayer returns Success
   -> Combat Sequence continues to Attack
   -> If Attack returns Failure
      -> Combat Actions Selector tries Chase
   -> If both Attack AND Chase fail
      -> Combat Sequence fails
      -> Root Selector tries Patrol Sequence

3. DetectPlayer returns Success
   -> Combat Sequence continues to Attack
   -> If Attack returns Running
      -> Stay in Attack
   -> Combat Sequence stays Running
   -> Root Selector stays on Combat
*/
#region Behaviour_tree

bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector();

var _detect_player = new GuardianDetectPlayerTask(visible_range);

// Create combat sequence selector (for attack OR chase)
var _sequence_combat = new BTreeSequence();
var _combat_actions = new BTreeSelector();
var _attack_player_task = new GuardianAttackTask();
var _chase_player_task = new GuardianChaseTask(move_speed);

// Create patrol sequence
var _sequence_patrol = new BTreeSequence();
var _idle_task = new GuardianIdleTask();
var _patrol_task = new GuardianPatrolTask(move_speed);

// Build the tree:
bt_root.ChildAdd(_selector_root);

// Combat sequence
_sequence_combat.ChildAdd(_detect_player);
_sequence_combat.ChildAdd(_combat_actions);
_combat_actions.ChildAdd(_attack_player_task);
_combat_actions.ChildAdd(_chase_player_task);


// Patrol sequence
_sequence_patrol.ChildAdd(_idle_task);
_sequence_patrol.ChildAdd(_patrol_task);

// Add main sequences to root selector
_selector_root.ChildAdd(_sequence_combat);
_selector_root.ChildAdd(_sequence_patrol);

// Initialize the tree
bt_root.Init();
#endregion


