(
SynthDef.new(\long_sine, {
	var sig, noise, detune, freq, env;
	detune = 0.1;

	env = EnvGen.ar(Env.perc(0.001, 0.1), gate: Dust.ar(5));

	noise = LFNoise1.ar(300!2).range(1.0-detune, 1.0+detune);
	//noise = 1.0;
	freq = LFTri.ar(1000).range(\freq.kr(220) * 0.5, \freq.kr(220) * 2);
	sig = SinOsc.ar(freq!2 * noise) * \amp.kr(0.5);
	sig = LPF.ar(sig, freq*0.5);
	Out.ar(0, sig * env);
}).add;
)



Synth(\long_sine, [\freq: 240, \amp: 0.8])
Synth(\long_sine, [\freq: 640, \amp: 0.8])
Synth(\long_sine, [\freq: 100, \amp: 0.8])
Synth(\long_sine, [\freq: 70, \amp: 0.8])