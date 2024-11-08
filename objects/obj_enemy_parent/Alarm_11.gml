/// @description ENEMY_SMART_SEARCH Timer End
// This event is triggered when the smart search timer expires
if (enable_smart) {
    // Reset the smart search state
    smart_search_timer = 0;
    
    // If the player is not visible, start returning to the original position
    if (!is_player_visible(visible_range)) {
        state = CHARACTER_STATE.MOVE;
        vel_x = sign(original_x - x) * move_speed;
    }
    // If the player is visible, we don't need to do anything special
    // The normal behavior in the Step event will handle it
}

// If you want to add any visual or audio cues that the search is over, you can do it here
// For example:
audio_play_sound(alert_zornath, 1, false);

