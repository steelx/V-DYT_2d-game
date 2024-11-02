/// @description obj_archer Step event
if should_pause_object() {

    event_inherited();
    
    switch(state) {
        case CHARACTER_STATE.IDLE:
            vel_x = 0;
            break;
        
        case CHARACTER_STATE.ATTACK:
            vel_x = 0;
            if (is_animation_end()) {
                roam_counter = roam_counter_init;
                vel_x = 0;
                state = CHARACTER_STATE.IDLE;
                sprite_index = spr_archer_idle;
                alarm_set(1, roam_timer*choose(1, 2));
            }
            break;
        
        case CHARACTER_STATE.MOVE:
            vel_x = lerp(vel_x, 0, friction_power);
            apply_horizontal_movement();
        
            if (roam_counter > 0) {
                roam_counter--;
                if (is_player_in_attack_range(attack_range)) {
                    state = CHARACTER_STATE.ATTACK;
                    sprite_index = spr_archer_attack;
                    image_index = 0;
                    break;
                }
            } else {
                roam_counter = roam_counter_init;
                vel_x = 0;
                state = CHARACTER_STATE.IDLE;
                sprite_index = spr_archer_idle;
                alarm_set(1, roam_timer*choose(1, 2));
            }
            break;
    }
    
    // Apply movement
    apply_verticle_movement();
    
    // Apply gravity
    if (!is_on_ground()) {
        vel_y += grav_speed;
    }

}