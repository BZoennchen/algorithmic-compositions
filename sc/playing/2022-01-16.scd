(
SynthDef(\blip, {
	var sig, env;

	sig = SinOsc.ar([\freq.kr(440), \freq.kr(440)*1.1]);
	env = Env.sine(0.01).ar(doneAction: Done.freeSelf);
	sig = LPF.ar(sig, \cutoff.kr(800));
	sig = sig * env * \amp.kr(0.5);
	Out.ar(0, sig);
}).add;
)

Synth(\beep, [freq: 440]);

{Env.sine(1.0).ar;}.plot(1.0);

(
Pbindef(\ramp,
	\instrument, \blip,
	\dur, 1/32,
	\freq, Pgeom(50, 1.1, 55),
	\cutoff, 5000,
	\amp, Pgeom(1.0, 96/99, inf)
).play;
)

10000.linexp(50000, 0, 0.2, 1.0)

Array.series(100, 1.0, -0.01) 