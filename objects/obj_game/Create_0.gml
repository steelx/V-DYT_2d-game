/// @description obj_game
// in the room start we set global variables

enum CHARACTER_STATE {
    PAUSED,
    IDLE,
    MOVE,
    JUMP,
    JETPACK_JUMP,
    KNOCKBACK,
    ATTACK,
    SUPER_ATTACK,
	ALERT,
	CHASE,
	SEARCH
}

enum GAME_STATES {
    PLAYING,
    PAUSED,
    CUTSCENE,
    GAME_OVER
}

_states = [
    "PAUSED",
	"IDLE",
    "MOVE",
    "JUMP",
    "JETPACK_JUMP",
    "KNOCKBACK",
    "ATTACK",
    "SUPER_ATTACK",
    "ALERT",
    "CHASE",
    "SEARCH",
]

debug_render_mask = function() {
    draw_set_alpha(0.3);
	draw_set_color(c_yellow);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_alpha(1);
	draw_text(x, y, _states[state]);

	if object_index == obj_player {
        draw_text(x, y+10, "Jet Fuel: " + string(jetpack_fuel));
        draw_set_color(c_white);
        draw_text(x+10, y+20, "Attack Fuel: " + string(attack_fuel));
    }
};


global.game_state = GAME_STATES.PLAYING;
global.show_game_menu = false;
menu_options = ["Resume", "Restart", "Quit"];
option_num = array_length(menu_options);
menu_min = 0; // we show Resume only if game is not over, esle min = 1
menu_index = 0;

// Menu surface
menu_surface = -1;
surface_width = window_get_width()/2;
surface_height = window_get_height()/2;
_needs_redraw = true;

// Menu style
menu_font = font_menu;
menu_item_height = 40;
menu_width = 200;
menu_x = (surface_width - menu_width) / 2;
menu_y = (surface_height - (menu_item_height * array_length(menu_options))) / 2;

// Player states GUI
_gui_needs_redraw = true;
gui_surface = -1;
