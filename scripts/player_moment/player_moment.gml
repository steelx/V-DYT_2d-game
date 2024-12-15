// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function spawn_sword_pickup_object() {
	if instance_exists(obj_player) {
		var _x = obj_player.x + (80 * obj_player.image_xscale);
		var _y = obj_player.y;
		instance_create_layer(_x, _y, "Player", obj_pickup_sword);
	}
}