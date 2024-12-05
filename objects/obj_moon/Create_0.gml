/// @description create event of obj_moon
event_inherited();

// Set the moon's properties
set_time(18, 0);    // Start at 6:00 PM
set_day_speed(1);   // Default day speed

// Set the moon's position and orbit direction
x = 0; // Starting position at the far left of the room
y = room_height / 2; // Mid-height