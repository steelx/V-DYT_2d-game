// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function spawn_sword_pickup_object() {
	var _throw_end_dist = 80;
	if instance_exists(obj_player) {
		var _throw_dir = obj_player.image_xscale;
		var _y = obj_player.y;
		var _x = obj_player.x + (_throw_end_dist * _throw_dir);
		var _obstacle = global.collision_grid.GetObstacleAtPosition(_x, _y);
		while (_obstacle != noone) {
			var _opp_dir = (_throw_dir*-1)
			_x = _obstacle.position.x + (global.tile_size * _opp_dir);// assume next might be noone
			var _next_grid_x = _obstacle.grid_pos.x+_opp_dir;// keep moving towards player
			_obstacle = global.collision_grid.GetObstacleAtGridPos(_next_grid_x, _obstacle.grid_pos.y);
		}
		
		instance_create_layer(_x, _y, "Player", obj_pickup_sword);
	}
}