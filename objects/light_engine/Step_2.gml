/// @description Update buffer

var _area = get_shadow_area(x, y),
	_buff = _area.get_vertex_buffer(vertex_format);

// Seems weird, but buffer_exists and vertex buffers leads to memory leaks...
if ((vertex_buffer != vertex_buffer_dummy) && vertex_buffer != noone) vertex_delete_buffer(vertex_buffer);
vertex_buffer = (_buff == noone ? vertex_buffer_dummy : _buff);