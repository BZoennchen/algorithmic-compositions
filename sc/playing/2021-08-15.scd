
0.dbamp
1.dbamp
(3).dbamp

{SinOsc.ar(400) * (-3).dbamp;}.play

{SinOsc.ar(400)}.play

({
	var sig = Saw.ar(500) ! 2 * 0.5;
	sig = HPF.ar(sig, 200);
	sig = LPF.ar(sig, 300);
	sig
}.play;)

({
	var sig = Saw.ar(500) ! 2 * 0.5;
	var bandwidth = 100;
	var cuttoffFeq = 200;
	sig = BPF.ar(sig, 250, rq: bandwidth / cuttoffFeq);
	sig
}.play;)


({
	var sig = Saw.ar(500) ! 2 * 0.5;
	var bandwidth = 100;
	var cuttoffFeq = 200;
	sig = BRF.ar(sig, 250, rq: bandwidth / cuttoffFeq);
	sig
}.play;)


(
Spec.add(\modfreq, [0, 1000]);
Spec.add(\freq, [0, 1000]);
Spec.add(\mincutoff, [5, 1000]);
Spec.add(\maxcutoff, [5, 1000]);

Ndef(\filtering, {
		var sig = Saw.ar(\freq.kr(400)) ! 2 * 0.5;
	var cuttoff = SinOsc.ar(\modfreq.kr(10)).range(\mincutoff.kr(100), \maxcutoff.kr(1000));
	var bandwidth = \maxcutoff.kr(1000) - \mincutoff.kr(100);
	sig = RLPF.ar(sig, cuttoff, rq: bandwidth / cuttoff);
}).play;
)

Ndef(\filtering).gui;












