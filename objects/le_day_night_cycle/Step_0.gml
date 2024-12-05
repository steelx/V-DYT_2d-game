if (!active) exit;

tick = range_wrap(tick, MICRO_SEC * delta_time * day_speed, day_length);
var _pos = tick/day_length;
tick_pos = _pos;

dayminutes = lerp(0, MINS_DAY, _pos);
daytime    = dayminutes div 721;

var _t = _pos * LE_2PI;
var _orbit = sin(_t) * 0.5 + 0.5;
x = lerp(start_x, end_x, _orbit);
y = lerp(start_y, end_y, _orbit);

if (daytime == e_daytime.am)
{
	var _rise = smooth_step(sun_rise_begin, sun_rise_end, tick);
	set_intensity(_rise * max_sunlight);
	set_radius(day_radius * _rise);
}
else
{
	var _set = smooth_step(sun_set_end, sun_set_begin, tick);
	set_intensity(_set * max_sunlight);
	set_radius(day_radius * _set);
}