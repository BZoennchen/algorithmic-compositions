(
//run this first
SynthDef("flash",{
	arg fund = 400, decay = 4, filter = 1;
	var out, harm;
	out = Mix.ar(
		Array.fill(7,
			{
				arg counter;
				var partial;
				partial = counter + 1;
				SinOsc.ar(fund*partial) *
				EnvGen.kr(Env.linen(0, 0, decay + 2),
					levelScale: 1/(partial*filter)
				) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
		})
	)*0.3; //overall volume
	out = Pan2.ar(out, Rand(-1.0, 1.0));
	DetectSilence.ar(out, doneAction:2);
	Out.ar(0, out)
}).add
)

(
//then this
r = Task({
	var freqFunc, pitch = 440, nextEvent;
	freqFunc = {arg previousPitch;
		var nextPitch, nextInterval;
		nextInterval = [3/2, 2/3, 4/3, 3/4, 5/4, 4/5, 6/5, 5/6].choose;
		nextPitch = (previousPitch*nextInterval).wrap(100, 1000);
		nextPitch.round(0.01).post; " != ".post;
		nextPitch.cpsmidi.round(1).midicps.round(0.01).postln;
		nextPitch
	};
	{
		nextEvent = [0.5, 0.25, 5, 4, 1].choose;
		pitch = freqFunc.value(pitch);
		Synth("flash",[\fund, pitch, \decay, nextEvent, \filter, rrand(1.0, 4.0)]);
		//Choose a wait time before next event
		nextEvent.wait;
	}.loop;
}).play
)

3001.fold(820, 3000)

Pbind(\freq, 600).play
Pbind(\freq, Pfunc({rrand(100, 900)})).play;

(
SynthDef("SimpleTone",
	{arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8;
		Out.ar(0,
			Pan2.ar(
				SinOsc.ar(midinote.midicps, mul: amp)
				*
				EnvGen.kr(Env.perc(0, dur*legato), doneAction: 2),
				pan
			)
		)
}).add;
)

(
a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72];

Pbind(
	\instrument, "SimpleTone",
	\pan, -1,
	\midinote, Prand(
		[ //P, R, I, IR
			Pseq(a) + o.choose,
			Pseq(a.reverse) + o.choose,
			Pseq(12 - a) + o.choose,
			Pseq((12 - a).reverse) + o.choose
	], inf),
	\dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
		Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
	\amp, Prand([
		Pseries(0.1, 0.1, 5), // cresc
		Pseries(0.9, -0.1, 6), // decresc
		Prand([0.1, 0.3, 0.5, 0.7], 5)
	], inf)
).play;

Pbind(
	\instrument, "SimpleTone",
	\pan, 0,
	\midinote, Prand(
		[ //P, R, I, IR
			Pseq(a) + o.choose,
			Pseq(a.reverse) + o.choose,
			Pseq(12 - a) + o.choose,
			Pseq((12 - a).reverse) + o.choose
	], inf),
	\dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
		Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
	\amp, Prand([
		Pseries(0.1, 0.1, 5), // cresc
		Pseries(0.9, -0.1, 6), // decresc
		Prand([0.1, 0.3, 0.5, 0.7], 5)
	], inf)
).play;

Pbind(
	\instrument, "SimpleTone",
	\pan, 1,
	\midinote, Prand(
		[ //P, R, I, IR
			Pseq(a) + o.choose,
			Pseq(a.reverse) + o.choose,
			Pseq(12 - a) + o.choose,
			Pseq((12 - a).reverse) + o.choose
	], inf),
	\dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
		Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
	\amp, Prand([
		Pseries(0.1, 0.1, 5), // cresc
		Pseries(0.9, -0.1, 6), // decresc
		Prand([0.1, 0.3, 0.5, 0.7], 5)
	], inf)
).play;
)