precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

/* Keep this generic blur sampling here for reference
vec4 blur_horizontal(vec2 uv, vec2 texel)
{
	vec4 s0 = texture2D(gm_BaseTexture, uv) * 0.227027;
	vec4 s1 = texture2D(gm_BaseTexture, vec2(uv.x + texel.x, uv.y)) * 0.1945946;
    vec4 s2 = texture2D(gm_BaseTexture, vec2(uv.x - texel.x, uv.y)) * 0.1945946;
	vec4 s3 = texture2D(gm_BaseTexture, vec2(uv.x + texel.x * 2.0, uv.y)) * 0.1216216;
	vec4 s4 = texture2D(gm_BaseTexture, vec2(uv.x - texel.x * 2.0, uv.y)) * 0.1216216;	
    vec4 s5 = texture2D(gm_BaseTexture, vec2(uv.x + texel.x * 3.0, uv.y)) * 0.054054;
    vec4 s6 = texture2D(gm_BaseTexture, vec2(uv.x - texel.x * 3.0, uv.y)) * 0.054054;	
    vec4 s7 = texture2D(gm_BaseTexture, vec2(uv.x + texel.x * 4.0, uv.y)) * 0.016216;
    vec4 s8 = texture2D(gm_BaseTexture, vec2(uv.x - texel.x * 4.0, uv.y)) * 0.016216;	
	return s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8;	
}
*/

vec4 shadow_blend(vec4 source, vec2 source_depth, vec4 sample, vec2 sample_depth, float c)
{
	float depth_compare = float(source_depth.x == sample_depth.x); // Only blur shadow of same depth
	float occlude = float(source_depth.x < sample_depth.x && sample_depth.y == 1.0); // If lower than sample and sample can occlude
	
	// Blend with sample if equal depth
	// Else blend with self if not occluded
	// Else blend with 1.0 because occluded
	vec4 shadow = vec4(sample * depth_compare + (source * (1.0 - occlude) + occlude) * (1.0 - depth_compare));
	return shadow * c;
}

vec4 shadow_blur(vec2 uv, vec2 size, vec2 atlas, vec2 map_size, sampler2D sample_depth)
{
	vec4 source = texture2D(gm_BaseTexture, uv);
	vec2 depth = texture2D(sample_depth, mod(uv, map_size) * atlas).xy;
	
	vec2 uv_min = uv - mod(uv, map_size);
	vec2 uv_max = uv_min + map_size;
	
	// Clamp sample UVs to the current shadow map within the atlas
	vec2 uv0 = clamp(vec2(uv.x + size.x, uv.y), uv_min, uv_max);
	vec2 uv1 = clamp(vec2(uv.x - size.x, uv.y), uv_min, uv_max);
	vec2 uv2 = clamp(vec2(uv.x + size.x * 2.0, uv.y), uv_min, uv_max);
	vec2 uv3 = clamp(vec2(uv.x - size.x * 2.0, uv.y), uv_min, uv_max);
	vec2 uv4 = clamp(vec2(uv.x + size.x * 3.0, uv.y), uv_min, uv_max);
	vec2 uv5 = clamp(vec2(uv.x - size.x * 3.0, uv.y), uv_min, uv_max);
	vec2 uv6 = clamp(vec2(uv.x + size.x * 4.0, uv.y), uv_min, uv_max);
	vec2 uv7 = clamp(vec2(uv.x - size.x * 4.0, uv.y), uv_min, uv_max);
	
	vec4 blend = vec4(source * 0.227027);
	// Depth texture UV needs to be transformed from the map UV space to regular UV space
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv0), texture2D(sample_depth, mod(uv0, map_size) * atlas).xy, 0.1945946);
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv1), texture2D(sample_depth, mod(uv1, map_size) * atlas).xy, 0.1945946);
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv2), texture2D(sample_depth, mod(uv2, map_size) * atlas).xy, 0.1216216);
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv3), texture2D(sample_depth, mod(uv3, map_size) * atlas).xy, 0.1216216);	
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv4), texture2D(sample_depth, mod(uv4, map_size) * atlas).xy, 0.054054);
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv5), texture2D(sample_depth, mod(uv5, map_size) * atlas).xy, 0.054054);	
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv6), texture2D(sample_depth, mod(uv6, map_size) * atlas).xy, 0.016216);
	blend += shadow_blend(source, depth, texture2D(gm_BaseTexture, uv7), texture2D(sample_depth, mod(uv7, map_size) * atlas).xy, 0.016216);
	
	return blend;
}

varying vec2 tex_coord;

uniform float u_params[6];
uniform sampler2D s_depth;

void main()
{	
	frag_color = shadow_blur(tex_coord, vec2(u_params[0], u_params[1]), vec2(u_params[2], u_params[3]), vec2(u_params[4], u_params[5]), s_depth);
}