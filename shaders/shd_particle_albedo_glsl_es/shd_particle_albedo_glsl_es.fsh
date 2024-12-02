precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec2 tex_coord;
varying vec4 part_color;

void main()
{
	frag_color = texture2D(gm_BaseTexture, tex_coord) * part_color;
}
