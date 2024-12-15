// This runs the parent's End Step event, which handles flipping the character's sprite left or right.
event_inherited();

// This is a switch statement that runs on the 'sprite_index' variable, which stores the sprite
// currently assigned to the instance.
// This allows us to transition to some other sprite, depending on the currently assigned sprite, and some additional conditions.
switch (sprite_index)
{
	// Code under this case runs if the assigned sprite is 'spr_player_fall', meaning the player was falling downward.
	case spr_player_fall:
        image_speed = (vel_y >= 0) ? 1 : 0;
		// This checks if the player is now on the ground
		if (grounded) {
			sprite_index = spr_player_jet_landing;
			image_speed = 1;
		
			// Play the landing sound effect
			audio_play_sound(snd_land_01, 0, 0);
		}
		break;

	// Code under this case runs if the assigned sprite is 'spr_player_hurt', meaning the player is in the middle of a knockback.
	case spr_player_hurt:
		// This checks if the player is grounded, so the dust VFX can be created.
		if (grounded)
		{
			// This creates an instance of obj_effect_knockback, which appears at the player's feet when it's in knockback.
			// It's created at the bottom point of the player's mask, in the player's layer.
			// The ID of the created instance is stored in a local variable called 'dust', because we want to modify its horizontal (X) scale.
			var _dust = instance_create_layer(x, bbox_bottom, layer, obj_effect_knockback);
		
			// Here we're modifying the X scale of the dust
			// instance to match the X scale of the player.
			_dust.image_xscale = image_xscale;
		}
		break;

	// 'default' code runs when none of the other cases are valid, meaning the currently assigned sprite is not covered by any
	// of the cases above.
	default:
		// For all other sprites we set the animation speed to 1.
		image_speed = 1;
		break;
}
