(
~notes = [
    [74, 0.5],
    [67, 0.25], [69, 0.25], [71, 0.25], [72, 0.25],
    [74, 0.5], [67, 0.5], [67, 0.5],
    [76, 0.5],
    [72, 0.25], [74, 0.25], [76, 0.25], [78, 0.25],
    [79, 0.5], [67, 0.5], [67, 0.5],
    [72, 0.5],
    [74, 0.25], [72, 0.25], [71, 0.25], [69, 0.25],
    [71, 0.5],
    [72, 0.25], [71, 0.25], [69, 0.25], [67, 0.25],

    [66, 0.5],
    [67, 0.25], [69, 0.25], [71, 0.25], [67, 0.25],
    [71, 0.5],[69, 1],

    [74, 0.5],
    [67, 0.25], [69, 0.25], [71, 0.25], [72, 0.25],
    [74, 0.5], [67, 0.5], [67, 0.5],
    [76, 0.5],
    [72, 0.25], [74, 0.25], [76, 0.25], [78, 0.25],
    [79, 0.5], [67, 0.5], [67, 0.5],
    [72, 0.5],
    [74, 0.25], [72, 0.25], [71, 0.25], [69, 0.25],
    [71, 0.5],
    [72, 0.25], [71, 0.25], [69, 0.25], [67, 0.25],

    [69, 0.5],
    [71, 0.25], [69, 0.25], [67, 0.25], [66, 0.25],
    [67, 1.5]
];

{
	~notes.do ({ |pair|
		Synth(\saw_approx, [freq: pair[0].midicps, rel: 1.1]);
		pair[1].wait;
	});
}.fork;

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
