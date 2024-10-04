function get_room_speed(_seconds = 1){
    return game_get_speed(gamespeed_fps) * _seconds;
}

/**
* Checks if the current animation is at its last frame.
* @returns {bool} True if the animation is at its last frame, false otherwise
*/
function is_animation_end() {
    return (image_index >= image_number - sprite_get_speed(sprite_index)/get_room_speed());
}
