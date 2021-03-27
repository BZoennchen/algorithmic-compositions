// beautiful smooth strings
s.reboot;
s.scope;
FreqScope.new;

(
SynthDef("strings",{
	arg freq=300, amp=0.1, atk=1, dec=0.2, sus=1, rel=0.5, detune=0.01, out=0;
	var sig, fund, voices, env, envLPF, unison, detunes;
	// number of voices
	unison = 2;

	env = EnvGen.ar(Env([0,2,0.65,0], [atk,dec,sus,rel], [6,-3,-2-2]), doneAction: 2);
	envLPF = LFTri.kr(0.5).range(1,2);
	//envLPF = EnvGen.ar(Env([0,1,0.22,0], [1.0,3.33,1,atk+dec+sus+rel-1-3.33-1], [1,-3,-1,-1]));
	// fundamental
	fund = Resonz.ar(Saw.ar(freq), freq, 0.5) * 0.5;


	// detuned voices
	if(unison != 0) {
		detunes = Array.interpolation(unison, (-1)*detune, detune);
		voices = detunes.collect({
			arg ele;
			Saw.ar(freq * (1+ele)) * exprand(1/detunes.size * 0.5, 1/detunes.size * 2);
		});
		sig = Splay.ar(voices);
	} {
		sig = [0,0];
	};
	// add fundamental
	sig = (sig + fund) * amp * env;
	sig = LPF.ar(sig, freq * envLPF);
	Out.ar(out, sig);
}).add;
)

Synth("strings")

(
Pbindef(\string_pattern,
	\instrument, "strings",
	\midinote, Prand(Scale.minor.degrees + 60, inf),
	\dur, 0.5,
	\amp, Pexprand(0.05, 0.2, inf),
	\dec, Pexprand(0.1, 0.2, inf)
).play(quant: 4);
)



