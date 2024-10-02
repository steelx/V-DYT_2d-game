// This event runs some time after the player is hit by an enemy, so the player's knockback can be stopped.
// This sets the 'in_knockback' variable to false, so the player knows it's not in knockback anymore, and it can move again.
if (state == CHARACTER_STATE.KNOCKBACK) {
    vel_x = 0;
    state = CHARACTER_STATE.IDLE;
}
// This changes the sprite back to the idle one, as the knockback would have been using the hurt sprite.
sprite_index = spr_player_idle;
image_index = 0;
