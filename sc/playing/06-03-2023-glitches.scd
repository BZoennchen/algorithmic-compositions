s.boot;
(
SynthDef(\glitch,{
	var sig, trig;
	trig = Dust.ar(4);
	sig = SinOsc.ar(TExpRand.ar(100, 4000, trig)) * TRand.ar(0, 8000, trig).lag(0.3);
	sig = SinOsc.ar(TExpRand.ar(100, 4000, trig) + sig);
	sig = sig ! 2;
	sig = sig * (-20).dbamp;
	Out.ar(\out.kr(0), sig);
}).play;
)