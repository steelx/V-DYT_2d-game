/// @description obj_archer create

// Inherit the parent event
event_inherited();

max_hp = 1;
hp = max_hp;
visible_range = 130;
attack_range = 120;
move_speed = 1.5;

defeated_object = obj_archer_defeated;
state = noone;


// Default sprite mapping
sprites_map[$ CHARACTER_STATE.IDLE] = spr_archer_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_archer_run;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_archer_jump;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_archer_run;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_archer_run;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_archer_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_archer_attack;


#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var _selector_root = new BTreeSelector("root");

var _knockback_sequence = new BTreeSequence("knockback_sequence");
var _patrol_sequence = new BTreeSequence("patrol_sequence");
var _attack_sequence = new BTreeSequence("attack_sequence");
var _dodge_sequence = new BTreeSequence("dodge_sequence");

var _can_see_player_in_air = true;
var _detect_player_task = new DetectPlayerTask(visible_range, sprites_map[$ CHARACTER_STATE.ALERT], _can_see_player_in_air);

// Build the tree:
bt_root.ChildAdd(_selector_root);

_knockback_sequence.ChildAdd(new KnockbackTask());

_dodge_sequence.ChildAdd(_detect_player_task);
_dodge_sequence.ChildAdd(new CheckAttackRangeTask(64, _can_see_player_in_air));
_dodge_sequence.ChildAdd(new DodgeTask(3, 4, 3.0, sprites_map[$ CHARACTER_STATE.JUMP]));

_patrol_sequence.ChildAdd(new IdleTask(1, _can_see_player_in_air));
_patrol_sequence.ChildAdd(new PatrolTask(move_speed*0.8, 64, 1, _can_see_player_in_air));

_attack_sequence.ChildAdd(_detect_player_task);
_attack_sequence.ChildAdd(new CheckAttackRangeTask(attack_range, _can_see_player_in_air));
_attack_sequence.ChildAdd(new ArcherAttackTask(4, 4, 2.0));

_selector_root.ChildAdd(_knockback_sequence);
_selector_root.ChildAdd(_dodge_sequence);
_selector_root.ChildAdd(_patrol_sequence);
_selector_root.ChildAdd(_attack_sequence);

// Initialize the tree
bt_root.Init();

#endregion

