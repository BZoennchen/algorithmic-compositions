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