Utils.initTools;

{SinOsc.ar(220) * 0.2!2}.play();

StageLimiter.activate;

(
SynthDef.new(\drone, {
	arg freq = 200;
	var sig, env, harmonics = 12, detune = 0.2;
	env = EnvGen.kr(Env.new(levels: [0,1,0], times: [1,1], curve:[1,-1]), doneAction: Done.freeSelf);
	sig = SinOsc.ar(freq) * 0.5!2 * env;

	sig = sig + sum(harmonics.collect({
		arg item;
		var freqSum = (item+1)*freq;
		var amp = 0.5*(1/( (item+1) * (item+1) ));
		SinOsc.ar(freqSum + LFNoise0.kr(0.4) * 1) * amp!2 * env;
	}));
	Out.ar(0, sig);
}).add;
)

Synth(\drone);

(
SynthDef.new(\fm, {
	var sig, env, mod, ienv;
	ienv = Env([1,\ipeak.ir(8),1], [\iatk.ir(0.01), \irel.ir(2)], [5,-10]).ar;
	env = Env([0,1,0], [\atk.ir(0.01), \rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(
		freq: \freq.kr(400) * \ratio.kr(2),
		mul: \freq.kr(400) * \ratio.kr(2) * ienv
	);
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

(
p = Routine({
 	loop {
		Synth(\fm, [\freq, 100, \rel: 2]);
		3.wait;
	}
}).play
)