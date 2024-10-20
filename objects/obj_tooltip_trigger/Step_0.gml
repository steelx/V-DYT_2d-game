/// @description obj_tooltip_trigger Step event
/// Replace obj_player with your actual player object
//var _player = instance_nearest(x, y, obj_player);

if (place_meeting(x, y, obj_player) && !tooltip_used) {
    if (!instance_exists(tooltip_instance)) {
        tooltip_instance = draw_tooltip(tooltip_text, tooltip_icon, x, y, function() {
            if (interaction_function != undefined) {
                interaction_function();
                tooltip_used = true;  // Mark the tooltip as used after interaction
            }
        });
    }
} else {
    if (instance_exists(tooltip_instance)) {
        tooltip_instance.target_alpha = 0;
        tooltip_instance = noone;
    }
}

// tooltip_used sets only in case of a interaction function passed
if tooltip_used {
    instance_destroy();
}


