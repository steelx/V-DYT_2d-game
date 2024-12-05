if (surface_exists(surface_lights))
{
	if (!buffer_exists(buffer_lights))
		buffer_lights = buffer_create(surface_width * surface_height * 4, buffer_fixed, 1);
		
	buffer_get_surface(buffer_lights, surface_lights, 0);
}

alarm[10] = enable_lighting_buffer;