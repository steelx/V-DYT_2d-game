// This runs the Create event of the parent, ensuring the player gets all variables from the character parent.
event_inherited();

obj_camera.follow = obj_player;

// This variable stores the number of coins the player has collected.
coins = 0;
in_knockback = false;
defeated_object = obj_player_defeated;
jump_speed = 15;

// Bounce Shader variables
trail_intensity = 0;
trail_color = make_color_rgb(255, 200, 0); // A golden color for the trail
use_trail_shader = false;
trail_positions = ds_list_create();
trail_count = 10; // Number of trail instances

