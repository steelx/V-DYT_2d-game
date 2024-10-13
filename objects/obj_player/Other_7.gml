// This event runs when the current animation ends.
// This is a switch statement that runs on the 'sprite_index' variable, which stores the sprite
// currently assigned to the instance.
// This allows us to transition to some other sprite, depending on the currently assigned sprite.
switch (sprite_index)
{
	// Code under this case runs if the assigned sprite is 'spr_player_fall', meaning
	// the player was falling downward.
	case spr_player_jet_landing:
		// when jump key was released we must be falling down
        // and we switched to spr_player_jet_landing from spr_player_fall, now we need to change state
        state = CHARACTER_STATE.IDLE;
        sprite_index = spr_player_idle;
		break;
    
}