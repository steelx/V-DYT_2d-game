/// @description obj_guardian_enemy
// inherits enemy parent, and also able to spawn attack sequence

// Inherit the parent event
event_inherited();

max_hp = 10;
hp = max_hp;
damage = 2;
visible_range = 120;// how far enemy can see
attack_range = 40;

defeated_object = obj_guardian_defeated;
move_speed = 0.8;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_guardian_idle;


#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

var _combat_selector = new BTreeSelector("combat_selector");
var _attack_sequence = new BTreeSequence("attack_sequence");
var _chase_sequence = new BTreeSequence("chase_sequence");
var _alert_sequence = new BTreeSequence("_alert_sequence");

var _check_last_seen = new GuardianCheckLastSeenTask();
var _move_to_last_seen = new GuardianMoveToLastSeenTask();
var _search_area = new GuardianSearchAreaTask(120);

var _detect_player = new DetectPlayerTask(spr_guardian_idle);
var _chase_player_task = new GuardianChaseTask(move_speed);
var _attack_player_task = new AttackSeqSpawnerTask(seq_guardian_attack, 2, 1.5);

// Patrol Sequence
var _patrol_sequence = new BTreeSequence("patrol_sequence");
var _idle_task = new IdleTask(1);
var _patrol_task = new PatrolTask(move_speed*0.8, 120, 1);

// Knockback Sequence
var _knockback_sequence = new BTreeSequence("knockback_sequence");


// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

// Combat sequence
_combat_selector.ChildAdd(_attack_sequence);
_combat_selector.ChildAdd(_chase_sequence);

_attack_sequence.ChildAdd(_detect_player);
_attack_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_attack_sequence.ChildAdd(_attack_player_task);

_chase_sequence.ChildAdd(_detect_player);
_chase_sequence.ChildAdd(_chase_player_task);

_alert_sequence.ChildAdd(_check_last_seen);
_alert_sequence.ChildAdd(_move_to_last_seen);
_alert_sequence.ChildAdd(_search_area);

// Patrol sequence
_patrol_sequence.ChildAdd(_idle_task);
_patrol_sequence.ChildAdd(_patrol_task);

// Add main sequences to root selector
_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_combat_selector);
_selector_root.ChildAdd(_alert_sequence);
_selector_root.ChildAdd(_patrol_sequence);


// Initialize the tree
bt_root.Init();

#endregion


