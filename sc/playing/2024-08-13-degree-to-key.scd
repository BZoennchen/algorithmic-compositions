
~scale = Buffer.loadCollection(s, Scale.minorPentatonic.degrees);

(
{
	var sig, pch, freq, index;
	index = LFDNoise0.kr(7).range(0, 4);
	pch = DegreeToKey.kr(~scale, index * BufFrames.kr(~scale));
	freq = (pch + 36).midicps;
	//freq.poll;
	sig = VarSaw.ar(freq, mul: 0.2!2);
}.play;
)

(
SynthDef(\d2k, {
	arg buf, inote=36, gate=1;
	var sig, index, pch, freq;
	index = LFDNoise3.kr(0.2!4).range(0, 5);
	index = index * BufFrames.kr(buf);
	pch = DegreeToKey.kr(buf, index) + inote;
	pch = pch + LFNoise1.kr(0.2!4).bipolar(0.12);
	freq = pch.midicps.lag(0.02);

	sig = VarSaw.ar(freq) * 0.2;
	sig = Splay.ar(sig, 0.75);
	sig = sig * EnvGen.kr(
		Env([0,1,0,0], [0.05, 4, 7], [0, -2, 0], 1),
		gate,
		doneAction: Done.freeSelf
	);
	sig = sig.blend(
		CombN.ar(sig, 0.25, 0.25, 2),
		0.5
	);
	sig = sig.blend(
		LPF.ar(GVerb.ar(sig.sum, 200, 3), 1000),
		0.4
	);
	Out.ar(0, sig);
}).add;
)

x = Synth(\d2k, [\buf, ~scale, \inote, 20])
x.set(\gate, 0)

Scale.minorPentatonic.degrees
