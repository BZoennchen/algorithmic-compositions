// Frequency Modulation
(
Spec.add(\modfreq, [1, 600]);
Ndef(\fm_low_mod, {
	var mod = SinOsc.ar(\modfreq.kr(2)) * \freq.kr(200);
	SinOsc.ar(\freq.kr(200) + mod) * 0.5 ! 2;
}).play;
)

Ndef(\fm_low_mod).gui;

(
({
	var freq, mod, sig;
	freq = 200;
	mod = SinOsc.ar(freq) * freq;
	sig = SinOsc.ar(freq + mod);
	sig;
}).plot(1/(200));
)

(
Ndef(\fm, {
	var sig, modFreq1, modFreq2, car, mod1, mod2, f, ratio, env;

	f = \freq.kr(220);
	modFreq1 = f * \ratio1.kr(1);
	modFreq2 = f * \ratio2.kr(2/3);

	mod1 = SinOsc.ar(modFreq1) * f * \modIndex1.kr(1);
	mod2 = SinOsc.ar(modFreq2) * f * \modIndex2.kr(0.5);

	car = SinOsc.ar(f + [mod1,mod2].sum);

	sig = car ! 2 * \amp.kr(0.5);
})
)

Ndef(\fm).play;
Ndef(\fm).gui;

2.pow((-4..1))

(
Env.perc(
		0.015,
		4.0,
		curve: -1
).plot
)

(
{
	WhiteNoise.ar(400/8!2).lag(0.001);
}.plot(5);
)

(
SynthDef(\fm, {
    var sig, f, car, env;
	var modFreq1, modFreq2, modFreq3, mod1, mod2, mod3, ampmod1, ampmod2, ampmod3;

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

	// (6.13a) f_mod = f_car * r^{-1}_mod + distortion
    modFreq1 = f * \ratio1.kr(2).reciprocal + {Rand(-2, 2)}.dup;
    modFreq2 = f * \ratio2.kr(3).reciprocal + {Rand(-2, 2)}.dup;
    modFreq3 = f * \ratio3.kr(4).reciprocal + {Rand(-2, 2)}.dup;

	// (6.13b) A_mod = f_mod + beta_max
	ampmod1 = modFreq1 * \modIndex1.kr(1);
	ampmod2 = modFreq2 * \modIndex2.kr(0.5);
	ampmod3 = modFreq3 * \modIndex3.kr(0.8);

	// (partly 6.2 multiplied with env) A_mod * sin(2pi*f_mod t)
	// effectively reduces the modulation index beta_max over time
    mod1 = SinOsc.ar(modFreq1) * ampmod1 * env;
    mod2 = SinOsc.ar(modFreq2) * ampmod2 * env;
    mod3 = SinOsc.ar(modFreq3) * ampmod3 * env;

	// (6.1 or 6.3) y(t) = A_car * sin(f_car + A_mid * sin(2pi*f_mod t) t)
    car = \amp.kr(0.5) * SinOsc.ar(
		// f_car
        f +
		// changes the effective carrier frequency over time (low frequency) [\pm 5 * 10^{-3} * f_car; 0]
        LFTri.ar(env.pow(0.5) * LFNoise1.kr(0.3).range(1,5), Rand(0.0,2pi), mul: env.pow(0.2) * f * 0.005) +
		// distortion [-f/8; +f/8] but the noise is smoothen (its more like a Brownian motion.
        WhiteNoise.ar(f/8!2).lag(0.001) +
		// f_mod
        [mod1,mod2,mod3].sum);

	// add some envelope
    sig = car * env;
    sig = HPF.ar(sig, f);
    Out.ar(0, sig);
}).add;
)

{WhiteNoise.ar(1).range(0.2, 1).lag(0.01)}.plot(4.2)
{PinkNoise.ar(1).range( 0.1, 1).lag(0.01)}.plot(4.2)
{BrownNoise.ar(1)}.plot(0.05)
{GrayNoise.ar(1)}.plot(0.05)
{ClipNoise.ar(1)}.plot(0.05)
{PinkNoise.ar(1).range( 0.1, 1 ).lag(0.1)}.plot(5)
{OnePole.ar(WhiteNoise.ar(400/8), 0.90)}.plot(4/400);
{WhiteNoise.ar(400/8).lag(0.001)}.plot(4/400);

(
Pbind(
	\instrument, \fm,
	\dur, Pshuf(2.pow((-4..1)), inf),
	\degree, Pshuf([0, 2, 5, 6, 8, 11], inf),
	\octave, Pstutter(3, Pseq([3,4,5], inf)),
).play;
)


0.7.pow(1.5)

0.linlin(0, 1, 1, 0.5)


















