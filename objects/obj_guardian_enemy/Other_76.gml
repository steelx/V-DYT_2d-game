/// @desc Broadcast Message is received.
var _footstep_sounds = [
    snd_guardin_walk,
    snd_footstep_02,
    snd_footstep_03
];

var _message = event_data[? "message"];
var _max_footstep_distance = 500; // Adjust this value based on your game's scale

switch (_message) {
    case "guardian_footstep":
        // Get distance to player
        var _player = instance_nearest(x, y, obj_player);
        if (_player != noone) {
            // Use spatial sound for distance-based volume
            var _sound = _footstep_sounds[irandom(array_length(_footstep_sounds) - 1)];
            play_spatial_sound(
                _sound,
                x,
                y,
                _max_footstep_distance
            );
            
            // Play with priority to manage sound count
            play_priority_sound(
                _sound,
                SoundPriority.MOVEMENT
            );
        }
        break;
}
