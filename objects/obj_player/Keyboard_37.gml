/// @description Left
// This checks if the player is currently in knockback, after being hit by an enemy.
if (state == CHARACTER_STATE.KNOCKBACK)
{
	// In that case we exit/stop the event here, so the player can't move.
	exit;
}

if state == CHARACTER_STATE.JETPACK_JUMP {
    // let player stay in jetpack movement
    
} else {
    state = CHARACTER_STATE.MOVE;
}
// Set the X velocity to negative move_speed.
// This makes the character move left.
vel_x = -move_speed;
image_xscale = -1;

// This checks if the current sprite is the fall sprite, meaning the player hasn't landed yet.
if (sprite_index == spr_player_fall)
{
	// In that case we exit/stop the event here, so the sprite doesn't change.
	exit;
}

// This checks if the player is on the ground, before changing the sprite to the walking sprite. This is
// done to ensure that the walking sprite does not active while the player is in mid-air.
if (grounded)
{
	// Change the instance's sprite to the walking player sprite.
	sprite_index = spr_player_walk;
}
