var _tex   = sprite_get_texture(normal_sprite, 0),
	_tex_w = texture_get_texel_width(_tex),
	_tex_h = texture_get_texel_height(_tex),
	_uvs   = sprite_get_uvs(normal_sprite, 0);
	
var _x_norm = _uvs[0] - _uvs[4] * _tex_w,
	_y_norm = _uvs[1] - _uvs[5] * _tex_h,
	_w_norm = (_uvs[2] - _uvs[0]) / _uvs[6],
	_h_norm = (_uvs[3] - _uvs[1]) / _uvs[7];
	
normal_tex = _tex;

_tex   = sprite_get_texture(material_sprite, 0);
_tex_w = texture_get_texel_width(_tex);
_tex_h = texture_get_texel_height(_tex);
_uvs   = sprite_get_uvs(material_sprite, 0);

var _x_mat = _uvs[0] - _uvs[4] * _tex_w,
	_y_mat = _uvs[1] - _uvs[5] * _tex_h,
	_w_mat = (_uvs[2] - _uvs[0]) / _uvs[6],
	_h_mat = (_uvs[3] - _uvs[1]) / _uvs[7];

material_tex = _tex;

uv_array = [_x_norm, _y_norm, _w_norm, _h_norm, _x_mat, _y_mat, _w_mat, _h_mat];

event_user(5);
skeleton_animation_set(default_anim);
skeleton_skin_set(default_skin);