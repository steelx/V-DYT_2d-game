precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 params;
varying vec4 uv;
varying float occlusion;

uniform float u_uvs[8];
uniform vec4 u_params;
uniform float u_occlusion;

void main()
{
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, u_params.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	float theta = -radians(u_params.w);
	params = vec4(u_params.x, u_params.y, cos(theta), sin(theta));
	
	// UVs for normal and material maps
    uv = vec4(in_TextureCoord.x * u_uvs[2] + u_uvs[0], in_TextureCoord.y * u_uvs[3] + u_uvs[1], 
			  in_TextureCoord.x * u_uvs[6] + u_uvs[4], in_TextureCoord.y * u_uvs[7] + u_uvs[5]);
	
	occlusion = u_occlusion;
}
