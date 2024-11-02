// Example usage:
/*
function display_log1() {
    show_debug_message("seq_1 finished");
}

// Create a sequence
var seq = create_seq("seq_1", 6)
    .add_object(obj_player, 1, 100, 200)      // Add player object at 1s
    .add_sprite(spr_effect, 1.5, 100, 200)    // Add sprite at 1.5s
    .add_sound(snd_music_1, 2)                // Add sound at 2s
    .add_moment(display_log1, 6)              // Add callback at 6s
    .build();

// Play the sequence
var seq_instance = layer_sequence_create("Sequences", 0, 0, seq);

// Types
sequence_track_set_type(track, seqtracktype_instance);  // For objects
sequence_track_set_type(track, seqtracktype_audio);     // For sounds
sequence_track_set_type(track, seqtracktype_moment);    // For moments
sequence_track_set_type(track, seqtracktype_graphic);   // For sprites
*/

/// @description Sequence Builder utility with chainable methods
function SequenceBuilder(_name, _duration_seconds) constructor {
    name = _name;
    duration = _duration_seconds * get_room_speed();
    sequence = sequence_create();
	sequence.length = duration;
    tracks = [];
	momentKeyframes = [];
    
    /// @method add_object(object, time_range, x, y)
    add_object = function(object, time_range, x = 0, y = 0) {
        var track = sequence_track_new(seqtracktype_instance);
        track.name = "InstanceTrack_" + string(array_length(tracks));
        
        var keyframe = sequence_keyframe_new(seqtracktype_instance);
        keyframe.frame = time_range[0] * get_room_speed();
        keyframe.length = (time_range[1] - time_range[0]) * get_room_speed();
        keyframe.stretch = true;
        keyframe.disabled = false;
        
        var keyframedata = sequence_keyframedata_new(seqtracktype_instance);
        keyframedata.objectIndex = object;
        keyframedata.channel = 0;
        keyframedata.x = x;
        keyframedata.y = y;
        
        keyframe.channels = [keyframedata];
        track.keyframes = [keyframe];
        array_push(tracks, track);
        return self;
    }

    /// @method add_sprite(sprite, time_range, x, y)
    add_sprite = function(sprite, time_range, x = 0, y = 0) {
        var track = sequence_track_new(seqtracktype_graphic);
        track.name = "GraphicTrack_" + string(array_length(tracks));
        
        var keyframe = sequence_keyframe_new(seqtracktype_graphic);
        keyframe.frame = time_range[0] * get_room_speed();
        keyframe.length = (time_range[1] - time_range[0]) * get_room_speed();
        keyframe.stretch = true;
        keyframe.disabled = false;
        
        var keyframedata = sequence_keyframedata_new(seqtracktype_graphic);
        keyframedata.spriteIndex = sprite;
        keyframedata.channel = 0;
        keyframedata.x = x;
        keyframedata.y = y;
        
        keyframe.channels = [keyframedata];
        track.keyframes = [keyframe];
        array_push(tracks, track);
        return self;
    }
    
    /// @method add_sound(sound, time_seconds)
    add_sound = function(sound, time_seconds) {
        var track = sequence_track_new(seqtracktype_audio);
        track.name = "AudioTrack_" + string(array_length(tracks));
        
        var keyframe = sequence_keyframe_new(seqtracktype_audio);
        keyframe.frame = time_seconds * get_room_speed();
        keyframe.length = 1;
        keyframe.stretch = false;
        keyframe.disabled = false;
        
        var keyframedata = sequence_keyframedata_new(seqtracktype_audio);
        keyframedata.soundIndex = sound;
        keyframedata.channel = 0;
        
        keyframe.channels = [keyframedata];
        track.keyframes = [keyframe];
        
        array_push(tracks, track);
        
        return self;
    }
    
    /// @method add_moment(callback, time_seconds)
    add_moment = function(_callback, _time_seconds) {
        var keyframe = sequence_keyframe_new(seqtracktype_moment);
        keyframe.frame = _time_seconds * get_room_speed();
        keyframe.length = 1;
        keyframe.stretch = false;
        keyframe.disabled = false;

        var keyframedata = sequence_keyframedata_new(seqtracktype_moment);
        keyframedata.event = method({callback: _callback}, _callback);
        keyframedata.channel = 0;

        keyframe.channels = [keyframedata];
        array_push(momentKeyframes, keyframe);
        return self;
    }
    
    /// @method build()
    build = function() {
        sequence.tracks = tracks;
        sequence.momentKeyframes = momentKeyframes;
        return sequence;
    }
}


/// @function create_seq(name, duration_seconds)
function create_seq(name, duration_seconds) {
    return new SequenceBuilder(name, duration_seconds);
}

