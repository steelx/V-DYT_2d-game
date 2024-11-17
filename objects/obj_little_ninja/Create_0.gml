/// @description obj_little_ninja Create event
// inherits enemy parent, and also able to spawn attack sequence
event_inherited();

defeated_object = obj_enemy1_defeated;
max_hp = 1;
hp = max_hp;

max_hp = 5;
hp = max_hp;
damage = 1;
visible_range = 64;// how far enemy can see
attack_range = 42;

defeated_object = obj_enemy1_defeated;
move_speed = 1;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_little_ninja_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_little_ninja_walk;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_little_ninja_alert;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_little_ninja_idle;


#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

var _knockback_sequence = new BTreeSequence("knockback_sequence");
var _patrol_sequence = new BTreeSequence("patrol_sequence");
var _attack_sequence = new BTreeSequence("attack_sequence");
var _dodge_sequence = new BTreeSequence("dodge_sequence");

var _detect_player_task = new DetectPlayerTask(sprites_map[$ CHARACTER_STATE.ALERT]);

// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

_dodge_sequence.ChildAdd(_detect_player_task);
_dodge_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_dodge_sequence.ChildAdd(new DodgeTask(3, 4, 3.0));

_patrol_sequence.ChildAdd(new IdleTask(1));
_patrol_sequence.ChildAdd(new PatrolTask(move_speed*0.8, 96, 1));

_attack_sequence.ChildAdd(_detect_player_task);
_attack_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_attack_sequence.ChildAdd(new AttackSeqSpawnerTask(seq_ninja_attack, 2, 4, 1.5));

_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_dodge_sequence);
_selector_root.ChildAdd(_patrol_sequence);
_selector_root.ChildAdd(_attack_sequence);

// Initialize the tree
bt_root.Init();

#endregion