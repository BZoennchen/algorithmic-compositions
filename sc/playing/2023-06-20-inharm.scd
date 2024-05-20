s.boot;

(
SynthDef(\inharm, {
	var freqs, sig, env, amps, envs;
	freqs = [0.88, 0.92, 1.2, 1.8, 2.23] *.x [1.0, 1.2, 0.91];
	freqs = freqs.sort * \freq.kr(100);
	amps = {rand(0.3, 1.0)}!freqs.size;
	amps = amps.normalizeSum;
	amps = amps.sort;

	sig = SinOsc.ar(freqs);

	envs = freqs.collect {
		arg element, index;
		var env = EnvGen.ar(Env(
			[0, 1.0, 0.3, 0],
			[ExpRand(0.01, 0.03), Rand(0.3, 1.15), ExpRand(0.2, 0.34)],
			[Rand(3, 0.4), Rand(-1, 1), Rand(-3, -0.4)]
		));
		env**(index*\envp.kr(1.3)+1);
	};

	sig = sig * amps * envs;
	sig = Splay.ar(sig);
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(0, sig);
}).add;
)

{LFSaw.ar(300!2, 0) + LFSaw.ar(300!2, 1) * 0.25}.play;

{LFSaw.ar(300!2, 0) * 0.5}.play;

(
Pbindef(\melody,
	\instrument, \inharm,
	\dur, Pseq(0.25!6 ++ [Rest(2.0)], inf),
	\scale, Scale.minor,
	\root, 2,
	\octave, 5,
	\degree, Pseq([0, 3, 5, 3, 4, 0, \], inf)
).play;
)


Synth(\inharm, [freq: 100]);