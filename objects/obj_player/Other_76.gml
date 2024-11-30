/// @desc Broadcast Message is received.

var _message = event_data[? "message"];

// This checks if the message is "footstep", meaning the player has put a foot down. In that case we will create a dust effect.
switch (_message) {
    case "footstep":
       	// This creates an instance of obj_effect_walk at the bottom of the player's mask. This is the
       	// walking dust animation.
       	// The ID of the created instance is stored in a local variable.
       	var _effect = instance_create_layer(x, bbox_bottom+1, "Instances", obj_effect_walk);
       
       	// This sets the horizontal scale of the effect to the player's horizontal scale. This way
       	// it flips based on which direction the player is moving in.
       	_effect.image_xscale = image_xscale;
       
       	play_random_footstep();
        break;
    
    case "hero_attack":
        // this event emitted at 3rd frame when animation frame reaches extended sword
        instance_create_layer(x+(image_xscale*8), y, "Player", obj_player_attack_hitbox);
        play_priority_sound(snd_player_used_attack, SoundPriority.COMBAT);
        break;
    
}