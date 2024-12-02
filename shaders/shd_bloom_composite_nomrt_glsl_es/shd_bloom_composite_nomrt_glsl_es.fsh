precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

const vec3 bloom_threshold = vec3(0.2126, 0.7152, 0.0722);

varying vec2 vs_tex_coord;

void main()
{
	vec4 color = texture2D(gm_BaseTexture, vs_tex_coord);
	float bloom = float(dot(color.rgb, bloom_threshold) >= 0.5);
	frag_color = vec4(color.rgb * bloom, 1.0);
}