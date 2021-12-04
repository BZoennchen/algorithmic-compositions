Utils.initTools

({
	var mod = SinOsc.ar(110, mul: 0.5, add: 0.5);
	var car = mod * SinOsc.ar(440);
	car;
}.play;
)

({
	var mod = SinOsc.ar(110) * 0.5;
	var car = mod * SinOsc.ar(440);
	car;
}.play;
)

{SinOsc.ar(110, mul: 0.5, add: 0.5)}.plot(2/110)

({
	var mod = LFSaw.ar(LFNoise1.ar(1).range(10, 15));
	var car = mod * LFSaw.ar(200);
	car = LPF.ar(car, 500);
	car = car * 0.25;
	LeakDC.ar(car!2);
}.play;
)