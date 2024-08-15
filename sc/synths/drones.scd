/*
 * \drone_saws n=4 pairs of slightly detuned and distorted saw waves filtered by a ressonance low pass filter.
 * The ressonance, the detuning, and the panning is modulate by random LFOs.
 */

(
SynthDef(\drone_saws, {
	arg freq = 75, gate = 1, pan = 0.9, detune = 0.05, amp = 1.0, atk=1.0, rel=1.0;
	var sig, detuner, n=4;
	sig = Array.fill(n, {arg i;
		RLPF.ar(
			in: Saw.ar(freq * (i+1+LFNoise1.kr(0.1).bipolar(detune)) * [1.0, 1.0+(detune/5.0+LFNoise0.ar(0.1).bipolar(detune/5.0))]).distort,
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

