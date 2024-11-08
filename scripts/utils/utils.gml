function get_room_speed(){
    return game_get_speed(gamespeed_fps);
}

/**
* Checks if the current animation is at its last frame.
* @returns {bool} True if the animation is at its last frame, false otherwise
*/
function is_animation_end() {
    return (image_index >= image_number - sprite_get_speed(sprite_index)/get_room_speed());
}

/**
* Call this after draw text to clear text color for next render
*/
function clear_text_color() {
	draw_set_font(-1);  // Reset to default font
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}