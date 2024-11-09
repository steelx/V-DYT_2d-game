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
            // Return to ALERT if was in combat before knockback
            var _was_in_combat = (
                prev_states[0] == CHARACTER_STATE.CHASE || 
                prev_states[0] == CHARACTER_STATE.ATTACK || 
                prev_states[0] == CHARACTER_STATE.ALERT
            );
            transition_to_state(_was_in_combat ? CHARACTER_STATE.ALERT : CHARACTER_STATE.IDLE);
        }
        break;
}
