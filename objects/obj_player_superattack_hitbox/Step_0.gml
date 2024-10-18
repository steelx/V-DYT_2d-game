/// @description Insert description here
move_steps--;

x += facing*move_speed;

if move_steps <= 0 {
    die = true;
}