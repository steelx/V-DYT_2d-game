/// @description Insert description here
var _player = instance_nearest(x, y, obj_player);  // Replace obj_player with your actual player object

if (place_meeting(x, y, _player)) {
    if (!instance_exists(tooltip_instance)) {
        tooltip_instance = instance_create_layer(0, 0, "Instances", obj_tooltip);
        tooltip_instance.text = tooltip_text;
        tooltip_instance.icon = tooltip_icon;
        tooltip_instance.target_alpha = 1;
    }
    // Update the tooltip's position
    tooltip_instance.trigger_x = x;
    tooltip_instance.trigger_y = y;
} else {
    if (instance_exists(tooltip_instance)) {
        tooltip_instance.target_alpha = 0;
        tooltip_instance = noone;
    }
}

