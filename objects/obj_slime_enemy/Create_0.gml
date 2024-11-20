/// @description obj_slime_enemy create

// Inherit the parent event
event_inherited();

max_hp = 2;
hp = max_hp;

defeated_object = obj_slime_defeated;
move_speed = 2;
state = CHARACTER_STATE.MOVE;
jump_speed = 12;
jump_chance = 0.5;
roam_timer = get_room_speed();
alarm_set(SLIME_ROAM, roam_timer);

attack_range = 64;

// TODO: utilize sprites map
sprites_map[$ CHARACTER_STATE.IDLE] = spr_slime_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_slime_hop;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_slime_hop;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_slime_hop;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_slime_idle;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_slime_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_slime_attack;

