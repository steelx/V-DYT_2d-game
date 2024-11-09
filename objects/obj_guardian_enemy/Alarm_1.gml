/// @description Alarm 1 Roam/Walk behaviour
// play walk start sound
var _audible_distance = 300;
var _player_distance = distance_to_object(obj_player);
if _player_distance < _audible_distance {
    var _sound = audio_play_sound(snd_guardin_walk, 0, 0);
  
    // Adjust volume based on distance
    var _volume = 1 - (_player_distance / _audible_distance);
    _volume = clamp(_volume, 0, 1);
    audio_sound_gain(_sound, _volume, 0);
    audio_sound_pitch(_sound, random_range(0.8, 1));
}

