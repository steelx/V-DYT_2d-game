/// @description obj_guided_arrow Create Event
path = new ArchPath();
speed = 0;
damage = 1;
pierce = false;
lifetime = room_speed * 3;
path_following = true;
grav = 0.4;
vel_x = 0;
vel_y = 0;

// Initialize the path
init_path = function(_start_x, _start_y, _target_x, _target_y) {
    var _distance = point_distance(_start_x, _start_y, _target_x, _target_y);
    var _height = _distance * 0.3; // Arc height based on distance
    path.GenerateArc(_start_x, _start_y, _target_x, _target_y, _height, 15);
};
