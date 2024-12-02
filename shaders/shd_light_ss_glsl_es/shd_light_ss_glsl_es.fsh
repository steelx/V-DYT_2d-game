precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color0;
	out vec4 frag_color1;
	#define varying in
	#define texture2D texture
#else
	#define frag_color0 gl_FragData[0]
	#define frag_color1 gl_FragData[1]
#endif

#define M_PI   3.1415926535897932384626433832795
#define M_PI_2 1.5707963267948966192313216916398
#define M_2PI  6.283185307179586476925286766559
#define M_3PI  9.4247779607693797153879301498385

const vec3 dielectric      = vec3(0.4); 
const vec3 v_norm          = vec3(0.0, 0.0, 1.0);
const vec3 bloom_threshold = vec3(0.2126, 0.7152, 0.0722);

vec3 get_radiance(float c)
{	
	// UNPACK COLOR BITS
	vec3 col;
	col.b = floor(c * 0.0000152587890625);
	float blue_bits = c - col.b * 65536.0;
	col.g = floor(blue_bits * 0.00390625);
	col.r = floor(blue_bits - col.g * 256.0);
		
	// NORMALIZE 0-255
	return col * 0.00390625;
}

vec3 fresnel(float cos_theta, vec3 mat)
{
	return mat + (1.0 - mat) * pow(clamp(1.0 - cos_theta, 0.0, 1.0), 5.0);
}

float distribution(vec3 f_norm, vec3 h_norm, float roughness)
{
	roughness *= roughness;
	roughness *= roughness;
	float FdotH  = max(dot(f_norm, h_norm), 0.0);	
	float denom = (FdotH * FdotH * (roughness - 1.0) + 1.0);
	
	return roughness / (M_PI * denom * denom);
}

float reflection(float num, float roughness)
{
	float r = (roughness + 1.0);
	float k = (r*r) / 8.0;
	float denom = num * (1.0 - k) + k;
	
	return num / denom;
}

varying vec2 vs_tex_coord;
varying vec3 vs_world_pos;

uniform sampler2D u_normal;
uniform sampler2D u_material;
uniform sampler2D u_shadow_atlas;

uniform float u_lights[908];

