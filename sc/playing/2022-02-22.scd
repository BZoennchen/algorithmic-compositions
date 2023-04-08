(
SynthDef(\drum_doll, {
	var sig, env, bass;
	env = EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: 0.5, curve: -8), doneAction: Done.freeSelf);
	bass = SinOsc.ar([80, 81]) * 1.0;
	sig = LPF.ar(PinkNoise.ar(\amp.kr(1.0))!2, XLine.ar(6000, 100, 0.01));
	//sig = HPF.ar(sig, 100);
	sig = sig + bass;
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

(
SynthDef(\bubble, {
	var sig, env;
	env = EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: 0.1, curve: -8), doneAction: Done.freeSelf);
	sig = PinkNoise.ar()!2 * env;
	sig = RHPF.ar(sig, XLine.ar(\cutoff_low.ir(600), \cutoff_high.ir(2500), 0.01), 0.05);
	sig = LPF.ar(sig, 600) * \amp.kr(1.0);
	Out.ar(0, sig);
}).add;
)

Synth(\bubble);



({
	var sig, env;
	env = EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: 0.1, curve: -8), doneAction: Done.freeSelf);
	sig = PinkNoise.ar(\amp.kr(0.55))!2 * env;
	sig = RHPF.ar(sig, XLine.ar(\cutoff.ir(400), 6500, 0.01), 0.05);
	sig = LPF.ar(sig, 600);
	sig;
}.play;)


(
SynthDef(\drum_white, {
	var sig, env;
	env = EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: 0.5, curve: -8), doneAction: Done.freeSelf);
	sig = WhiteNoise.ar(\amp.kr(0.25))!2 * env;
	Out.ar(0, sig);
}).add;
)

(
SynthDef(\stick, {
	var sig, env;

	sig = PinkNoise.ar(\amp.kr(0.55))!2 * env;
	sig = RLPF.ar(sig, \cutoff.ir(1500), 0.51);
	Out.ar(0, sig);
}).add;
)


(
SynthDef(\bell, {
	var sig, env;
	env = EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: Rand(0.15, 0.25), curve: -8), doneAction: Done.freeSelf);

	sig = 0;
	10.do{
		sig = sig + SinOsc.ar(Rand(200, 800)!2) * 20.reciprocal;
	};
	sig = sig * env * 0.25;
	Out.ar(0, sig);
}).add;
)

Synth(\bell);
Synth(\drum_pink);
Synth(\drum_white);
Synth(\stick, [\cutoff: 1000 + 1000.rand()]);
s.record
(
p = Pbind(
	\instrument, \bubble,
	\dur, Pwhite(0.02, 0.4),
	\cutoff_low, Pwhite(300, 900),
	\cutoff_low, Pwhite(1000, 5000),
	\amp, 1.0
)
)
p.play;
p.stop;
s.stopRecording

(
10.do{
	5.postln;
}
)
