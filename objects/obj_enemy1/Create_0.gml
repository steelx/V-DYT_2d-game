event_inherited();

// This is the object that replaces the enemy once it is defeated.
defeated_object = obj_enemy1_defeated;
max_hp = 1;
hp = max_hp;
move_speed = 1.25;
// This applies either move_speed or negative move_speed to the enemy's X velocity. This way the enemy will
// either move left or right (at random).
// This action is present in the enemy parent object as well, but we're running it again in this child object,
// as its move_speed value has changed.
vel_x = choose(-move_speed, move_speed);
state = CHARACTER_STATE.MOVE;
gems = 3;
