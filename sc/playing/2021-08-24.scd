Utils.initTools;


(
Ndef(\test, {
	var sig, freg, detune;
	freg = \freq.kr(90);
	detune = 5;
	sig = LFSaw.ar({LFNoise1.ar(0.2).range(freg-detune, freg+detune)}!2) * 0.25 * SinOsc.ar(0.1, {Rand(0, 2pi)}!2).range(0.5,1);
	sig = RLPF.ar(sig, LFNoise1.ar(1).range(200, 300), LFNoise1.ar(10).range(0.5, 1.0));
}).play;
)

Ndef(\drone).play;


(
Ndef(\test, {
	var car, mod, modamp = 200;
	modamp = \freq.kr(200);

	mod = SinOsc.ar(SinOsc.ar(SinOsc.ar(\freq.kr(200)) * modamp) * modamp) * modamp;
	car = SinOsc.ar(mod) * 0.5;

}).play;
)

Ndef(\test).gui;