
// useage in obj_load_room_1 create
function start_sequence_chain_1() {
    global.sequence_array = [
		function() { global.game_state = GAME_STATES.PAUSED; },
		/*
        function () {
			return create_seq("seq_2a", 5)// TODO: fix this to seconds
				.add_sound(snd_amb_wind, 1)
			    .add_object(obj_seq_2_titles, [0, 5])
			    //.add_sprite(spr_end_gate_particles, [5, 6])
			    .add_moment(function() {
					audio_stop_sound(snd_amb_wind);
				 }, 5)
			    .build();
		},
		*/
		seq_fade_in,
		//seq_1,
		seq_fade_out,
        function() {
			room_goto_next();
			global.game_state = GAME_STATES.PLAYING;
        }
    ];
    
    global.current_sequence_index = 0;
    load_next_sequence(global.sequence_array);
}
