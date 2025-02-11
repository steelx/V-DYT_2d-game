/// @description obj_enemy1 step + (inherting parent)
if should_pause_object() {
    exit;
}
// Inherit the parent event
event_inherited();
    
switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
        vel_x = 0;
        break;
    case CHARACTER_STATE.MOVE:
        // Transition back to MOVE or IDLE state once in the air
        state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        break;
    case CHARACTER_STATE.JUMP:
        // Jump state behavior
        if (grounded) {
            vel_y = -jump_speed;
            grounded = false;
            state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        }
            
        break;
    case CHARACTER_STATE.KNOCKBACK:
        // Knockback state behavior
        // The character is unable to control movement in this state
        // Knockback velocity is applied in the collision event and stopped in Alarm 0
        break;
}

apply_horizontal_movement();
apply_verticle_movement();