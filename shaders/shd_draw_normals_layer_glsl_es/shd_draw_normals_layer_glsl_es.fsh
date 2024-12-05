precision highp float;

#define EM_BIT 0.0039215686274509803921568627451

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec2 tex_coords;
varying float emissive;

void main()
{
    vec4 normal = texture2D(gm_BaseTexture, tex_coords);
	if (normal.a == 0.0) discard;
	frag_color = vec4(normal.rgb, emissive * (normal.a - EM_BIT));
}