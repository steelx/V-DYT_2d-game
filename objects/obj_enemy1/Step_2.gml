/// @description Insert description here
// switch direction for enemy

// Inherit the parent event
event_inherited();

if state == CHARACTER_STATE.MOVE {
	// This checks if there is another enemy where this enemy is moving. This is used to make
    // the enemy turn if it runs into another enemy, so they don't pass through each other.
    var _inst = instance_place(x + vel_x * 16, y, obj_enemy_parent);
    if (_inst != noone) {
        // In that case the enemy turns.
        vel_x = -vel_x;
    }
}