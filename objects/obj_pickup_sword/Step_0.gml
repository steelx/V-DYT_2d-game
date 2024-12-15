/// @description obj_pickup_sword step

if (player_within_range(interaction_area)) {

	if tooltip_instance == noone {
        tooltip_instance = draw_tooltip(tooltip_text, x+16, y-16, function() {
            if (interaction_function != undefined) {
				play_priority_sound(snd_button_press_01, SoundPriority.AMBIENT);
                interaction_function();
            }
        });
    }
} else {
    if (instance_exists(tooltip_instance)) {
        tooltip_instance.target_alpha = 0;
        tooltip_instance = noone;
    }
}

apply_verticle_movement();