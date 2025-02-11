/// @desc obj_character_parent End step

// This checks if the character's health is at, or below, 0, meaning it has been defeated.
// In that case we want to replace the character instance with its defeated object.
if (hp <= 0)
{
	// This creates an instance of the character's 'defeated_object'.
	// E.g. it will be obj_player_defeated for obj_player.
	// It's created at the same position as the character itself.
	// It's created in the same layer as the character, by using its 'layer' variable.
	instance_create_layer(x, y, layer, defeated_object);
    
	if (gems > 0) {
		repeat(gems) {
            var _offset_x = random_range(-4, 6);
            var _offset_y = random_range(-4, 4);
            instance_create_layer(
                x + _offset_x, 
                bbox_top + _offset_y, 
                "Instances", 
                obj_gem
            );
        }
	}

	// This destroys the character instance itself.
	instance_destroy();
}

// This checks if no_hurt_frames is greater than 1, meaning the character is currently invincible and can't be hurt.
if (no_hurt_frames > 0)
{
	// In that case we reduce the variable by 1, as one frame as passed. Eventually it will reach 0 again and the character will be able
	// to be hurt.
	no_hurt_frames -= 1;

	// This part handles making the character flash on and off when it's invincible, by changing its alpha between 0 and 1.
	// If the remainder of no_hurt_frames divided by 12 is above 6, we'll set the alpha to 0.
	// Otherwise we'll set it to 1.
	if (no_hurt_frames % 12 > 6)
	{
		// This makes the character invisible.
		image_alpha = 0;
	}
	else
	{
		// This makes the character visible again.
		image_alpha = 1;
	}
}