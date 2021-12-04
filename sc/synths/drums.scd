(
SynthDef(\drum1,{
	arg amp=0.2, cutoff=500, atk=0.01, rel=0.1, out=0;
	var sig;
	sig = (SinOsc.ar(40) * 0.5 + HPF.ar(BrownNoise.ar(amp!2), cutoff)) * EnvGen.ar(Env.perc(atk,rel));
	sig = LPF.ar(sig, 3000);
	Out.ar(out, sig);
}).add
)
