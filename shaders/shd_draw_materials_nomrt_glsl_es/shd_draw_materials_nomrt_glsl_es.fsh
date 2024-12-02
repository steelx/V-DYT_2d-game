precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec2 tex_coord;
varying vec4 material;

void main()
{	
	vec4 col = texture2D(gm_BaseTexture, tex_coord);
	if (col.a < 0.01) discard;
	
	frag_color = vec4(col.rgb * material.rgb, material.a);
}