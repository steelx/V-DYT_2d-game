/// @description obj_player can bounce off launch-pad

with instance_place(x, bbox_top - 1, obj_player) {
    if (vel_y > 0) { // Only bounce if the player is moving downward
        vel_y = -(jump_speed+5); // Increased bounce
        sprite_index = spr_player_fall;
        image_index = 0;
        
        other.image_speed = 1;
        
        instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);
        
        // shader
        trail_intensity = 1.0;
        use_trail_shader = true;
        ds_list_clear(trail_positions);
        
        // audio
        audio_play_sound(snd_box_hit, 0, 0);
        var _sound = audio_play_sound(snd_jump, 0, 0);
        audio_sound_pitch(_sound, random_range(0.8, 1));
    }
}