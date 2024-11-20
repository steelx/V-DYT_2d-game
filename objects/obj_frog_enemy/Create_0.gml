/// @description obj_frog_enemy create
event_inherited();

max_hp = 3;
hp = max_hp;

// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_frog_enemy_defeated;

sprites_map[$ CHARACTER_STATE.IDLE] = spr_frog_idle;
sprites_map[$ CHARACTER_STATE.MOVE] = spr_frog_jump;
sprites_map[$ CHARACTER_STATE.JUMP] = spr_frog_jump_start;
sprites_map[$ CHARACTER_STATE.CHASE] = spr_frog_jump;
sprites_map[$ CHARACTER_STATE.SEARCH] = spr_frog_idle;
sprites_map[$ CHARACTER_STATE.ALERT] = spr_frog_idle;
sprites_map[$ CHARACTER_STATE.ATTACK] = spr_frog_attack;


jump_speed = -8;
jump_range = 96;
move_speed = 2;
vel_x = 0;
state = CHARACTER_STATE.IDLE;
reset_jump_timer = 60;
alarm_set(FROG_RESET_JUMP, reset_jump_timer/2);

breathing_counter_init = 60;
breathing_counter = breathing_counter_init;
image_speed = 0;
