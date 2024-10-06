/// @desc obj_enemy_parent -> inheriting obj_character_parent

event_inherited();

// This is the amount of damage the enemy does to the player.
damage = 1;
visible_range = 64;// how far enemy can see

// This sets the movement speed for the enemies.
move_speed = 1.5;

// This applies either move_speed or negative move_speed to the enemy's X velocity. This way the enemy will
// either move left or right (at random).
vel_x = choose(-move_speed, move_speed);

// This sets the friction to 0 so the enemy never comes to a stop.
friction_power = 0;

// Set initial state
state = CHARACTER_STATE.MOVE;
