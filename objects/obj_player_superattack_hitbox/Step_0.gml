/// @description obj_player_superattack_hitbox step
move_steps--;

x += facing*move_speed;

if move_steps <= 0 {
    die = true;
}