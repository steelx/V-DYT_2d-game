event_inherited();

// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_frog_enemy_defeated;

jump_range = 164;
vel_x = 0;
state = CHARACTER_STATE.IDLE;
alarm_set(FROG_RESET_JUMP, 30);