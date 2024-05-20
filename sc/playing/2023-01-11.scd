s.boot;
(
SynthDef(\pad, {
	var sig, env, n = 16;
	sig = Saw.ar(\freq.kr(100) * ({LFNoise2.ar(8)}!n * \detune.kr(0.1)).midiratio);
	sig = Decay.ar(sig, 0.1, {Rand(0.09, 0.01)}!sig.size);
	env = EnvGen.ar(Env.asr(
		\atk.kr(3),
		0.8,
		\rel.kr(3),
		[2, -2]), gate: \gate.kr(1));
	sig = sig * env * SinOsc.ar(10).range(0.8, 1.0);
	sig = sig / n * \amp.kr(2.0);
	sig = Splay.ar(sig);
	sig = BLowShelf.ar(sig, 100, 1.0, -10);
	sig = FreeVerb.ar(sig, 0.5, 1.0, 0.5);
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(\out.kr(0), sig);
}).add;
)

(
Tdef(\t_pad, {
	loop {
		var synth = Synth(\pad, [\freq, ([1,2,3] *.t ([100] + [2,4,6,8])).choose, \detune, 0.3 ]);
		10.0.wait;
		synth.set(\gate, 0);
		4.0.wait;
	};
}).play;
)

([1,2,3] *.t ([100] + [2,4,6,8]))

-10.dpamp