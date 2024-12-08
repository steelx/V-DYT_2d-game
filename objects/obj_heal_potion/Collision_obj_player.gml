/// @description obj_gem collision with Player
// gets picked up by player
if drop_item.can_pickup {
	die = true;
	
	if instance_exists(obj_inventory) {
		with (obj_inventory) {
			heal_potions = min(heal_potions + 1, heal_potions_max)
		}
	}
}