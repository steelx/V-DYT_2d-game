/// @description obj_slime_enemy Step event

event_inherited();

switch(state) {
    case CHARACTER_STATE.IDLE:
        vel_x = 0;
        break;
    
    case CHARACTER_STATE.ATTACK:
        vel_x = lerp(vel_x, 0, friction_power);
        show_debug_message($"attacking: {friction_power}");
        if (is_on_ground() and is_animation_end()) {
            show_debug_message($"attack end: {vel_x}");
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_slime_idle;
            alarm_set(SLIME_RAOM, roam_timer*2);
        }
        break;
    
    case CHARACTER_STATE.MOVE:
        show_debug_message($"move vel_x: {vel_x}");
        vel_x = lerp(vel_x, 0, friction_power);
        
        if (is_on_ground() and is_animation_end()) {
            show_debug_message($"move to idle: {vel_x}");
            vel_x = 0;
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_slime_idle;
            alarm_set(SLIME_RAOM, roam_timer*choose(1, 2));
        }
        apply_horizontal_movement();
        break;
}

// Apply movement
apply_verticle_movement();

// Apply gravity
if (!is_on_ground()) {
    vel_y += grav_speed;
}
