// Increase the cell size by 1
// This event runs when the first room is ending, so the pixelation is increased
cell_size += 1;

// Apply the new cell size to the filter
fx_set_parameter(transition_filter, "g_CellSize", cell_size);

// Run Alarm 0 again in the next frame
alarm[0] = 1;