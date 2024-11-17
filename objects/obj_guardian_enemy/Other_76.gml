/// @desc Broadcast Message is received.
var _footstep_sounds = [
    snd_guardin_walk,
    snd_footstep_02,
    snd_footstep_03
];

var _message = event_data[? "message"];
var _max_footstep_distance = 300; // Adjust this value based on your game's scale

switch (_message) {
    case "guardian_footstep":
        // Get distance to player
        var _player = instance_nearest(x, y, obj_player);
        if (_player != noone) {
            var _dist = distance_to_object(_player);
            if (_dist < _max_footstep_distance) play_random_footstep(_footstep_sounds);
        }
        break;
}
