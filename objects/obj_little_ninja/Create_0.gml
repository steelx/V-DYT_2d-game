event_inherited();
image_xscale *= 1.2;
image_yscale *= 1.2;
// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_enemy1_defeated;
max_hp = 1;
hp = max_hp;

// This applies either move_speed or negative move_speed to the enemy's X velocity. This way the enemy will
// either move left or right (at random).
// This action is present in the enemy parent object as well, but we're running it again in this child object,
// as its move_speed value has changed.
vel_x = choose(-move_speed, move_speed);