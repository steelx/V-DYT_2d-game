/// @description Insert description here

with instance_place(x, bbox_top - 1, obj_player) {
    if (vel_y > 0) { // Only bounce if the player is moving downward
        vel_y = -(jump_speed + 5); // Increased bounce
        sprite_index = spr_player_jump;
        image_index = 0;
        
        other.image_speed = 1;
        
        instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);
        
        audio_play_sound(snd_enemy_hit, 0, 0);
        var _sound = audio_play_sound(snd_jump, 0, 0);
        audio_sound_pitch(_sound, random_range(0.8, 1));
    }
}