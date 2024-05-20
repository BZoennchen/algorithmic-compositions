s.boot;

(
SynthDef(\drum, {
	var sig, env, sum;
	sig = PinkNoise.ar(\amp.ir(0.5)!2) + SinOsc.ar(60);
	env = EnvGen.ar(Env.perc(releaseTime: \rel.ir(0.3)), doneAction: Done.freeSelf);
	sig = sig * env;
	sum = DelayN.ar(sig, 0.2, 0.15);
	sum = sum+DelayN.ar(sig, 0.3, 0.08);
	sum = sum+DelayN.ar(sig, 0.2, 0.10);
	sum = LPF.ar(sum, Rand(10000, 20000));
	Out.ar(0, sum);
}).add;
)

(
~clock = TempoClock(2);
Pbindef(\beat2,
	\instrument, \drum,
	\dur, 1/3.0
).play(~clock);
)

(
Pbindef(\beat1,
	\instrument, \drum,
	\dur, 2/3.0
).play(~clock);
)

(
Pbindef(\beat3,
	\instrument, \drum,
	\dur, 3/3.0
).play(~clock);
)

(
SynthDef(\saw_approx, {
    var sig, n=20, harmonics;

    harmonics = Array.geom(n, 1, -1) * Array.series(n, 1, 1);

    sig = harmonics.collect({ arg k;
        var env = EnvGen.ar(Env.perc(
            attackTime: \attk.kr(0.01) * Rand(0.8,1.2),
            releaseTime: \rel.kr(5.0) * Rand(0.9,1.1),
            curve: \curve.kr(-4))
        );

        var vibrato = 1 + LFNoise1.ar(\detuneFreq.kr(5)!2).bipolar(\detune.kr(0.015));
        var harmonicFreq = \freq.kr(220) * vibrato * abs(k);
        (1/pi) * SinOsc.ar(harmonicFreq) / k * env.pow(1+((abs(k)-1)/3));
    }).sum;

    sig = LPF.ar(sig, 1500);
    sig = sig * \amp.kr(0.5);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(0, sig);
}).add;
)

(
SynthDef(\sine_sum, {
    var sig, harmonics, amps, phases;

	harmonics = [1, 6, 8, 6, 10, 12, 13];
	phases = [0, 0, 0, 0.5, 0.25, 0, 0] * 2*pi;
	amps = [0.5, 0.1, 0.2, 0.6, 0.6, 0.1, 0.1].normalizeSum();

    sig = harmonics.collect({ arg k, index;
        var env = EnvGen.ar(Env.perc(
            attackTime: \attk.kr(0.01) * Rand(0.8,1.2),
            releaseTime: \rel.kr(5.0) * Rand(0.9,1.1),
            curve: \curve.kr(-4))
        );

        var vibrato = 1 + LFNoise1.ar(\detuneFreq.kr(5)!2).bipolar(\detune.kr(0.015));
        var harmonicFreq = \freq.kr(220) * vibrato * abs(k);
		amps[index] * SinOsc.ar(harmonicFreq, phases[index]) / k * env.pow(1+((abs(k)-1)/3));
    }).sum;

    sig = LPF.ar(sig, 1500);
    sig = sig * \amp.kr(0.5);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(0, sig);
}).add;
)


(
Pbindef(\melody,
    \instrument, \sine_sum,
    \dur, Pshuf(2.pow((-4..1)), inf),
	\rel, 6.0,
    \detune, Pwhite(0.001, 0.01, inf),
    \detuneFreq, 20,
	\amp, 0.5,
	\octave, Pdup(Prand([2,3,4], inf), Pseq([3,4,5], inf)),
	\degree, Pshuf([0, 2, 5, 6, 8, 11], inf),
).play;
)

(
Pbindef(\melody,
    \instrument, \saw_approx,
    \dur, Pshuf(2.pow((-4..1)), inf),
	\rel, 6.0,
    \detune, Pwhite(0.001, 0.01, inf),
    \detuneFreq, 20,
	\amp, 0.3,
	\octave, Pdup(Prand([2,3,4], inf), Pseq([3,4,5], inf)),
	\degree, Pshuf([0, 2, 5, 6, 8, 11], inf),
).play;
)


