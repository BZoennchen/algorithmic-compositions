s.boot;
MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.trace(false);

(
SynthDef(\tri, {
	arg freq=200, harm=8, rel=0.6, amp=0.1, out=0;
	var sig, env;
	sig = {LFTri.ar(freq + Rand(-2.0, 2.0))}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, (freq * harm).clip(20, 20000), 0.5);
	env = Env.perc(0.001, rel).ar(doneAction: Done.freeSelf);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\tri);

Server.local.plotTree;

({
	loop{
		Synth(\tri, [
			\freq, rrand(40, 90).nearestInScale([0, 3, 5, 7, 9, 10]).midicps,
			\harm, exprand(4, 20),
			\amp, exprand(0.02, 0.1)
		]);
		0.16.wait;
	};
}.fork;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	Synth(\tri, [
			\freq, num.midicps,
		\harm, val.lincurve(0, 127, 1, 40, 9),
		\amp, val.linlin(0, 127, -40, -12).dbamp
		]);
}
);
)