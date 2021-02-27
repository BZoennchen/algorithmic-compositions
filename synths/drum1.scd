(
SynthDef("drum1",{
	arg amp=0.2, cutoff=500, atk=0.01, rel=0.1, out=0;
	var sig;
	sig = (SinOsc.ar(40) * 0.5 + HPF.ar(BrownNoise.ar(amp!2), cutoff)) * EnvGen.ar(Env.perc(atk,rel));
	Out.ar(out, sig);
}).add
)

Synth("drum1")

(
Pbindef(\drum1_pattern,
	\instrument, "drum1",
	\dur, Pseq([0.25, 0.5, 0.5, 0.5], inf),
	\amp, 0.1,
).play(quant: 4);
)