(
SynthDef(\sinesum, {
    var sig, harmonics, amps, phases;

    harmonics = [1, 3, 5, 6, 7, 8, 9];
    phases = [0, 0, 0, 0.5, 0.25, 0, 0] * 2*pi;
    amps = [0.5, 0.1, 0.2, 0.6, 0.6, 0.1, 0.1].normalizeSum();

    sig = harmonics.collect({ arg k, index;
        var env = EnvGen.ar(Env.perc(
            attackTime: \attk.kr(0.01) * Rand(0.8,1.2),
            releaseTime: \rel.kr(5.0) * Rand(0.9,1.1),
            curve: \curve.kr(-4)),
        timeScale: \sustain.kr(1) / \speed.kr(1.0),
        );

        var vibrato = 1 + LFNoise1.ar(\detuneFreq.kr(5)!2).bipolar(\detune.kr(0.015));
        var harmonicFreq = \freq.kr(440) * \speed.kr(1.0) * vibrato * abs(k);
        amps[index] * SinOsc.ar(harmonicFreq, phases[index]) / k * env.pow(1+((abs(k)-1)/3));
    }).sum;

    sig = LPF.ar(sig, 1500);
    sig = sig * \amp.kr(0.5);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    OffsetOut.ar(\out.kr(0), DirtPan.ar(sig, ~dirt.numChannels, \pan.kr(0)));
}).add;
)


(
SynthDef(\supergong, {
	// lowest modes for clamped circular plate
	var freqlist = [
		1.000,  2.081,  3.414,  3.893,  4.995,
		5.954,  6.819,  8.280,  8.722,  8.882,
		10.868, 11.180, 11.754, 13.710, 13.715
	];

	var tscale = 100.0 / \freq.kr(440) / (freqlist**(2-clip(\decay.kr(1), 0, 2)));
	var ascale = freqlist**clip(\voice.kr(0),0,4);
	var sound = Mix.arFill(15, {arg i;
		var env = EnvGen.ar(
			Env.perc(
				attackTime: 0.01*tscale[i],
				releaseTime: 0.5*tscale[i],
				level: 0.2*ascale[i]),
			timeScale: \sustain.kr(1)*5);

		var sig = SinOsc.ar(\freq.kr(440) * freqlist[i]);
		env * sig
	});
	Out.ar(\out.kr(0), Pan2.ar(sound, \pan.kr(0)));
}).add
);

(
SynthDef(\superkick, {
	var env, sound, dur, clickdur, envFilter;
	env = EnvGen.ar(
		Env.linen(
			attackTime: 0.01,
			sustainTime: 0,
			releaseTime: 0.5,
			level: 1,
			curve: -3),
		timeScale: \sustain.kr(1), doneAction:2);

	sound = SinOsc.ar((\n.kr(60) - 25.5).midicps);
	clickdur = 0.02 * \sustain.kr(1) * \decay.kr(1);
	envFilter = Line.ar(start: 1, end: 0, dur: clickdur);
	sound = sound + (LPF.ar(
		in: WhiteNoise.ar(1),
		freq: 1500*\pitch1.kr(1)) * envFilter);

	Out.ar(\out.kr(0), Pan2.ar(sound, \pan.kr(0), env));
}).add
);


(
Pbind(
	\instrument, \superkick,
	\n, Pshuf(Array.series(80, 40, 0.5)),
	\dur, 0.125,
	\sustain, 0.25,
	\pitch1, Pwhite(0.5, 3.0, inf),
	\decay, Pwhite(0.5, 1.5, inf),
).play
)

