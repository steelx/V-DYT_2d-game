/// @description obj_enemy_parent Step

// Inherit the parent event
event_inherited();
if (enable_smart and smart_search_timer > 0) {
	smart_search_timer--;
}

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
            state = CHARACTER_STATE.IDLE;
        }
        break;
}
