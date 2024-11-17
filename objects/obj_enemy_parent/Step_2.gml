/// @description obj_enemy_parent End Step
// need character parent for hurt steps
event_inherited();

if (state == noone) exit;

if variable_instance_exists(id, sprites_map) {
	sprite_index = sprites_map[$ state];
}

// This section flips the character's sprite depending on whether it's moving left or right.
// This condition checks if the X velocity is less than 0, meaning the character is moving left.
if (vel_x < 0) {
	// In that case, the horizontal scale of the instance is set to -1. This flips the sprite the other way around,
	// making it face left.
	image_xscale = -1;
	image_yscale = 1;
}
// Otherwise - if the character is not moving left, this checks if the X velocity is greater than 0, meaning the character is moving right.
else if (vel_x >= 0) {
	// In that case, the horizontal scale is set to 1, so the character faces right again.
	image_xscale = 1;
	image_yscale = 1;
}

switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle behavior (if needed)
        break;

    case CHARACTER_STATE.MOVE:
        // This action calls the check_collision function, and looks for a wall collision where the enemy is walking.
        // We multiply the vel_x by 4 to look for a wall, so we're looking ahead 4 times by the amount the enemy will move this frame.
        // The result (true or false) is stored in a local variable.
        var _wall_found = check_collision(vel_x * 4, 0);

        // This checks if a wall was found.
        if (_wall_found)
        {
            // This flips the sign of the X velocity, so if it's positive it becomes negative, and vice versa.
            // This means the enemy turns to the other direction (from left to right, and vice versa).
            vel_x = -vel_x;
        }

        // Here we are looking for a ledge, by checking for a collision 32 times ahead where the enemy is 
        // moving.
        // However this time the Y offset is set to 64, so it's looking for a collision 64 pixels below where
        // the enemy would be.
        // If a collision is not found there, it means that position has no ground for the enemy to walk on,
        // so we've hit a ledge.
        // The result of this function is stored in 'ground_ahead'.
        var _ground_ahead = check_collision(vel_x * (global.tile_size)/2, global.tile_size);

        // This checks if a collision was NOT found there, meaning we've hit a ledge.
        if (!_ground_ahead)
        {
            // This ensures the enemy is grounded, so enemies in mid-air do not turn.
            if (grounded)
            {
                // This makes the enemy turn.
                vel_x = -vel_x;
            }
        }
        break;

    case CHARACTER_STATE.KNOCKBACK:
        // Knockback behavior (if needed)
        if (vel_x == 0) {
            state = CHARACTER_STATE.MOVE;
        }
        break;
}

