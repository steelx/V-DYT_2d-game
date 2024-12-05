precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

#define M_2PI  6.283185307179586476925286766559

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 coords;
varying float has_map;
varying float has_emissive;

void main()
{
	float depth = floor(in_Colour.g * 65280.0);
	float theta = -in_Colour.a * M_2PI;
	has_map = float(depth >= 32768.0);
	depth = (depth - 32768.0 * has_map) + floor(in_Colour.b * 255.0) - 16000.0;
	
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, depth, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
	has_emissive = in_Colour.r;
	coords = vec4(in_TextureCoord, cos(theta), sin(theta));
}
