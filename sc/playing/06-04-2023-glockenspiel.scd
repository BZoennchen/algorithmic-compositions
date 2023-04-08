s.boot;
(
SynthDef(\glockenspiel, {
	var sig, env, env2, fundamental, partials;

	env = EnvGen.ar(Env(
		levels: [0, 1, 0.4, 0],
		times: [\atk.kr(0.01), \dec.kr(0.5), \rel.kr(1.5)],
		curve: -4), doneAction: Done.freeSelf);
	env2 = EnvGen.ar(Env(
		levels: [0, 0.25, 0.125, 0],
		times: [\atk.kr(0.01), \dec.kr(0.5)*0.25, \rel.kr(1.5)*0.4],
		curve: -6));

	fundamental = SinOsc.ar(\freq.kr(440)!4);
	partials = LFTri.ar(([12, 24]).midiratio * \freq.kr(440));
	sig = fundamental * env;
	sig = sig + (partials * env2);
	sig = sig * 0.2 * \amp.kr(1.0);
	sig = Splay.ar(sig);
	Out.ar(\out.kr(0), sig);
}).add;
)

(

~base = Pbind(
			\instrument, \glockenspiel,
			\scale, Scale.major,
			\degree, Pseq([0, 4, 7, 5], 1),
			\dur, 0.25,
			\octave, 5,
			\rel, 1.0,
			\amp, 1.0,
);

~mel1 = Pbind(
			\instrument, \glockenspiel,
			\scale, Scale.major,
			\degree, Pseq([0, 4, 7, 5]+4, 1),
			\dur, 1,
			\octave, 6,
			\rel, 1.0,
			\amp, 1-Pgeom(1, 0.8, inf),
);

~mel2 = Pbind(
			\instrument, \glockenspiel,
			\scale, Scale.major,
			\degree, Pseq([0,3,6], 1),
			\dur, 2,
			\octave, 6,
			\rel, 1.0,
			\amp, 1.0
);

Pdef(\melody,
	Pseq([
		Pn(~base, 2),
		Ppar([Pn(~base, 6), ~mel2], 3),
		Ppar([Pn(~base, 12), Pn(~mel2, 2), Pn(~mel1, 3)])], 2)
).play;
)

