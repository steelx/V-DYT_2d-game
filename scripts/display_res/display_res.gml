/// @desc Returns array of recommended display resolutions as [width,height] pairs, sorted from highest to lowest
function get_user_resolutions() {
    var resolutions = [];
    var display_width = display_get_width();
    var display_height = display_get_height();
    
    // Common 16:9 resolutions
    if (display_width >= 3840 && display_height >= 2160) array_push(resolutions, [3840, 2160]); // 4K
    if (display_width >= 2560 && display_height >= 1440) array_push(resolutions, [2560, 1440]); // 2K
    if (display_width >= 1920 && display_height >= 1080) array_push(resolutions, [1920, 1080]); // FHD
    if (display_width >= 1600 && display_height >= 900) array_push(resolutions, [1600, 900]);
    if (display_width >= 1366 && display_height >= 768) array_push(resolutions, [1366, 768]);
    if (display_width >= 1280 && display_height >= 720) array_push(resolutions, [1280, 720]); // HD
    
    return resolutions;
}
