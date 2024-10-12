/// @description Space key press
// Attack action
if (state != CHARACTER_STATE.ATTACK && state != CHARACTER_STATE.SUPER_ATTACK) {
    if (is_super_attack_key_held() && attack_fuel >= attack_fuel_consumption_rate) {
        state = CHARACTER_STATE.SUPER_ATTACK;
        sprite_index = spr_hero_super_attack;
        image_index = 0;
        attack_fuel -= attack_fuel_consumption_rate;
    } else {
        state = CHARACTER_STATE.ATTACK;
        sprite_index = spr_hero_attack;
        image_index = 0;
    }
}
