Utils.initTools;
{LFSaw.ar(300!2)}.play

(
Ndef(\sine_sum, {
    var sig, amp, n=20;
    var detuneFreq = 100;
    var detune = 0.009;

    amp = 0.5;
    sig = 0;

    n.do({
        arg index;
        var k = index+1;

        var env = EnvGen.ar(Env.perc(
            attackTime: \attk.kr(0.01) * Rand(0.8,1.2),
            releaseTime: \rel.kr(5.0) * Rand(0.9,1.1),
            curve: \curve.kr(-4))
        );

        var vibrato = LFNoise1.ar(detuneFreq!2).range(1-detune, 1+detune);
        var harmonicFreq = \freq.kr(220) * vibrato * k;
        var harmonic = ((1/2) - ((1/pi) * ((-1).pow(k) * SinOsc.ar(harmonicFreq) / k))) * env.pow(1+((k-1)/3));
        sig = sig + harmonic;
    });

    sig = sig * amp;
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    sig;
}).play;
)

Ndef(\sine_sum).gui