precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec3 params;
varying vec4 view;
varying vec4 color;

void main()
{	
	vec4 outColor = color;
	vec2 uv = vec2((gl_FragCoord.x - view.x) / (view.y - view.x), (gl_FragCoord.y - view.z) / (view.w - view.z)); // Inverse lerp
	float depth = texture2D(gm_BaseTexture, uv).a;
		
	// Within current frustrum
	float in_view = float(gl_FragCoord.x >= view.x && gl_FragCoord.x < view.y && gl_FragCoord.y >= view.z && gl_FragCoord.y < view.w);
	
	// Light and shadow depth compared to material depth
	float shadow = float(depth + 0.1 < params.x);
			
	// Set the color channel for this light
	float value = (1.0 - smoothstep(params.z, 1.0, params.y)) * min(in_view, shadow);

	frag_color = vec4(outColor) * value;
}