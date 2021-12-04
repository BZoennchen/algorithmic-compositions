Utils.initTools

// Amplitude Modulation

(
Spec.add(\freq, [100, 600]);
Spec.add(\freqmod, [0.01, 600]);
Spec.add(\ampcar, [0, 1]);
Spec.add(\ampmod, [0, 1]);

Ndef(\am, {
	var sig, amp;
	amp = \ampcar.kr(1) + (\ampmod.kr(1) * SinOsc.ar(\freqmod.kr(5), 0.5*pi));

	sig = SinOsc.ar(\freq.kr(200), 0.5*pi);

	sig = sig * amp * (1/3) ! 2;
}).play;
)

Ndef(\am).gui

({
	var sig, amp;
	amp = \ampcar.kr(1) + (\ampmod.kr(1) * SinOsc.ar(\freqmod.kr(100), 0.5*pi));

	sig = SinOsc.ar(\freq.kr(100), 0.5*pi);
	sig = sig * amp * (1/3);
	//sig = LeakDC.ar(sig);
	sig
}.plot(10/200))


(
Spec.add(\freq, [100, 600]);
Spec.add(\ratio, [0.0, 10]);
Spec.add(\ampcar, [0, 1]);
Spec.add(\ampmod, [0, 1]);

Ndef(\am, {
	var sig, amp, freqmod;
	freqmod = \radio.kr(1) * \freq.kr(200);
	amp = \ampcar.kr(1) + (\ampmod.kr(1) * SinOsc.ar(freqmod, 0.5*pi));

	sig = SinOsc.ar(\freq.kr(200), 0.5*pi);

	sig = sig * amp * (1/3) ! 2;
}).play;
)

{SinOsc.ar(200) + SinOsc.ar(200, pi)}.play

({
	arg freq = 200, fundAmp = 0.2;
	var numHarmonics = 25;
	var sig = [0, 0];
	for(1, numHarmonics, { |n|
		var hFreq = freq * n;
		var phase = pi * hFreq / freq;
		sig = sig + SinOsc.ar(hFreq ! 2, phase, fundAmp/n) + SinOsc.ar(hFreq ! 2, 0, fundAmp/n);
	});
	sig ! 2 * 0.5;

}.play;
)

({
	var cutoff = 500;
	LPF.ar(LPF.ar(Saw.ar(400!2), cutoff + (SinOsc.ar(300) * 100)), cutoff);
}.play;)


({
	var sig = SinOsc.ar(200);
	sig = sig + DelayL.ar(sig, maxdelaytime: 0.2, delaytime: 1/(2*200));
}.play;
)

({
	var sig = SinOsc.ar(200);
	sig = sig + CombL.ar(sig, maxdelaytime: 0.2, delaytime: 1/(2*200), decaytime: inf);
}.play;
)

({
	var sig = Saw.ar(200 ! 2);
	sig = sig + DelayL.ar(sig, maxdelaytime: 0.2, delaytime: 1/(2*200)) * 0.5;
	sig;
}.play;
)

