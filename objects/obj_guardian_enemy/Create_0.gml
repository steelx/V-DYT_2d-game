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
Behavior Tree State Transition Example:

1. Selector (_selector_root)
   - Tries each child until one succeeds
   - If all fail, moves to next child

2. Sequence (_sequence_combat)
   - Must complete all children in order
   - If any fail, the whole sequence fails

3. Combat Sequence Example:
   DetectPlayer (Success) -> CombatSelector -> Attack (Failure) -> Chase (Running)
   Next frame:
   DetectPlayer (Success) -> CombatSelector -> Attack (Success) -> Stop

State Flow:
Root
└── Selector (root)
    ├── Sequence (combat)
    │   ├── DetectPlayer
    │   └── Selector (combat)
    │       ├── Attack
    │       └── Chase
    └── Sequence (patrol)
        ├── Idle
        └── Patrol

Example Transitions:
- If DetectPlayer returns Success:
  - Try Attack (if in range returns Success, execute attack)
  - If Attack fails, try Chase (returns Running while moving to player)
  
- If DetectPlayer returns Failure:
  - Entire combat sequence fails
  - Falls back to patrol sequence
*/
#region Behaviour_tree
// Initialize behavior tree
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector();

// Create combat sequence
var _sequence_combat = new BTreeSequence();
var _combat_selector = new BTreeSelector(); // NEW: selector for attack/chase

// Create patrol sequence
var _sequence_patrol = new BTreeSequence();

// Create tasks
var _detect_player = new GuardianDetectPlayerTask(visible_range);
var _attack_player = new GuardianAttackTask();
var _chase_player = new GuardianChaseTask(move_speed);
var _idle_task = new GuardianIdleTask();
var _patrol_task = new GuardianPatrolTask(move_speed);

// Build the tree
bt_root.ChildAdd(_selector_root);

// Combat sequence: detect then select between attack/chase
_sequence_combat.ChildAdd(_detect_player);
_sequence_combat.ChildAdd(_combat_selector);

// Combat selector: try attack first, if fails then chase
_combat_selector.ChildAdd(_attack_player);
_combat_selector.ChildAdd(_chase_player);

// Patrol sequence
_sequence_patrol.ChildAdd(_idle_task);
_sequence_patrol.ChildAdd(_patrol_task);

// Add sequences to root selector
_selector_root.ChildAdd(_sequence_combat);
_selector_root.ChildAdd(_sequence_patrol);

// Initialize the tree
bt_root.Init();
#endregion


