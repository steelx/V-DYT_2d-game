// Define sound priorities
enum SoundPriority {
    AMBIENT = 1,
    MOVEMENT = 3,
    COMBAT = 5,
    CRITICAL = 8
}
global.MAX_SOUNDS = 50;

// Play sound with priority
function play_priority_sound(_sound, _priority = SoundPriority.AMBIENT) {
    audio_play_sound(_sound, _priority, false);
}

function play_knockback_sound(_knockback_strength) {
    // Base impact sound
    audio_play_sound(snd_knockback_impact, 5, false);
    
    // Additional effects based on strength
    if (_knockback_strength > 5) {
        audio_play_sound(snd_heavy_impact, 6, false, 0.7);
    }
}

function play_spatial_sound(_sound, _emitter_x, _emitter_y, _max_distance) {
    var _distance = point_distance(x, y, _emitter_x, _emitter_y);
    var _volume = 1 - (_distance / _max_distance);
    _volume = clamp(_volume, 0, 1);
    
    audio_play_sound(_sound, 1, false, _volume);
}

// Create array of similar sounds
global.footstep_sounds = [
    snd_footstep_01,
    snd_footstep_02,
    snd_footstep_03
];

// Play random variation
function play_random_footstep(_footstep_sounds = global.footstep_sounds) {
    var _sound = _footstep_sounds[irandom(array_length(_footstep_sounds) - 1)];
    audio_play_sound(_sound, 1, false, 0.5);
}
