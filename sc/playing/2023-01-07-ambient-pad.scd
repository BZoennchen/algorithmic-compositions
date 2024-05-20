s.reboot;
Server.local.plotTree;
MIDIIn.connectAll;
(
SynthDef(\pad, {
	var sig;
	sig = Saw.ar(\freq.kr(100) * ({LFNoise2.kr(8)} ! 16 * 0.1).midiratio * [1, 2]);
	sig = DelayC.ar(sig, 0.01, { Rand(0, 0.01) } ! sig.size);
	sig = Splay.ar(sig);
	sig = LPF.ar(sig, XLine.kr(1000, 100, 8));
	sig = sig * Env.asr(3, 1, 3).ar(doneAction: Done.freeSelf, gate: \gate.kr(1));
	sig = sig * \amp.kr(-20.dbamp);
	sig = sig ! 2;
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\fx, {
	var sig;
	sig = In.ar(\out.kr(0), 2);
	sig = sig + NHHall.ar(sig, 3, modDepth: 1.0);
	sig = BHiShelf.ar(sig, 3000, 1.0, -10);
	sig = BPeakEQ.ar(sig, 240, 0.1, -8 * LFNoise2.kr(16 ! 2));
	sig = BPeakEQ.ar(sig, 500, 0.1, -8 * LFNoise2.kr(16 ! 2));
	sig = BPeakEQ.ar(sig, 900, 0.1, -8 * LFNoise2.kr(16 ! 2));
	sig = BLowShelf.ar(sig, 100, 1.0, -10);
	sig = Limiter.ar(sig);
	ReplaceOut.ar(\out.kr(0), sig);
}).add;

SynthDef(\ping, {
	var sig, n = 8;
	sig = SinOsc.ar(\freq.kr(200) * (1 + ({Rand(0,1)}!n * \detune.kr(0.01)))) / n;
	sig = sig * EnvGen.ar(Env.perc(0.01, 3.3), doneAction: Done.freeSelf);
	sig = sig * \amp.kr(0.5);
	sig = Splay.ar(sig);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\peng, {
	var sig;
	sig = Dust.ar([1, 0.5]) * 0.01;
	sig = Ringz.ar(sig, freq: TChoose.kr(sig, [100, 160, 300, 500]), decaytime: 0.1) * 0.55;
	sig = LPF.ar(in: sig, freq: \cutofffreq.kr(5000));
	Out.ar(\out.kr(0), sig);
}).add;
)


(
~synths = Array.fill(127, nil);
MIDIdef.noteOn(\on, {
	arg val, num, chan,src;
	if(~synths[num] == nil, {  // to be absolute save
		~synths[num] = Synth(\pad, [\amp, val.linexp(0, 127, 0.1, 0.8), \freq, num.midicps]);
	});
});

MIDIdef.noteOff(\off, {
	arg val, num, chan,src;
	if(~synths[num] != nil, {  // to be absolute save
		~synths[num].set(\gate, 0);
		~synths[num] = nil;
	});
});
)


(
Synth.tail(nil, \fx);
)

(
~frequencies = (45 + [3, 7, 12, 14, 15, 24, 26]).midicps;
)

(
Tdef(\t_peng, {
	~peng = Synth(\peng);
}).play;
)

(
Pbindef(\melody,
	\instrument, \ping,
	\freq, Pseq(~frequencies.scramble, inf),
	\dur, Pseq([Pwhite(0.01, 0.1, length: 6), Pwhite(2.0, 4.0, length: 1)], inf),
	\amp, 0.5,
	\detune, 0.1,
	\pan, Pseq([Pseq([rrand(-0.7, 0.7)], repeats: 7)], inf)
).play
)

(
p = Pseq([Pseq([rrand(-0.7, 0.7)], repeats: 7)], inf).asStream();
p.next.postln;
"test".postln
)


(
Tdef(\t_melody, {
	var melody = [[40, 43, 46], [55, 53, 50]].midicps;
	var frequencies = (45 + [3, 7, 12, 14, 15, 24, 26]).midicps;
	loop {
		var pan = rrand(-0.7, 0.7);
		frequencies.scramble.do { arg freq;
			Synth(\ping, [\freq: freq, \pan: pan]);
			rrand(0.01, 0.1).wait;
		};
		rrand(2.0, 4.0).wait;
	};
}).play
)

Tdef(\t_pads).stop;

(
Tdef(\t_pads, {
	loop {
		fork {
			var synth;
			synth = Synth(\pad, [\freq: ~frequencies.choose]);
			rrand(8.0, 16.0).wait;
			synth.set(\gate, 0);
		};
		rrand(0.3, 4.0).wait;
	};
}).play();
)
