precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec2 tex_coord;

uniform sampler2D s_bloom_dof;

void main()
{
	vec4 bloom_dof = texture2D(s_bloom_dof, tex_coord);
    vec4 light = texture2D(gm_BaseTexture, tex_coord);
	frag_color = vec4(light.rgb + bloom_dof.rgb, light.a);
}