NetAddr.langPort; // default is 57120

(
OSCdef(
    \getCoords,
    {
        arg val;
		var degrees = [0,12,24] +.x Scale.major.degrees;
		Synth(\glockenspiel, [\freq: (50 + degrees[val[1]]).midicps, pan: 1.0.rand.linlin(0.0, 1.0, -0.5, 0.5), rel: 3.0, cutoff: 1500])
    },
    '/play/midi_note',
    recvPort: 6448
);
)



(
SynthDef(\glockenspiel, {
    var sig, env, env2, fundamental, partials;

    env = EnvGen.ar(Env(
        levels: [0, 1, 0.4, 0],
        times: [\atk.kr(0.01), \dec.kr(0.5), \rel.kr(1.5)],
        curve: -4));
    env2 = EnvGen.ar(Env(
        levels: [0, 0.25, 0.125, 0],
        times: [\atk.kr(0.01), \dec.kr(0.5)*0.25, \rel.kr(1.5)*0.4],
        curve: -6));

    fundamental = SinOsc.ar(\freq.kr(440)!2);
	partials = Saw.ar(([12, 24]).midiratio * \freq.kr(440));
    sig = fundamental * env;
    sig = sig + (partials * env2);
    sig = sig * 0.1 * \amp.kr(1.0);
    sig = sig.sum;
    sig = Pan2.ar(sig, \pan.kr(0));
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(\out.kr(0), sig);
}).add;
)

(
SynthDef(\sine_sum, {
    var sig, harmonics, amps, phases;

    harmonics = [1, 3, 5, 6, 7, 8, 9];
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

	sig = LPF.ar(sig, \cutoff.kr(1500));
    sig = sig * \amp.kr(0.5);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(0, sig);
}).add;
)

Synth(\sine_sum, [rel: 1.0])

s.reboot;