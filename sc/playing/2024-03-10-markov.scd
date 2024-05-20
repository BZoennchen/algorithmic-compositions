(
~funcNext = { |prevIndex|
	var index = 0;
	var sum = 0;
	var mmatrix = [
		[0.1, 0.3, 0.6],
		[0.3, 0.4, 0.3],
		[0.0, 0.54, 0.46]
	];

	while({(index < mmatrix.size) && (sum < { 1.0.rand } )}, {
		sum = sum + mmatrix[prevIndex][index];
		index = index + 1;
	});
	index-1;
};


~markovChain = {|n, start|
	var chain = [start];
	(n-1).do {
		chain = chain.add(~funcNext.(chain[ chain.size-1 ]));
	};
	chain;
};
)


(
Pbind(
	\scale, Scale.minor,
	\degree, Pseq(~markovChain.(10, 0)),
	\dur, 0.25
).play;
)



(
Pbind(
	\scale, Scale.minor,
	\degree, Prout(routineFunc: {
		var event = [0,1,2].choose;
		inf.do {
			event.yield;
			event = ~funcNext.(event);
		};
	}),
	\dur, 0.25
).play;
)


/////////////////////

(
~nodes = [
	(\midinote: 60, \dur: 1, \nodes: [1], \probs: [2].normalizeSum),
	(\midinote: 62, \dur: 0.5, \nodes: [0, 2], \probs: [1, 1].normalizeSum),
	(\midinote: 63, \dur: 1, \nodes: [0, 3], \probs: [1, 1].normalizeSum),
	(\midinote: 65, \dur: 0.5, \nodes: [0, 3, 4], \probs: [1, 4, 1].normalizeSum),
	(\midinote: 67, \dur: 1, \nodes: [5], \probs: [1].normalizeSum),
	(\midinote: 70, \dur: 1.5, \nodes: [4, 6], \probs: [1, 2].normalizeSum),
	(\midinote: 69, \dur: 1, \nodes: [4, 7], \probs: [1, 2].normalizeSum),
	(\midinote: 72, \dur: 0.5, \nodes: [4, 7, 0], \probs: [1, 4, 2].normalizeSum),
];
)

(
SynthDef(\beep, {
	var env = EnvGen.ar(Env([1, 0.1, 0], [0.06, \dur.kr(1.0) - 0.06]), doneAction: 2);
	Out.ar([0, 1], SinOsc.ar(\freq.kr(440) * [0.995, 1.005], 0, env * \amp.kr(1.0)))
}).add;
)

(
SynthDef(\inharm, {
  var freqs, sig, env;
  freqs = \freq.kr(100) * [0.7, 0.8, 1.2, 1.8, 2.23];

  sig = SinOsc.ar(freqs *.x [1.0, 1.2]);
  env = EnvGen.ar(
		Env([0, 1.0, 0], [0.01, \dur.kr(1.0)]),
    doneAction: Done.freeSelf);
  sig = sig * env * freqs.size.reciprocal;
	sig = Splay.ar(sig);
  Out.ar(0, sig);
}).add;
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
var node_index = 0;
var t = TempoClock(2.0);
{
	100.do {
		var node = ~nodes[node_index];
		var dur = node[\dur];
		var freq = node[\midinote].midicps;
		var prob = 1.0.rand;
		var acc = 0;

		node_index = block { |break|
			node[\probs].size.do {|i|
				if((prob < acc), {
					break.(node[\nodes][i]);
				}, {
					acc = acc + node[\probs][i];
				});
			}
		};

		Synth(\saw_approx, [
			\rel: dur.linlin(0.5, 1.5, 0.1, 1.0),
			\freq: freq,
			\amp: node[\midinote].linexp(60, 72, 0.8, 0.4)]);
		dur.wait;
	}
}.fork(t)

)

63.linexp(60, 72, 1.0, 0.5)






