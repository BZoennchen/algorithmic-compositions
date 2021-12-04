
(
var trifunc = {
	arg t;
	var freq = 1, amp;
	amp = (freq*t - floor(1/2 + (freq*t)));
};

var t = Array.interpolation(100, 0, 1);
var y = t.collect({arg t; trifunc.value(t);});

y.plot();
)

(
var trifunc = {
	arg t;
	var freq = 1, amp;
	amp = (freq*t - floor(1/2 + (freq*t)));
};

trifunc.plot(1);
)

{Pulse.ar(220!2) * 0.25;}.play;


{LFTri.ar(220!2) * 0.25;}.play;