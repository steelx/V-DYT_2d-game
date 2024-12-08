/// @description obj_gem collision with Player
// gets picked up by player
if drop_item.can_pickup {
	die = true;
	
	if instance_exists(obj_inventory) {
		with (obj_inventory) {
			blitz_points = min(blitz_points + 1, blitz_points_max)
		}
	}
}