// A vaguely 808-ish kick drum
// "n" controls the chirp frequency, "sustain" the overall timescale, "rate" the filter sweep speed,
// and "voice" the sinewave feedback
(
SynthDef(\super808, {
    var env, sound, freq, mod;
    env = EnvGen.ar(Env.linen(
        attackTime: 0.01,
        sustainTime: 0,
        releaseTime: 1,
        level: 0.3,
        curve: -3),
    timeScale: \sustain.kr(1), doneAction: 2);
    env = env * \amp.kr(1.0);

    mod = XLine.ar(
		start: \freq.kr(440).expexp(10, 2000, 1000, 8000),
		end: \freq.kr(440),
		dur: 0.025/\rate.kr(1));
    sound = LPF.ar(in: SinOscFB.ar(freq: mod, feedback: \voice.kr(0)), freq: 9000);
    Out.ar(\out.kr(0), Pan2.ar(sound, \pan.kr(0), env));
}).add
);

(
Pbind(
	\instrument, \super808,
	\freq, Pshuf(Array.series(80, 40, 1)).midicps,
	\dur, 0.125,
	\sustain, 0.25,
	\voice, Pwhite(0.0, 1.0, inf),
	\amp, 0.5
).play
)

// Hi-hat using Rumble-San's implementation as a starting point
// http://blog.rumblesan.com/post/53271713518/drum-sounds-in-supercollider-part-1
// using "n" in a weird way to provide some variation on the frequency
// "sustain" affects the overall envelope rate, "accelerate" sweeps the filter
(
SynthDef(\superhat, {
	var env, sound, freq;
	env = EnvGen.ar(
		Env.linen(
			attackTime: 0.01,
			sustainTime: 0,
			releaseTime: 0.3,
			level: 1,
			curve: -3),
		timeScale: \sustain.kr(1), doneAction:2);
	freq = 2000 * (\n.kr(10)/5 + 1).wrap(0.5,2);
	sound = HPF.ar(LPF.ar(WhiteNoise.ar(1), 3*freq), freq);
	sound = sound * \amp.kr(1);
	Out.ar(\out.kr(0), Pan2.ar(sound, \pan.kr(0), env));
}).add
);

(
Pbind(
	\instrument, \superhat,
	\n, Pwhite(1.0, 4.0, length: 50),
	\dur, 0.25,
	\sustain, Pwhite(0.1, 1.0),
	\amp, 1.0
).play
)

(
	SynthDef(\supersnare, {|out, sustain=1, pan, accelerate, n, decay=1, speed=1|
		var env = EnvGen.ar(Env.linen(0.01, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
		var freq = 100 * DirtFreqScale.kr(speed, accelerate, sustain) * (n/5+1).wrap(0.5,2);
		var sound = LPF.ar(Pulse.ar(freq), Line.ar(1030, 30, 0.2*sustain))
			+ (BPF.ar(HPF.ar(WhiteNoise.ar(1), 500), 1500) * Line.ar(1, 0, 0.2*decay));
		Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
	}).add
);


(
SynthDef(\supersnare, {
	var env = EnvGen.ar(
		Env.linen(
			attackTime: 0.01,
			sustainTime: 0,
			releaseTime: 0.6,
			level: 1,
			curve: -3),
		timeScale: \sustain.kr(1), doneAction:2);
	var freq = 100 * (\n.kr(5)/5+1).wrap(0.5,2);
	var mod = Line.ar(start: 1030, end: 30, dur: 0.2*\sustain.kr(1));
	var env2 = Line.ar(start: 1, end: 0, dur: 0.2 *\decay.kr(1));
	var sound1 = LPF.ar(in: Pulse.ar(freq), freq: mod);
	var sound2 = BPF.ar(in: HPF.ar(
		in: WhiteNoise.ar(1),
		freq: 500), freq: 1500) * env2;
	var sound = sound1 + sound2;
	sound = sound * \amp.kr(1);
	Out.ar(\out.kr(0), Pan2.ar(sound, \pan.kr(0), env));
}).add
);

(
Pbind(
	\instrument, \supersnare,
	\n, Pwhite(1.0, 4.0, length: 50),
	\dur, 0.25,
	\sustain, Pwhite(0.1, 1.0),
	\amp, 1.0,
	\decay, Pwhite(0.1, 1.0)
).play
)
