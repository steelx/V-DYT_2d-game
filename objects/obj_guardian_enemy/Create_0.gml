/// @description obj_guardian_enemy
// inherits enemy parent, and also able to spawn attack sequence
event_inherited();

max_hp = 10;
hp = max_hp;
damage = 2;
visible_range = 120;// how far enemy can see
attack_range = 48;

defeated_object = obj_guardian_defeated;
move_speed = 0.8;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_guardian_walk;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_guardian_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_guardian_idle;


#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

// Main tier nodes
var _knockback_sequence = new BTreeSequence("knockback_sequence");
var _combat_selector = new BTreeSelector("combat_selector");
var _attack_sequence = new BTreeSequence("attack_sequence");
var _chase_sequence = new BTreeSequence("chase_sequence");
var _alert_sequence = new BTreeSequence("_alert_sequence");
var _patrol_sequence = new BTreeSequence("patrol_sequence");

// Resued tasks
var _detect_player = new DetectPlayerTask(spr_guardian_idle);

// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

// Combat sequence
_combat_selector.ChildAdd(_attack_sequence);
_combat_selector.ChildAdd(_chase_sequence);

_attack_sequence.ChildAdd(_detect_player);
_attack_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_attack_sequence.ChildAdd(new AttackSeqSpawnerTask(seq_guardian_attack, 2, 4, 1.5));

_chase_sequence.ChildAdd(_detect_player);
_chase_sequence.ChildAdd(new ChaseTask(move_speed));

// Alert sequence
_alert_sequence.ChildAdd(new CheckLastSeenTask());
_alert_sequence.ChildAdd(new MoveToLastSeenTask());
_alert_sequence.ChildAdd(new SearchAreaTask(120));

// Patrol sequence
_patrol_sequence.ChildAdd(new ReturnToHomeTask(move_speed, 10, 64));
_patrol_sequence.ChildAdd(new IdleTask(1));
_patrol_sequence.ChildAdd(new PatrolTask(move_speed*0.8, 120, 1));

// Add main tier nodes to root selector
_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_combat_selector);
_selector_root.ChildAdd(_alert_sequence);
_selector_root.ChildAdd(_patrol_sequence);


// Initialize the tree
bt_root.Init();

#endregion


