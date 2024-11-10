/// @description obj_enemy_parent Step

// Inherit the parent event
event_inherited();

switch (state) {
    case CHARACTER_STATE.KNOCKBACK:
        // Apply knockback movement
        x += vel_x;
        
        // Slow down knockback
        vel_x *= 0.9;
        
        // Check if knockback is finished
        if (abs(vel_x) < 0.1) {
            vel_x = 0;
            vel_y = 0;
            transition_to_chase();
        }
        break;
}
