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
       
       	// Choose a random sound to play on footstep
       	var _sound = choose(snd_footstep_01, snd_footstep_02, snd_footstep_03);
       
       	// Play that sound
        audio_play_sound(_sound, 0, 0);
        break;
    
    case "hero_attack":
        // this event emitted at 3rd frame when animation frame reaches extended sword
        instance_create_layer(x+(image_xscale*8), y, "Player", obj_player_attack_hitbox);
        var _s1 = audio_play_sound(snd_attack, 1, 0);
        audio_sound_pitch(_s1, random_range(0.8, 1));
        break;
    
    case "hero_super_attack":
        // this event emitted at 7th frame when animation frame reaches extended sword
        with (instance_create_layer(x+(image_xscale*8), y, "Player", obj_player_superattack_hitbox)) {
            facing = other.image_xscale;
        }
        var _s2 = audio_play_sound(snd_super_attack, 1, 0);
        audio_sound_pitch(_s2, random_range(0.8, 1));
        break;
}