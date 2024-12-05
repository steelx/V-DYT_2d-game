precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

varying	vec2 vs_tex_coord;
varying vec3 vs_world_pos;

void main()
{	
	vs_tex_coord = in_TextureCoord;
	vs_world_pos = in_Position;
	
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}