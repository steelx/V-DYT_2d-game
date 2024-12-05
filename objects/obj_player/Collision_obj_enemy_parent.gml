/// @description obj_player Collision with obj_enemy_parent
// It checks if the player has fallen on top of the enemy, in which case the enemy is hurt.
var _allowed_to_jump_on_head = [obj_enemy1];

if (state == CHARACTER_STATE.JUMP || state == CHARACTER_STATE.JETPACK_JUMP || vel_y < 0) {
    // This checks if the bottom point of the player's collision mask was above the enemy mask's top
    // point, in the previous frame.
    // If this is true, it proves that the player is falling on top of the enemy from above, as it was
    // previously above it.
    // We get the bottom position for the previous frame by subtracting this frame's Y velocity from it.
    if (array_contains(_allowed_to_jump_on_head, other.object_index) and (bbox_bottom - vel_y) < (other.bbox_top - other.vel_y)) {
        if (other.object_index == obj_slime_enemy && other.state == CHARACTER_STATE.ATTACK) {
            // Player jumped on an attacking slime, hurts itself and not the slime
            if (no_hurt_frames == 0) {
                hp -= 0.5;
                no_hurt_frames = get_room_speed() * 2;
                // Add bounce effect
                vel_y = -jump_speed;
                // Add hurt effects (sound, animation, etc.)
                var _sound = audio_play_sound(snd_slime_attack, 0, 0);
                audio_sound_pitch(_sound, random_range(0.8, 1));
            }
        } else {
            // Set the HP of the 'other' instance (which is the enemy) to 0, so that it's defeated.
            other.hp = 0;
    
            // Set the vertical velocity of the player to -jump_speed so it bounces off the enemy.
            vel_y = -jump_speed;
    
            // Change the sprite to spr_player_jump as the player is now jumping (and not falling anymore).
            sprite_index = spr_player_fall;
            image_index = 0;
    
            // The animation speed at this point would be 0 if the fall animation had finished, so we reset
            // it to 1 so the jump animation can play.
            image_speed = 1;
    
            // This creates an instance of obj_effect_jump at the bottom of the player's mask. This is the
            // jump VFX animation.
            instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);
    
            // Play the enemy hit sound effect
            audio_play_sound(snd_enemy_hit, 0, 0);
    
            // Play the jump sound with a random pitch
            var _sound = audio_play_sound(snd_jump, 0, 0);
            audio_sound_pitch(_sound, random_range(0.8, 1));
        }

        // Finally, exit the event so the rest of the actions don't run (they make the player hurt)
        exit;
    }
}
