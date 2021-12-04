s.boot;
Utils.initTools

// TODO: introduce reverb!
(
SynthDef(\sine_sum, {
	var sig, n=15, cf;
	var detuneFreq = 200;
	var detune = 0.25;
	sig = 0;
	cf = \freq.kr(220) * (1+0.8.pow(\freq.kr(220)/100));

	n.do({
		arg index;
		var k, env, envF, noise, vibrato, harmonicFreq, harmonic, saw;
		k = index+1;

		envF = 1.01.pow(k * (-1));
		env = EnvGen.ar(Env(
			levels: [0,1,1,0],
			times: [\attk.kr(5.01) * Rand(0.8,1.2), \sus.kr(0), \rel.kr(5.0) * Rand(0.9,1.1) * envF ],
			curve: [3, 0, -2]
		));
		env = env.pow(1 + ( (k-1) / 3 ) );


		vibrato = LFNoise2.kr(Rand(0.08, 0.11)).bipolar(detune).midiratio;
		harmonicFreq = \freq.kr(220) * vibrato * k;
		harmonic = ((1/2) - ((1/pi) * ((-1).pow(k) * SinOsc.ar(harmonicFreq) / k)));
		harmonic = Pan2.ar(harmonic, Rand(-0.9, 0.9));
		2.do({
			harmonic = harmonic * LFNoise2.kr({Rand(0.2, 0.3)}).range(2,3).dbamp;
			harmonic = harmonic.softclip;
		});

		saw = VarSaw.ar(harmonicFreq, Rand(0.0, 1.0), Rand(0.0, 0.1));
		saw = Pan2.ar(saw, Rand(-0.9, 0.9));
		2.do({
			saw = saw * LFNoise2.kr(Rand(0.2, 0.3)).range(10,15).dbamp;
			saw = saw.tanh;
		});

		noise = PinkNoise.ar(1);
		noise = BPF.ar(noise, \freq.kr(220) * k, 0.02, 1/0.02.sqrt);
		noise = Pan2.ar(noise, Rand(-0.9, 0.9));

		sig = sig + ((harmonic + saw + noise) * env);
	});

	sig = RLPF.ar(in: sig, freq: cf, rq: 0.8);
	sig = sig * \amp.kr(0.5) * 0.12;
	sig = [Pan2.ar(sig[0], LFNoise1.kr(0.2).range(-1, 1)), Pan2.ar(sig[1], LFNoise1.kr(0.2).range(-1, 1))];
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(0, sig);
}).add;
)
Synth(\sine_sum);

(1+0.8.pow(100/100))

13.dbamp
{var sig = VarSaw.ar(220, 0.5, 0.1) * (13.dbamp); sig = sig.tanh; sig;}.play
{LFSaw.ar(220)}.plot(2/220)
({
	var sig =
	sig = BPF.ar(sig, 220, 0.02, 1/0.02.sqrt);
	sig
}.play;)

({
	EnvGen.ar(Env(
			levels: [0,1,1,0],
			times: [1, 0, 5],
			curve: [2, 0, -2]
		))
}.plot(7))

(1.1.pow(10 * (-1)))
(0.5.pow(1 + ((20-1)/10)))

3.1.asInteger
({
	var sig = SinOsc.ar(200);
	2.do({
		sig = sig * LFNoise2.kr({Rand(0.2, 0.3)}!2).range(4,8).dbamp;
		sig = sig.softclip;
	});
	sig;
}.plot(2/200);)


0.015.midiratio

{Rand(0.08, 0.11)}!6

{SinOsc.ar(200).tanh;}.play;

0.9.pow(1+((4-1)/3))

(
Pbindef(\melody,
	\instrument, \sine_sum,
	\scale, Scale.major,
	\degree, Pshuf([0, [2, 5], [6, 8], 11, [12, 14]], inf),
	\octave, Pstutter(3, Pseq([3,4,5], inf)),
	\dur, Pwhite(6, 8, inf),
	\attk, Pexprand(5, 8, inf),
	\rel, Pexprand(3, 5, inf),
	\amp, Pwhite(0.3, 0.4, inf)
).play;
)

(
Pbindef(\bass,
	\instrument, \sine_sum,
	\scale, Scale.minor,
	\degree, Prand(Scale.minor.degrees, inf),
	\octave, Pstutter(3, Pseq([3,2], inf)),
	\dur, Pwhite(6, 8, inf),
	\attk, Pexprand(5, 8, inf),
	\sus, 1,
	\rel, Pexprand(3, 5, inf),
	\amp, Pwhite(0.2, 0.3, inf)
).play;
)
thisProcess.platform.recordingsDir

Scale.minor.degrees

Pbindef(\melody).clear;
(
Pbindef(\melody,
	\instrument, \sine_sum,
	\scale, Scale.minor,
	\degree, Pseq([[0,5], [3, 7], 9, 9, [1, 8]], inf),
	\octave, Pstutter(3, Pseq([3,4,5], inf)),
	\dur, Pseq([1/2, 1/2, 1/2, 1/2, 1/2], inf),
	\attk, Pexprand(0.001, 0.01, inf),
	\sus, 0.0,
	\rel, Pexprand(0.1, 0.2, inf),
	\amp, Pwhite(0.2, 0.3, inf)
).play;
)

2.pow((-4..1))

Scale.chromatic.degrees


