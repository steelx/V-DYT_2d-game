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
/// @link https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sequences/Sequences.htm
function SequenceBuilder(_name, _duration_seconds) constructor {
    name = _name;
    sequence = sequence_create();
	sequence.length = _duration_seconds * get_room_speed();
	sequence.playbackSpeedType = spritespeed_framespersecond;
	sequence.loopmode = seqplay_oneshot;
    tracks = [];
	momentKeyframes = [];
	
	/// @method add_object(object, time_range, x, y)
	add_object = function(_object, _time_range, _x = 0, _y = 0) {
	    var _track = sequence_track_new(seqtracktype_instance);
	    _track.name = "InstanceTrack_" + string(array_length(tracks));

	    var _keyframe = sequence_keyframe_new(seqtracktype_instance);
	    _keyframe.frame = _time_range[0] * get_room_speed();
	    _keyframe.length = (_time_range[1] - _time_range[0]) * get_room_speed();
	    _keyframe.stretch = false;
	    _keyframe.disabled = false;

	    var _keyframedata = sequence_keyframedata_new(seqtracktype_instance);
	    _keyframedata.objectIndex = _object;
	    //_keyframedata.objectIndex = obj_sequence_object_creator;
	    _keyframedata.channel = 0;
	    _keyframedata.x = _x;
	    _keyframedata.y = _y;
	    _keyframedata.scaleX = 1;
	    _keyframedata.scaleY = 1;
	    _keyframedata.rotation = 0;
	    _keyframe.channels = [_keyframedata];
	    _track.keyframes = [_keyframe];

	    // Add end keyframe to ensure object removal
	    var _end_keyframe = sequence_keyframe_new(seqtracktype_instance);
	    _end_keyframe.frame = _time_range[1] * get_room_speed();
	    _end_keyframe.length = 1;
	    _end_keyframe.stretch = false;
	    _end_keyframe.disabled = true;

	    var _end_keyframedata = sequence_keyframedata_new(seqtracktype_instance);
	    _end_keyframedata.objectIndex = _object;
	    _end_keyframedata.channel = 0;
	    _end_keyframedata.x = _x;
	    _end_keyframedata.y = _y;
	    _end_keyframedata.scaleX = 1;
	    _end_keyframedata.scaleY = 1;
	    _end_keyframedata.rotation = 0;
	    _end_keyframedata.visible = false;

	    _end_keyframe.channels = [_end_keyframedata];
	    array_push(_track.keyframes, _end_keyframe);
	    array_push(tracks, _track);
		
	    return self;
	}


    /// @method add_sprite(sprite, time_range, x, y)
	add_sprite = function(_sprite, _time_range, _x = 0, _y = 0) {
	    var _track = sequence_track_new(seqtracktype_graphic);
	    _track.name = "GraphicTrack_" + string(array_length(tracks));
    
	    var _keyframe = sequence_keyframe_new(seqtracktype_graphic);
	    _keyframe.frame = _time_range[0] * get_room_speed();
	    _keyframe.length = (_time_range[1] - _time_range[0]) * get_room_speed();
	    _keyframe.stretch = false;
	    _keyframe.disabled = false;
    
	    var _keyframedata = sequence_keyframedata_new(seqtracktype_graphic);
	    _keyframedata.spriteIndex = _sprite;
	    _keyframedata.channel = 0;
	    _keyframedata.x = _x;
	    _keyframedata.y = _y;
	    _keyframedata.scaleX = 1;
	    _keyframedata.scaleY = 1;
	    _keyframedata.rotation = 0;
    
	    _keyframe.channels = [_keyframedata];
	    _track.keyframes = [_keyframe];
    
	    // Add end keyframe to ensure sprite removal
	    var _end_keyframe = sequence_keyframe_new(seqtracktype_graphic);
	    _end_keyframe.frame = _time_range[1] * get_room_speed();
	    _end_keyframe.length = 1;
	    _end_keyframe.stretch = false;
	    _end_keyframe.disabled = true;
    
	    var _end_keyframedata = sequence_keyframedata_new(seqtracktype_graphic);
	    _end_keyframedata.spriteIndex = _sprite;
	    _end_keyframedata.channel = 0;
	    _end_keyframedata.x = _x;
	    _end_keyframedata.y = _y;
	    _end_keyframedata.scaleX = 1;
	    _end_keyframedata.scaleY = 1;
	    _end_keyframedata.rotation = 0;
	    _end_keyframedata.visible = false;
    
	    _end_keyframe.channels = [_end_keyframedata];
	    array_push(_track.keyframes, _end_keyframe);
    
	    array_push(tracks, _track);
	    return self;
	}


    /// @method add_sound(_sound, time_seconds)
    add_sound = function(_sound, _time_seconds) {
        var _track = sequence_track_new(seqtracktype_audio);
	    _track.name = "AudioTrack_" + string(array_length(tracks));
    
	    var _keyframe = sequence_keyframe_new(seqtracktype_audio);
	    _keyframe.frame = _time_seconds * get_room_speed();
	    _keyframe.length = audio_sound_length(_sound) * get_room_speed(); // Set length to sound duration
	    _keyframe.stretch = false;
	    _keyframe.disabled = false;
    
	    var _keyframedata = sequence_keyframedata_new(seqtracktype_audio);
	    _keyframedata.soundIndex = _sound;
	    _keyframedata.channel = 0;
	    _keyframedata.offset = 0; // Start playing from the beginning of the sound
	    _keyframedata.pitch = 1; // Normal pitch
	    _keyframedata.volume = 1; // Full volume
    
	    _keyframe.channels = [_keyframedata];
	    _track.keyframes = [_keyframe];
	    array_push(tracks, _track);
	    return self;
    }
    
    /// @method add_moment(_callback, _time_seconds)
    add_moment = function(_callback, _time_seconds) {
        var _keyframe = sequence_keyframe_new(seqtracktype_moment);
        _keyframe.frame = _time_seconds * get_room_speed();
        _keyframe.length = 1;
        _keyframe.stretch = false;
        _keyframe.disabled = false;

        var _keyframedata = sequence_keyframedata_new(seqtracktype_moment);
        _keyframedata.event = method({callback: _callback}, _callback);
        _keyframedata.channel = 0;

        _keyframe.channels = [_keyframedata];
        array_push(momentKeyframes, _keyframe);
        return self;
    }
    
    /// @method build()
    build = function() {
        sequence.tracks = tracks;
        sequence.momentKeyframes = momentKeyframes;
        return sequence;
    }
}


/// @function create_seq(_name, _duration_seconds)
function create_seq(_name, _duration_seconds) {
    return new SequenceBuilder(_name, _duration_seconds);
}

