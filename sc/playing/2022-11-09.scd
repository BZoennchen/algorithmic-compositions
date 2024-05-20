s.boot;
(
SynthDef(\fm, {
    var sig, f, car, env;
    var modFreq1, modFreq2, modFreq3;
    var mod1, mod2, mod3;
    var ampmod1, ampmod2, ampmod3;


    // noisy envelope
    env = EnvGen.ar(Env.perc(
        \att.kr(0.015) * Rand(0.8,1.2),
        \rel.kr(4.0) * Rand(0.9, 1.1),
        curve: \curve.kr(-4)
    ),
    doneAction: Done.freeSelf);
    env = env * PinkNoise.ar(1!2).range( 0.1, 1 ).lag(0.01);

    // f = f_car
    f = \freq.kr(220);

    // (11.4a) f_mod = f_car * r^{-1}_mod + distortion
    modFreq1 = f * \ratio1.kr(2).reciprocal + {Rand(-2, 2)}.dup;
    modFreq2 = f * \ratio2.kr(3).reciprocal + {Rand(-2, 2)}.dup;
    modFreq3 = f * \ratio3.kr(4).reciprocal + {Rand(-2, 2)}.dup;

    // (11.4b) A_mod = f_mod + beta_max
    ampmod1 = modFreq1 * \modIndex1.kr(1);
    ampmod2 = modFreq2 * \modIndex2.kr(0.5);
    ampmod3 = modFreq3 * \modIndex3.kr(0.8);

    // (partly 11.2 multiplied with env) A_mod * sin(2pi*f_mod t)
    // effectively reduces the modulation index beta_max over time
    mod1 = SinOsc.ar(modFreq1) * ampmod1 * env;
    mod2 = SinOsc.ar(modFreq2) * ampmod2 * env;
    mod3 = SinOsc.ar(modFreq3) * ampmod3 * env;

    // (11.1 or 11.3) y(t) = A_car * sin(f_car + A_mid * sin(2pi*f_mod t) t)
    car = \amp.kr(0.5) * SinOsc.ar(
        // f_car
        f +
        // changes the effective carrier frequency over time (low frequency) [\pm 5 * 10^{-3} * f_car; 0]
        LFTri.ar(
            freq: env.pow(0.5) * LFNoise1.kr(0.3).range(1,5),
            iphase: Rand(0.0,2pi),
            mul: env.pow(0.2) * f * 0.005) +
        // distortion [-f/8; +f/8] but the noise is smoothen (it imitates a Brownian motion).
        WhiteNoise.ar(f/8!2).lag(0.001) +
        // f_mod
        [mod1,mod2,mod3].sum);

    // add some envelope
    sig = car * env;
    sig = HPF.ar(sig, f);
    sig = LPF.ar(sig, f);
    Out.ar(0, sig);
}).add;
)

(
SynthDef(\sine_sum, {
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

Synth(\fm)

(
OSCdef(
	\getCoords1,
	{
		arg val; var x, y;
		x = val[1];
		y = val[2];
		Pbindef(\melody,
			\instrument, \fm,
			\dur, Pshuf(2.pow((-4..1)), inf),
			\freq, val[1].linexp(0, 460, 100, 6000), // x => freq
			\ratio1, val[2].linlin(0, 460, 1, 4), // y => ratio1
			\ratio2, Prand([3,4,5], inf),
			\modIndex1, 1,
			\modIndex2, 0.5,
			\modIndex3, 0.8,
			\amp, 1.0
		).play;
		//'tick'.postln;

	},
	'/wek/inputs',
	recvPort: 6448
);
)

(
OSCdef(
	\getCoords1,
	{
		arg val; var min, max;
		min = 0;
		max = 500;
		Pbindef(\melody,
			\instrument, \sine_sum,
			\dur, Pshuf(2.pow((-4..1)), inf),
			\freq, val[1].linexp(min, max, 30, 1000),
			\detune, val[2].linexp(min, max,  0.001, 0.1),
			\amp, 1.0
		).play;
		val.postln;
	},
	'/wek/inputs',
	recvPort: 6448
);
)

(
OSCdef(
	\getCoords2,
	{
		arg val; var min, max;
		min = 0;
		max = 1;
		Pbindef(\melody,
			\instrument, \sine_sum,
			\dur, Pshuf(2.pow((-4..1)), inf),
			\freq, val[1].linexp(min, max, 30, 1000),
			\detuneFreq, val[2].linlin(min, max, 0.5, 20),
			\detune, val[3].linexp(min, max,  0.001, 0.1),
			\rel, val[4].linexp(min, max,  0.01, 7),
			\amp, 1.0
		).play;
		//val.postln;
	},
	'/wek/outputs',
	recvPort: 12000
);
)


(
OSCdef(
	\getCoords2,
	{
		arg val; var min, max;
		min = 0;
		max = 1;
		Pbindef(\melody,
			\instrument, \fm,
			\dur, Pshuf(2.pow((-4..1)), inf),
			\freq, val[1].linlin(min, max, 100, 700),
			\ratio1, val[2].linlin(min, max, 1, 4),
			\ratio2, val[3].linlin(min, max, 1, 4),
			\modIndex1, val[4].linlin(min, max, 1, 5),
			\modIndex2, val[5].linlin(min, max, 1, 5),
			\modIndex3, val[6].linlin(min, max, 1, 5),
			\amp, 1.0
		).play;
		//val.postln;
	},
	'/wek/outputs',
	recvPort: 12000
);
)

OSCdef.freeAll






