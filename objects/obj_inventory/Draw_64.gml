/// @description  obj_inventory Draw GUI Event
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _slot_width = 80;
var _slot_height = 60;
var _padding = 10;
var _start_x = _gui_w - (_slot_width * 4 + _padding * 3) - _padding;
var _start_y = _gui_h - _slot_height - _padding;

// Draw slots
for (var i = 0; i < 4; i++) {
    var _x = _start_x + (i * (_slot_width + _padding));
    var _y = _start_y;
    
    // Draw background
    draw_set_color(colors.background);
    draw_rectangle(_x, _y, _x + _slot_width, _y + _slot_height, false);
    
    // Draw border
    draw_set_color(selected_slot == i ? colors.selected : colors.border);
    draw_rectangle(_x, _y, _x + _slot_width, _y + _slot_height, true);
    
    // Draw slot number and name using scribble
    var _slot_text = "[c_white]" + string(i + 1) + "\n";
    _slot_text += slots[i].name;
    
    if (i == INVENTORY_SLOTS.HEAL) {
        _slot_text += " [c_gray]<" + string(heal_potions) + ">[/c]";
    }
    
    draw_set_halign(fa_center);
    draw_text_scribble(_x + _slot_width/2, _y + 10, _slot_text);
}

#region Player Stats GUI

// Constants for stats UI
var _stats_x = 20;
var _stats_y = _gui_h - 140; // Position from bottom
var _bar_width = 200;
var _stat_spacing = 25;

// Make sure player exists before drawing stats
if (!instance_exists(obj_player)) exit;

// Title "ROGUE"
scribble_font_set_default("font_stats");
draw_text_scribble(_stats_x+20, _stats_y, "[c_blue]V-DYT[/c]");

// Health Bar (shorter, top bar)
_stats_y += _stat_spacing;
var _health_ratio = clamp(obj_player.hp / obj_player.max_hp, 0, 1);

draw_ui_bar(
    "[c_yellow]Health[]", _stats_x, _stats_y,
    150, 20,
    _health_ratio,
    make_color_rgb(238, 238, 0),
    make_color_rgb(139, 139, 0)
);

// Super Attack Bar
_stats_y += _stat_spacing;
var _super_ratio = clamp(obj_player.attack_fuel / obj_player.attack_fuel_max, 0, 1);
draw_ui_bar(
    "S Attack", _stats_x, _stats_y,
    150, 20,
    _super_ratio,
    make_color_rgb(238, 238, 0),
    make_color_rgb(139, 139, 0),
    "Press Shift + Spacebar key"
);

// Jetpack Bar
_stats_y += _stat_spacing;
var _jetpack_ratio = clamp(obj_player.jetpack_fuel / obj_player.jetpack_max_fuel, 0, 1);
draw_ui_bar(
    "Jetpack", _stats_x, _stats_y,
    _bar_width, 12,
    _jetpack_ratio,
    make_color_rgb(0, 255, 255),  // Cyan
    make_color_rgb(0, 139, 139)  // Dark cyan
);

// Blitz Points Bar
_stats_y += 16;
var _blitz_ratio = clamp(blitz_points / blitz_points_max, 0, 1);
draw_ui_bar(
    "Blitz", _stats_x, _stats_y,
    _bar_width, 12,
    _blitz_ratio,
    make_color_rgb(238, 238, 0),  // Yellow
    make_color_rgb(139, 139, 0),  // Dark yellow
    selected_slot == INVENTORY_SLOTS.BLITZ ? "[rainbow]Blitz Active" : ""
);
#endregion

// Reset drawing properties
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
