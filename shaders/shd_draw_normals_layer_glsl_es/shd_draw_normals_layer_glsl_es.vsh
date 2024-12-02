precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

#define M_2PI  6.283185307179586476925286766559

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 tex_coords;
varying float emissive;

uniform float u_params;

void main()
{
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
	tex_coords = in_TextureCoord;
	emissive = u_params;
}