void main()
{
	vec2 tex_coord = vs_tex_coord;
	vec3 world_pos = vs_world_pos;
	
	// FRAGMENT COLOR
	vec3 color = vec3(0.0);
	
	// SAMPLES AND MATERIALS
	vec4  source    = texture2D(gm_BaseTexture, tex_coord);
	vec4  material  = texture2D(u_material, tex_coord);
	vec4  normal    = texture2D(u_normal, tex_coord);
	
	vec3  albedo    = source.rgb;
	vec3  ao        = material.b * albedo;
	float metallic  = material.r;
	float roughness = material.g;	
	float emissive  = normal.a * 2.0;
	float bloom_limit = u_lights[10];
	float shadow_opacity = u_lights[11];
		
	// THINGS THAT ONLY NEED CALCULATED ONCE
	vec3  mat_ref = mix(dielectric, albedo, metallic);
	vec3  f_norm  = normalize(normal.rgb * 2.0 - 1.0);
	float FdotC   = max(dot(f_norm, v_norm), 0.0);
	float r_norm  = reflection(FdotC, roughness);
	FdotC *= 4.0;
	
	// AMBIENT LIGHTING PLUS EMISSIVE
	float ambient			= abs(u_lights[0]);
	float ambient_intensity = (ambient + emissive) * 2.0 * float(u_lights[0] >= 0.0);
	vec3 ambient_color      = get_radiance(u_lights[1]) * ambient + albedo * emissive;
	vec3 l_norm             = vec3(u_lights[2], u_lights[3], u_lights[4]); 
	vec3 h_norm             = normalize(v_norm + l_norm);
	float FdotL             = max(dot(f_norm, l_norm), 0.0);
	vec3 freq               = fresnel(max(dot(h_norm, v_norm), 0.0), mat_ref);
	vec3 numerator		    = distribution(f_norm, h_norm, roughness) * reflection(FdotL, roughness) * r_norm * freq;
	vec3 specular			= numerator / (FdotC * FdotL + 0.0000001);  
	vec3 refraction		    = vec3((1.0 - freq) * (1.0 - metallic));
	vec3 ambient_lighting   = ambient_color * ambient_intensity * FdotL * (refraction * albedo / M_PI + specular) + ao * min(ambient_intensity, 0.3); 
	
	// BLEND DETERMINES AREAS NEVER IN SHADOW
	float blend = source.a == 0.0 ? 1.0 : material.a; // source alpha is the background
	float blend_total = blend + ambient_intensity; 
	
	// ITERATE THROUGH LIGHTS
	int LI = 12; // start after the other params
	int count = int(u_lights[5]);
	
	// SHADOW ATLAS
	float atlas_rows = u_lights[6];
	float atlas_cols = u_lights[7];
	vec2 map_size = vec2(1.0/atlas_cols, 1.0/atlas_rows);
	float index = 0.0;
		
	int i = 0;
	while (i < count)
	{
		// SHADOWS PACKED INTO RGBA		
		vec2 atlas_uv = vec2(mod(index, atlas_cols) * map_size.x, floor(index/atlas_cols) * map_size.y) + map_size * tex_coord;
		vec4 shadow = texture2D(u_shadow_atlas, atlas_uv) * shadow_opacity;
		index++;
				
		int shadow_index = int(min(4.0, float(count - i)));
		i += shadow_index;
		for (int j = 0; j < shadow_index; j++)
		{			
			// LIGHT ATTRIBUTES
			vec3  light_pos   = vec3(u_lights[LI++], u_lights[LI++], u_lights[LI++]);
			float directional = u_lights[LI++]; // Sign of the color value used to flag directional lighting
			vec3  radiance    = get_radiance(abs(directional));
			directional = float(directional < 0.0);

			// UNPACK INTENSITY AND DEPTH
			float intensity = u_lights[LI++];
			float light_depth = floor(intensity);
			intensity = sin( (intensity - light_depth) * M_PI_2 );
			light_depth *= 0.001;
			float shadow_blend = 1.0 - shadow[j];
			
			float falloff   = u_lights[LI++];
			float angle     = u_lights[LI++];
			float arc       = u_lights[LI++];
	
			// UNPACK RADIUS AND ANGLE
			float radius = floor(angle);
			angle = (angle - radius) * 10.0;
		
			// UNPACK WIDTH AND ARC
			float width = floor(arc);
			arc = (arc - width) * 10.0;
	
			// LINE LIGHT
			if (width > 0.0)
			{
				vec2 line = vec2(width * sin(angle), width * cos(angle));
				width *= width;
				float t = clamp(line.x * (world_pos.x - light_pos.x) + line.y * (world_pos.y - light_pos.y), -width, width) / width;
				light_pos.x += t * line.x; 
				light_pos.y += t * line.y;
			}
	
			// NORMALIZE AFTER MOVING FOR LINE
			vec3 l_norm = normalize(light_pos + world_pos * directional - world_pos);
			vec3 h_norm = normalize(v_norm + l_norm);
			float FdotL = max(dot(f_norm, l_norm), 0.0);
			float fov   = 1.0;
		
			// FOV ARC
			if (arc <= M_PI)
			{
				float angle_diff = abs(mod(angle - atan(l_norm.y, -l_norm.x) + M_3PI, M_2PI) - M_PI);
				radius = radius / max(0.0000001, abs(cos(angle_diff)));
				fov = smoothstep(arc, 0.0, angle_diff);
			}

			// ATTENUATION
			float light_len = length(light_pos.xy - world_pos.xy);
			float focus = radius * falloff;
			float dist = light_len * (2.0 - intensity) / focus;
			float edge = sin((1.0 - smoothstep(focus, radius + 1.0, light_len)) * M_PI_2);
			float attenuation = max(intensity * directional, (1.0 - directional) * (2.0 * intensity) / (dist * dist + 1.0 - intensity) * edge * fov);

			// SHADOW AND BLEND
			attenuation *= float(light_depth >= blend) * shadow_blend; // compare with light depth
			blend_total += attenuation * max(shadow_blend, blend);
			
			// PBR LIGHTING
			vec3 freq       = fresnel(max(dot(h_norm, v_norm), 0.0), mat_ref);
			vec3 numerator  = distribution(f_norm, h_norm, roughness) * reflection(FdotL, roughness) * r_norm * freq;
			vec3 specular   = numerator / (FdotC * FdotL + 0.00000001);  
			vec3 refraction = vec3((1.0 - freq) * (1.0 - metallic));
		
			// ADD TO FINAL COLOR
			color += radiance * (attenuation * FdotL * (refraction * albedo / M_PI + specular) + ao * min(attenuation, 0.3)); 
		}
	}
		
	// DEPTH OF FIELD
	float dof_near = u_lights[8];
	float dof_far  = u_lights[9];
	float dof_constant = 0.4; // change this
	float dof = min(1.0, min(blend / dof_far, (1.0 - blend) / (1.0 - dof_near)));
	dof *= (1.0 - float(dof < 1.0) * dof_constant);
	dof = dof * dof;
	
	// ADD AREAS TO BLOOM AND BLUR
	color = (color + ambient_lighting) * (1.0 + emissive);
	blend_total = min(blend_total, 1.0);
	float bloom = smoothstep(bloom_limit, 1.0, dot(color.rgb, bloom_threshold));
	
	frag_color0 = vec4(color * dof, ceil(source.a)); // alpha is 0 or 1 to flip with background
	frag_color1 = vec4(color * max(bloom, 1.0 - dof), material.a); // bloom surface
}