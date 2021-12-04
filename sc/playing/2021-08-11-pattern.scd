~pfunc = Pfunc({10.rand;}, {\resets.postln;});
~pfuncx = ~pfunc.asStream;
~pfuncx.next(10).postln;
~pfuncx.reset;

~pfuncn = Pfuncn({10.rand;}, 4);
~pfuncnx = ~pfuncn.asStream;
~pfuncnx.next().postln;

~pexprand = Pexprand(0.5, 10, inf);
~pexprandx = ~pexprand.asStream;
~pexprandx.next().postln;

~pbrown = Pbrown(0.5, 10, 1, inf);
~pbrownx = ~pbrown.asStream;
~pbrownx.next().postln;


s.boot;

(
p = Pbind(
	\degree, Pseq(#[[0, 1], 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all;
​
// or, to show the segments as separate arrays
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).clump(3).asStream.all;
​
// Flock of Seagulls!
// Hanon exercise
(
p = Ppatlace([
        Pseries(0, 1, 8),    // first, third etc. notes
        Pseries(2, 1, 7)    // second, fourth etc. notes
    ], inf).asStream;
p.next.postln;
p.next.postln;
p.next.postln;
p.next.postln;
p.next.postln;
p.next.postln;
)

p = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 0.5).play;
p.stop;

p = Pmono(\default, \degree, Pwhite(0, 7, inf), \dur, 0.25).play;
p.stop;

(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 84/60;

p = Pbind(
    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, 2,
    \degree, Pseq(#[rest, 4, 3, 4, 2, 4, 1, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2, 4,
        -3, 4, -1.9, 4, -0.9, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2], 1),
    \dur, 0.25
).play;
)

(
p = Pbind(
    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, 2,
    \degree, Place([#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2],
        (4 ! 16) ++ \rest], 17),
    \dur, 0.25
).play;
)

(
p = Pbind(
    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, 2,
    \degree, Ppatlace([Pseq(#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2], 1),
        Pn(4, 16)], inf),
    \dur, 0.25
).play;
)

2/7.reciprocal

Synth(\bass);

p.stop;