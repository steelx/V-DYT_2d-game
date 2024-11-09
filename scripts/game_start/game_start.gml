function resume_game() {
    global.game_state = GAME_STATES.PLAYING;
    global.show_game_menu = false;
    if variable_global_exists("menu_music") and audio_is_playing(global.menu_music) {
        audio_pause_sound(global.menu_music);
        audio_play_sound(sine_beep_simple, 2, false);
    }
    
    if variable_global_exists("game_music") and audio_exists(global.game_music) {
        audio_resume_sound(global.game_music);
    } else {
        global.game_music = audio_play_sound(snd_sci_fi_1_loop, 2, true);
    }
}

function pause_game() {
    global.game_state = GAME_STATES.PAUSED;
    global.show_game_menu = true; // in case of Dialog box we dont set this
	show_debug_message($"show_game_menu {global.show_game_menu}");
    audio_pause_sound(global.game_music);
    audio_play_sound(start_bleep, 2, false);
    
    // Start playing menu background music
    if variable_global_exists("menu_music") and audio_exists(global.menu_music) {
        audio_resume_sound(global.menu_music);
        audio_play_sound(sine_beep_simple, 2, false);
    } else {
        global.menu_music = audio_play_sound(snd_music_menu, 1, true);
    }
}

function should_pause_object() {
	return global.game_state == GAME_STATES.PAUSED;
}
