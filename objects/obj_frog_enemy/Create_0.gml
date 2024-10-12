/// @description obj_frog_enemy create
event_inherited();


// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_frog_enemy_defeated;

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
