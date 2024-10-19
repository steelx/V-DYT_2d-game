/// @description obj_frog_enemy step :: state machine
GAME_PAUSED_THEN_EXIT

event_inherited();

switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
        vel_x = 0;

        if breathing_counter < 0 {
            image_speed = 1;
        } else {
           breathing_counter--; 
        }
        // stop breathing at end of animation
        if is_animation_end() {
            image_index = 0;
            image_speed = 0;
            breathing_counter = breathing_counter_init;
        }
    
        break;
    case CHARACTER_STATE.MOVE:
        if (check_collision(0, 1)) {
            grounded = true;
            // we change change state to idle from animation end
            sprite_index = spr_frog_jump_land;
            image_speed = 1;
            break;
        }
    
        var _jump_dir = 1;
        if instance_exists(obj_player) _jump_dir = sign(obj_player.x - x);
        vel_x = _jump_dir * move_speed;
        vel_x = lerp(vel_x, 0, friction_power);
        vel_y = lerp(vel_y, 0, friction_power);
    
        // anim check if frog is going upwards at last frame
        if (image_index >= 2) {
            image_speed = 0;//stop the animation
            image_index = vel_y < 0 ? 2 : 3;
        }

        // Apply horizontal movement
        apply_horizontal_movement();
        
        break;
    case CHARACTER_STATE.JUMP:
        // Jump starts velocity is applied Alarm 0
        if (is_animation_end()) {
            state = CHARACTER_STATE.MOVE;
            vel_y = jump_speed;
            sprite_index = spr_frog_jump;
            image_index = 0;
            image_speed = 1;
        }
        break;
}

apply_verticle_movement();
