/// @description obj_kutra Create event
// inherits enemy parent, and also able to spawn attack sequence
event_inherited();

max_hp = 2;
hp = max_hp;
damage = 1;
visible_range = 120;// how far enemy can see
attack_range = 48;

defeated_object = obj_kutra_defeated;
move_speed = 1.2;

// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_dog_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_dog_run;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_dog_run;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_dog_run;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_dog_run;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_dog_alert;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_dog_alert;//as we will spawn attack animation


#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

// Main tier nodes
var _knockback_sequence = new BTreeSequence("knockback_sequence");
var _combat_selector = new BTreeSelector("combat_selector");
var _dodge_sequence = new BTreeSequence("dodge_sequence");
var _attack_sequence = new BTreeSequence("attack_sequence");
var _chase_sequence = new BTreeSequence("chase_sequence");
var _alert_sequence = new BTreeSequence("_alert_sequence");
var _patrol_sequence = new BTreeSequence("patrol_sequence");

// Resued tasks
var _detect_player_task = new DetectPlayerTask(sprites_map[$ CHARACTER_STATE.ALERT]);


// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

// Combat sequence
_combat_selector.ChildAdd(_attack_sequence);
_combat_selector.ChildAdd(_chase_sequence);

_dodge_sequence.ChildAdd(_detect_player_task);
_dodge_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_dodge_sequence.ChildAdd(new DodgeTask(3, 4, 3.0));

_attack_sequence.ChildAdd(_detect_player_task);
_attack_sequence.ChildAdd(new CheckAttackRangeTask(attack_range));
_attack_sequence.ChildAdd(new AttackSeqSpawnerTask(seq_kutra_attack, 2, 4, 3.0));

_chase_sequence.ChildAdd(_detect_player_task);
_chase_sequence.ChildAdd(new ChaseTask(move_speed));
_chase_sequence.ChildAdd(new JumpChaseTask(move_speed, 10));

// Alert Seqeunce
_alert_sequence.ChildAdd(new CheckLastSeenTask());
_alert_sequence.ChildAdd(new MoveToLastSeenTask());
_alert_sequence.ChildAdd(new SearchAreaTask(96));

// Patrol sequence
_patrol_sequence.ChildAdd(new IdleTask(1));
_patrol_sequence.ChildAdd(new PatrolTask(move_speed*0.5, 96, 1));

_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_dodge_sequence);
_selector_root.ChildAdd(_combat_selector);
_selector_root.ChildAdd(_alert_sequence);
_selector_root.ChildAdd(_patrol_sequence);

// Initialize the tree
bt_root.Init();

#endregion