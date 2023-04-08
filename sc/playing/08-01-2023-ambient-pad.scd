s.reboot;
Server.local.plotTree;
Utils
(
SynthDef(\pad, {
	var sig, n= 16;
	sig = Saw.ar(\freq.kr(100) * ({LFNoise2.kr(8)} ! n * 0.1).midiratio * [0.5, 1.5]) / n;
	sig = DelayC.ar(sig, 0.01, { Rand(0, 0.01) } ! sig.size);
	sig = Splay.ar(sig);
	sig = LPF.ar(sig, XLine.kr(900, 100, 7));
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
	sig = LFTri.ar(\freq.kr(200) * ({Rand(0,1)} ! n * \detune.kr(0.01)).midiratio) / n;
	sig = sig * EnvGen.ar(Env.adsr(\atk.kr(0.01), 0.2, 0.3, \rel.kr(0.1)), doneAction: Done.freeSelf, gate: \gate.kr(1.0));
	sig = sig * \amp.kr(0.5);
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0));
	sig = LPF.ar(sig, \freq.kr(200) * 4 * XLine.ar(1.0, 0.01, \atk.kr(0.01) + \rel.kr(0.1) + 0.5));
	sig = HPF.ar(sig, 30);
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
Synth.tail(nil, \fx);
)

(
~frequencies = (45 + [3, 7, 12, 14, 15, 24, 26]).midicps;
)
[1,2,5] +.t [0,2,4]
(
Tdef(\t_peng, {
	~peng = Synth(\peng);
}).play;
)


(
Pbindef(\melody,
	\instrument, \ping,
	//\scale, Scale.minor,
	//\degree, Pseq(([1,2,5] +.t [0,2,4]).scramble ++ [\], inf),
	//\octave, 6,
	\freq, Pxrand({{~frequencies.choose}!5}!5, inf),
	\dur, Pseq(2!3 ++ [1], inf),
	\rel, 2,
	\atk, 0.01,
	\amp, Pwhite(0.65, 0.8),
	\strum, Pwhite(0.09, 0.1),
	\detune, Pexprand(0.001, 0.1),
	\pan, Prand([0.9, 0.8, 0.7, 0.6] *.x [1,-1], inf)
).play
)

(
Pbindef(\test2,
	\instrument, \default,
	\scale, Scale.melodicMinor,
	\degree, Pseq([[2, 5, 8], [5, 7, 9]], inf),
	\dur, 1,
	\amp, 0.5,
	\strum, Pseq([0.12,0.5], inf),
	\strumEndsTogether, false
).play
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
