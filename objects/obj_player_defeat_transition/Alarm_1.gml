// Reduce the cell size by 2
// This event runs when the second room has started, so the pixelation is decreased
cell_size -= 2;

// Apply the new cell size to the filter
fx_set_parameter(transition_filter, "g_CellSize", cell_size);

// If the cell size is at or below 2,
if (cell_size <= 2)
{
	// Destroy this instance
	instance_destroy();

	// Destroy the filter layer
	layer_destroy(transition_layer);
}
// Otherwise,
else
{
	// Run Alarm 1 again in the next frame
	alarm[1] = 1;
}