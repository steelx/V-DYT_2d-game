// This creates an instance of obj_end_gate_particles which draws over the end gate itself
// and displays a particle animation
// It's created at the same position and on the same layer as the end gate itself
var _particle_instance = instance_create_layer(x, y, layer, obj_end_gate_particles);

// The depth of the particle instance is set to be 10 lower than the end gate's
// depth, so the particles are drawn above the end gate itself
_particle_instance.depth = depth - 10;

// Create an audio emitter for the end gate's ambient audio
emitter = audio_emitter_create();

// Set the position of the emitter to the position of the instance
audio_emitter_position(emitter, x, y, 0);

// Set the falloff settings for the audio emitter
audio_emitter_falloff(emitter, 640, 720, 1);

// Play a looping portal ambience sound on the emitter
audio_play_sound_on(emitter, snd_portal_01, true, 1);

// Play a looping portal ambience sound on the emitter
audio_play_sound_on(emitter, snd_portal_02, true, 1);