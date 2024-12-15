/// @description obj_sun inherts le_day_night_cycle
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Set the sun's properties
set_time(1, 0);    // Start at 6:00 PM
set_sunrise(0, 1); // Sunrise at 6:00 AM with a 0.5-hour transition
set_sunset(23, 1);  // Sunset at 6:00 PM with a 0.5-hour transition
set_day_speed(1);     // Default day speed

max_sunlight = 0.5;


// Set the sun's position and orbit direction
x = room_width; // Starting position at the far right of the room
y = room_height / 2; // Mid-height