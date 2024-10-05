/// @description obj_frog_enemy step :: state machine

event_inherited();

switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
        vel_x = 0;
        break;
    case CHARACTER_STATE.MOVE:
        var _jump_dir = sign(obj_player.x - x);
        vel_x = _jump_dir * 4;
        vel_x = lerp(vel_x, 0, friction_power);
        if (grounded) {
            // we change change state to idle from animation end
            sprite_index = spr_frog_jump_land;
            vel_x = 0;
            break;
        }
        
        // Apply horizontal movement
        apply_horizontal_movement();
        
        break;
    case CHARACTER_STATE.KNOCKBACK:
        // Knockback state behavior
        // The character is unable to control movement in this state
        // Knockback velocity is applied in the collision event and stopped in Alarm 0
        break;
}

apply_verticle_movement();
