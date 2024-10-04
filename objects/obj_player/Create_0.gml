// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();

obj_camera.follow = obj_player;

// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 15;