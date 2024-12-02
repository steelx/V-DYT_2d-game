precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 params;
varying vec2 rot;

uniform vec4 u_uvs;
uniform vec4 u_params;

void main()
{
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, u_params.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	params = vec4(in_TextureCoord * u_uvs.zw + u_uvs.xy, u_params.x, u_params.y);
	
	float theta = -radians(u_params.w);
	rot = vec2(cos(theta), sin(theta));
}
