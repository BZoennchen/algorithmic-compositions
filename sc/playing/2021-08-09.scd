Utils.initTools;
s.boot;

( // add envelope generator

SynthDef(\sin_pulsar, {
	var a,b,c,d,e,f,fund;

	var overlapA = LFNoise1.kr(0.3).range(0.1,2);
	var overlapB = LFNoise1.kr(0.3).range(0.1,2);

	var attack = Rand(0.01,0.04);
	e = EnvGen.kr(
		Env.perc(
			attackTime: attack,
			releaseTime: Rand(1,\dur.kr(2)-attack)
		),
		doneAction: 2
	);

	f = \freq.kr(220);

	fund = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur: 1/f,
		freq: f
	);

	a = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur: overlapA / f,
		freq: Rand(1,4) * f
	);

	b = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur: overlapB / f,
		freq: Rand(5,13) * f
	);


	c = Mix([
		fund,
		a,
		b,
	]) * e;

	c = LeakDC.ar(c);
	Out.ar(0, c * 0.2!2)
}).add;
)

(
Pbind(
	\instrument, \sin_pulsar,
	\dur, Pseq([ 0.1,0.5,1, 2 ], inf),
	\degree, Pseq([ 1,3,5,7, 9, 11 ], inf),
	\octave, Pstutter(3, Pseq([3,4,5], inf) ),

).play;
)

Synth(\sin_pulsar);

(
Pbind(
	\instrument, \sin_pulsar,
	/*\dur, Pseq([.0.1, 0.5, 1, 2], inf),
	\degree, Pseq([1, 3, 5, 6, 9, 11], inf),
	\octave, Pstutter(3, Pseq([3,4,5], inf)),

	\overlapA, Pseq(2.pow([-1,0,1,2]), inf),
	\overlapB, Pseq(2.pow([-1,0,1].scramble), inf),

	\formantA, Pseq([1,2,3], inf),
	\formantB, Pseq([3,4,5,6,7].scramble, inf),
	\lev, Pshuf((1..10) * 0.01, inf)*/
).play;
)