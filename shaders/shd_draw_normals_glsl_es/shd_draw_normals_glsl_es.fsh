precision highp float;

#define EM_BIT 0.0039215686274509803921568627451

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

const vec4 no_normal = vec4(0.5, 0.5, 1.0, 1.0);

varying vec4 coords;
varying float has_map;
varying float has_emissive;

void main()
{
    vec4 normal = texture2D(gm_BaseTexture, coords.xy);
	if (normal.a == 0.0) discard;
	
	float em_value = (normal.a - EM_BIT) * has_emissive;
	normal = normal * has_map + no_normal * (1.0 - has_map);
	
	vec2 f_norm = vec2(normal.xy * 2.0 - 1.0);
	float tcos = coords.z;
	float tsin = coords.w;
	
	normal.x = (f_norm.x * tcos - f_norm.y * tsin) * 0.5 + 0.5;
	normal.y = (f_norm.x * tsin + f_norm.y * tcos) * 0.5 + 0.5;
	
	frag_color = vec4(normal.rgb, em_value);
}