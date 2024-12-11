/// @description Insert description here

if (player_within_range(interaction_area)) {
	sprite_index = near_sprite;
	image_speed = 1;
	
	if !instance_exists(tooltip_instance) {
        tooltip_instance = draw_tooltip(tooltip_text, x+16, y-16, function() {
            if (interaction_function != undefined) {
				play_priority_sound(snd_button_press_01);
                interaction_function();
            }
        });
    }
} else {
    if (instance_exists(tooltip_instance)) {
        tooltip_instance.target_alpha = 0;
        tooltip_instance = noone;
    }
	sprite_index = idle_sprite;
	image_speed = 1;
}
