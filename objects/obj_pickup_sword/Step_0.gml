/// @description obj_pickup_sword step
event_inherited();

if (player_within_range(interaction_area)) {

	if tooltip_instance == noone {
        tooltip_instance = draw_tooltip(tooltip_text, x, y-16, function() {
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
apply_horizontal_movement();
