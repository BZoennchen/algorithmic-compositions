{WhiteNoise.ar(0.25!2)}.play;

{PinkNoise.ar(0.25!2)}.play;

{BrownNoise.ar(0.25!2)}.play;

{GrayNoise.ar(0.25!2)}.play;

{WhiteNoise.ar(0.25!2)}.plot(0.002);

{ClipNoise.ar(0.25!2)}.plot(0.002);

{GrayNoise.ar(0.25!2)}.plot(0.002);

(
Ndef(\drum, {
    var sig, amp, n, env;
	env = EnvGen.kr(Env.perc(0.01, 0.5, 1.0, -8.0), doneAction: Done.freeSelf);
	sig = SinOsc.ar(140!2) * 1.2;
    sig = WhiteNoise.ar(0.15!2) + sig;
	sig = sig * env;
}).play;
)

(
Ndef(\bell, {
    var freq, sig, env, amp;
	amp = 0.2;

	Mix.ar(
	{
		freq = rrand(100, 5000);
		env = EnvGen.kr(envelope: Env.perc(0.001, 500/freq), gate: Dust.kr(0.1));
		sig = SinOsc.ar(freq) * env;
		sig = sig * amp;
		sig = Pan2.ar(sig, rrand(-1.0, 1.0));
	}.dup(10));
}).play;
)