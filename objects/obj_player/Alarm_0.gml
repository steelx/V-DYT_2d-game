/// @description KNOCKED_BACK
// This event runs some time after the player is hit by an enemy, so the player's knockback can be stopped.
// This sets the 'in_knockback' variable to false, so the player knows it's not in knockback anymore, and it can move again.
state = CHARACTER_STATE.IDLE;
image_index = 0;