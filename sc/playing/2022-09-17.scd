
Utils.loadSetup;

t = TempoClock(2).permanent_(true);

// clap
d[\c][0].play

// open hat
d[\oh][1].postln

(
SynthDef(\samplePlayer,{ arg out = 0, bufnum, amp;
  Out.ar( out,
    PlayBuf.ar(2, bufnum, doneAction: Done.freeSelf) * amp;
  )
}).add;
)

(
SynthDef(\crash, { arg amp = 1;
  var whiteNoise = PinkNoise.ar(
    mul: Env.perc(releaseTime: 4, curve: -7).kr(doneAction: 2));
  Out.ar(0, Pan2.ar(HPF.ar(whiteNoise, freq: 7040)) * 4 * amp);
}).add;
)

(
SynthDef(\hat, { arg amp = 1, startPan = -1, endPan = 1, pitchVariation = 0, release = 0.1;
  var whiteNoise = WhiteNoise.ar(mul: Env.perc(releaseTime: release, curve: -7).kr(doneAction: 2));
  Out.ar(0, Pan2.ar(BBandPass.ar(whiteNoise, freq: pitchVariation, bw: 1), pos: Line.kr(startPan, endPan, 4)) * amp);
}).add;
)

(
SynthDef(\drone_saws, {
	arg freq = 75, gate = 1, pan = 0.9, detune = 0.05, amp = 1.0, atk=5.0, rel=5.0;
	var sig, detuner, n=4;
	sig = Array.fill(n, {arg i;
		RLPF.ar(
			in: LFSaw.ar(freq * (i+1+LFNoise1.kr(0.1).bipolar(detune)) * [1.0, 1.0+(detune/5.0+LFNoise0.ar(0.1).bipolar(detune/5.0))]).distort,
			freq: freq*2,
			rq: SinOsc.kr(0.5).range(0.8, 1.0),
			mul: SinOsc.kr(0.11).range(0.7, 1.0) * (i+1).reciprocal
		);
	}).sum;
	//sig = Splay.ar(sig);
	sig = sig * EnvGen.ar(Env.asr(atk, 1.0, rel), gate, doneAction: Done.freeSelf) * amp;
	sig = Balance2.ar(sig[0], sig[1], pos: LFNoise1.kr(0.1).bipolar(pan));
	Out.ar(0, sig);
}).add;
)

(
c = [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ]; // 16 beats
h = [ 0, 0, 1, 0 ];

a = [ 0.1, 0, 1, 0, 0, 0, 1, 0, 0.1, 0, 1, 0.1, 0, 0.1, 1, 0 ];
b = [ 0.5, 0, -0.5, 0, 0.7, -0.7 ];
f = [ -0.7, 0, 0.7, 0, 0.5, -0.5 ];
e = [
  0.1, 0.2, 0.1, 0.3, 0.2, 0.3, 0.5, 0.6,
  0.2, 0.1, 0.3, 0.3, 0.1, 0.2, 0.4, 0.2,
  0.1, 0.2, 0.2, 0.3, 0.1, 0.3, 0.3, 0.4,
  0.2, 0.1, 0.3, 0.3, 0.1, 0.2, 0.4, 0.2,
  0.1, 0.2, 0.2, 0.3, 0.1, 0.3, 0.3, 0.4,
  0.2, 0.1, 0.3, 0.3, 0.1, 0.2, 0.4, 0.2,
  0.1, 0.2, 0.3, 0.4, 0.2, 0.3, 0.1, 0.3
]; // hat release times
)

(
Pbind(
  \instrument, \drone_saws,
  \dur, 2,
  \legato, 4,
  \freq, Pseq([70, 50, 80], inf),
  \amp, 0.8
).play(t, quant: 16);
)

(
Pbind(
  \instrument, \hat,
  \dur, 1/4, // 16th note is one quarter of a beat!
  \amp, Pseq(a, inf),
  \startPan, Pseq(b, inf),
  \endPan, Pseq(f, inf),
  \pitchVariation, Prand([3520, 2637, 7040], inf),
  \release, Pseq(e, inf)
).play(t, quant: 16);
)

(
Pbind(
  \instrument, \samplePlayer,
  \dur, 1/4, // 16th note is one quarter of a beat!
  \bufnum, d[\c][0],
  \amp, Pseq(c, inf)
).play(t, quant: 16);
)

(
Pbind(
  \instrument, \samplePlayer,
  \dur, 1/4, // 16th note is one quarter of a beat!
  \bufnum, d[\oh][1],
  \amp, Pseq(h * 0.65, inf)
).play(t, quant: 16);
)