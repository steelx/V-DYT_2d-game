/// @description Frog animation end

// we are sent here from MOVE state
if (sprite_index == spr_frog_jump_land) {
    state = CHARACTER_STATE.IDLE;
    sprite_index = spr_frog_idle;
    image_index = 0;
    image_speed = 0;
    alarm_set(FROG_RESET_JUMP, reset_jump_timer); // Reset jump timer
    breathing_counter = breathing_counter_init;
    exit;
}

