{Decay.ar(Impulse.ar(1.0), 0.2) * PinkNoise.ar}.play



{Decay.ar(Impulse.ar(2*10), 0.2) * PinkNoise.ar}.play

(
SynthDef(\imp, {
	var sig = Decay.ar(Impulse.ar(0), 0.2) * PinkNoise.ar;
	DetectSilence.ar(sig, doneAction: Done.freeSelf);
	Out.ar(0, sig!2);
}).add;
)

(
fork {
	Synth(\imp);
	(300.0 / 1000.0).wait;
	Synth(\imp);
}
)

(
Pbindef(\shepard,
	\midinote, Pseq(Array.series(15, 0, 1) +.t [0, 12, 24], inf) % (12*2) + 40,
	\amp, Pseq(Array.fill(15, {|x| 0.5 * (2*pi*x/14.0)}) +.t [0, 7, 0], inf).sin + 0.8,
	\dur, 0.25,
).play
)

[60, 61, 62] +.t [0, 12, 24]

122 % 10

Array.fill(15, {|x| 0.5 * (2*pi*x/14.0)});

(Array.series(15, 0, 1)+.t [0, 12, 24]).size

0.4.sin