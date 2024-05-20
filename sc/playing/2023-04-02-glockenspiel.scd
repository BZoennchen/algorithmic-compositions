s.boot;

(
SynthDef(\glockenspiel, {
	var sig, env, inharmonics, harmonics, n = 20;

	env = Env.perc(
		attackTime: 0.01,
		releaseTime: {Rand(0.3, 1.5)}!n,
		level: {Rand(0.1, 1.0)}!n,
		curve: -3.0,
	).kr;

	inharmonics = {exprand(\inharmlow.kr(150), \inharmup.kr(15000))}!n;
	harmonics = Array.series(n, \freq.kr(440), \freq.kr(440));

	sig = SinOsc.ar(inharmonics);
	sig = sig * (env  ** inharmonics.explin(
		\inharmlow.kr(150),
		\inharmup.kr(15000), 1, 10));

	sig = SinOsc.ar(harmonics) * (env  ** Array.series(n, 1, 0.15));
	sig = sig * n.reciprocal * \amp.kr(1.0) * 10;
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(\out.kr(0), sig);
}).add;
)


(
t = TempoClock(1);
Pbind(
	\instrument, \glockenspiel,
	\dur, Pseq(0.125!6 ++ [0.25], inf),
	\amp, 1.0,
	\scale, Scale.major,
	\pan, Pseq([-0.7,0.7], inf),
	\degree, Pseq([
		Pseq([0,2,0,4,2,0,4], 15),
		Pseq([0,1,2,3,4,2,0], 1)], inf) + Pseq([1,2,3,4], inf),
).play(t, quant: 4);
)

(
Pbind(
	\instrument, \glockenspiel,
	\dur, 0.25,
	\amp, 1.0,
	\scale, Scale.major,
	\pan, Pseq([-0.7,0.7], inf),
	\degree, Pseq([0, 3, 7, 0], inf),
	\octave, 3
).play(t, quant:4);
)

Pseq([Pseq([1,2,3], 3), Pseq([3,4,3], 1)]).asStream.all

(
{
	loop {
		([65, 67, 69, 55]).do { |note|
			Synth(\glockenspiel, [freg: note.midicps]);
			0.25.wait;
		};
		0.5.wait;
	};
}.fork;
)

(
{
    var env = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0]!2, [0.05, 0.1, 0.01, 1.0, 1.5]!2, -4!2);
    var envgen = EnvGen.ar(env, doneAction: Done.freeSelf);
    SinOsc.ar(
        envgen * 1000 + 440
    ) * envgen * 0.1
}.play
);

[1,2,3].linlin(1,3,10,20) ** [1, 2, 1]

[1!5, 2!5, 3!5].allTuples

[3,4,5] *.t [1,2,3]

(
Ndef(\sine_sum, {
    var sig, amp, odd, even, env;
    amp = 0.1;
    odd = Array.series(6, 1, 2);
    even = odd + 1;
    env = EnvGen.ar(Env.perc(
        attackTime: {Rand(0.001, 0.1)}!6,
        releaseTime: {Rand(1.0, 1.3)}!6,
        curve: {Rand(-6, -2)}!6));
    sig = [
        Mix.ar(SinOsc.ar(freq: odd * \freq.kr(400), mul: 1/odd * env)),
        Mix.ar(SinOsc.ar(freq: even * \freq.kr(400), mul: 1/even * env))
    ];
    sig*0.1;
}).play;
)

(
Ndef(\inharmonics, {
    var sig, inharmonics, env, partials = 20;
    env = EnvGen.ar(Env.perc(
        attackTime: 0,
        releaseTime: {Rand(0.2, 2.0)}!partials,
        level: {Rand(0, 1.0)}!partials,
        curve: -4));

    inharmonics = Array.fill(partials, {exprand(150, 4000)});
    sig = SinOsc.ar(inharmonics) * partials.reciprocal * env;
    sig = Splay.ar(sig);
    sig;
}).play;
)


