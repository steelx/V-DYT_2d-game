event_inherited();

dayminutes = 0;
daytime = e_daytime.am;

hour_length = day_length / 24;
min_length  = hour_length / 60;

// The sun rises and set at specific time windows which 
// allows a more "gamified" configuration if needed.
sun_rise_begin *= hour_length;
sun_rise_end   *= hour_length;
sun_set_begin  *= hour_length;
sun_set_end    *= hour_length;

day_radius = radius;

var _cos = dcos(image_angle),
	_sin = -dsin(image_angle);
	
end_x   = x + _cos * orbit_distance;
end_y   = y + _sin * orbit_distance;
start_x = x - _cos * orbit_distance;
start_y = y - _sin * orbit_distance;

image_blend = day_color;

#macro MINS_DAY     1440
#macro MINS_HALFDAY 720

enum e_daytime 
{
	am,
	pm
}

function toggle()
{
	active = !active;	
}

function set_day_speed(_speed)
{
	// Fast forward or rewind
	day_speed = _speed;	
}

function get_time_string()
{
	var _dt = daytime == e_daytime.am ? " AM" : " PM",
		_t  = dayminutes mod MINS_HALFDAY,
		_h  = _t div 60,
		_m  = _t mod 60;
		
	if (_h == 0) _h = 12;
		
	return string_format(_h, 2, 0)+":"+string_replace(string_format(_m, 2, 0), " ", "0")+_dt;
}

function set_time(_hour, _min)
{
	// 24 hour clock, 60 mins per.  I.e., (13, 30) = 1:30 PM
	tick = (_hour * hour_length + _min * min_length) mod day_length;
}

function set_sunrise(_hour, _transition)
{
	// 24 hour clock, decimal for minutes.  I.e., 5.5 = 5:30 AM
	// _transition is how long it takes for sun to fully rise
	sun_rise_begin = _hour * hour_length;
	sun_rise_end = sun_rise_begin + _transition * hour_length;
}

function set_sunset(_hour, _transition)
{
	// 24 hour clock, decimal for minutes.  I.e., 17.5 = 5:30 PM
	// _transition is how long it takes for sun to fully set
	sun_set_begin = _hour * hour_length;
	sun_set_end = sun_set_begin + _transition * hour_length;
}