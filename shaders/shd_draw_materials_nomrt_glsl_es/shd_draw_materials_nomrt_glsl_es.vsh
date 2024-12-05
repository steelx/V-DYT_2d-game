precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2  tex_coord;
varying vec4  material;

void main()
{
	float mat = in_Colour.r * 15.9375;
	float metallic = floor(mat);
	float roughness = (mat - metallic) * 1.06666666666666666666666666666667;
	metallic *= 0.06666666666666666666666666666667;
	material = vec4(metallic, roughness, 1.0, in_Colour.a);
	
	float depth = (in_Colour.g * 65280.0) + (in_Colour.b * 255.0) - 16000.0;
	
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, depth, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
	tex_coord   = in_TextureCoord;
}