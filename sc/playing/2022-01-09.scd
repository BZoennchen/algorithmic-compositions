(
SynthDef(\sine, {
	arg freq = 440, amp = 0.2, gate = 1,
	atk=0.002, rel = 1, acrv=1, rcrv = -4, pan = 0, out = 0;
	var sig, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel, [acrv, rcrv]), gate, doneAction: Done.freeSelf);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;

SynthDef(\reverb, {
	arg in = 0, mix = 0.08, out = 0;
	var sig, wet;

	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix: mix, room: 0.999, damp: 0.85);
	Out.ar(out, sig);
}).add;

s.newBusAllocators;
~bus = Bus.audio(s, 2);
)

~reverb = Synth(\reverb, [\in, ~bus, \out, 0]);

(
(
instrument: \sine,
out: ~bus,
sustain: 0.01,
rel: 0.2,
midinote: rrand(40, 90)
).play;
)

2.midiratio
2.pow(2.0/12)

(Pbind(\instrument, \saw,
	\dur, Pgeom(0.03, 1.02, inf),
	\rel, 0.001,
	\db, Pseries(-6, -0.2, inf),
	\scale, Scale.major,
	\degree, Pseq((0..7), inf),
	\octave, 5
).play);


s.boot;

(
SynthDef(\beep, {
	arg freq = 600, amp = 0.2, atk = 0.01, gate = 1, rel = 0.1;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(attackTime: atk, sustainLevel: 1.0, releaseTime: rel, curve: [1, -4]),
		gate: gate);
	sig = SinOsc.ar(freq!2) * env * amp;
	sig = FreeVerb.ar(sig, mix: 0.5, room: 0.4);
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(0, sig);
}).add;

SynthDef(\drum, {
	arg amp = 0.5, atk = 0.01, rel = 0.5, curve = -4, level = 1.0, cutoff = 6000, rq = 0.1;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk, rel, level, curve), doneAction: Done.freeSelf);
	sig = LPF.ar(WhiteNoise.ar(amp!2), freq: cutoff) * env;
	Out.ar(0, sig);
}).add;

SynthDef(\beat, {
	arg atk = 0.1;
	var sig, env, env_cutoff;
	env = EnvGen.kr(Env([0,1,0], [atk,1], [-5, 5]), doneAction: Done.freeSelf);
	env_cutoff = EnvGen.ar(Env.perc(atk, 2.0));
	sig = LPF.ar(LFSaw.ar(100), 40 + 100 * env_cutoff) * env * 0.5;
	Out.ar(0, sig!2);
}).add;
)

({
	var sig = RLPF.ar(LFSaw.ar(SinOsc.ar(1).range(300, 1000)), SinOsc.ar(10).range(100,300), SinOsc.ar(0.5).range(0.1, 1.0)) * EnvGen.ar(Env.perc(0.05, 0.3)) * 1.25!2;
	sig = FreeVerb2.ar(sig[0], sig[1], 0.5, 1.0, 0.5);
}.play;)

Synth(\drum);
Synth(\beat);
Synth(\beep);

(
p = Pbind(
	\instrument, \beep,
	\scale, Scale.minor,
	\degree, Prand((0..6), inf),
	\detune, Pwhite(5, 20, inf),
	\atk, 0.01,
	\rel, 0.1,
	\sustain, 0.01,
	\amp, Pseq([
		0.55, \, 0.6, \,
		0.6, 0.7, \, 0.8
	], inf),
	\dur, 1/8
);
q = p.play;
)
q.stop;
Scale.minor


