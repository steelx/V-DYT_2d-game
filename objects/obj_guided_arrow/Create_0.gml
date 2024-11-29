/// @description obj_guided_arrow Create Event
path = new ArcPath();
path._inst = id;
path.is_projectile = true;

speed = 0;
damage = 1;
pierce = false;
lifetime = get_room_speed() * 3;
path_following = true;
grav = 0.4;
vel_x = 0;
vel_y = 0;

// Initialize the path
init_path = function(_start_x, _start_y, _target_x, _target_y) {
    var _distance = point_distance(_start_x, _start_y, _target_x, _target_y);
    var _base_height = _distance * 0.3; // Base arc height based on distance
    path.GenerateArc(_start_x, _start_y, _target_x, _target_y, _base_height, 15);
};
