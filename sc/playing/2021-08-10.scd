{Impulse.ar(XLine.kr(12, 48, 6, doneAction: Done.freeSelf)) * 0.1 ! 2 }.play;
{Impulse.ar(MouseX.kr(4, 108, 1)) * 0.5 ! 2 }.play;

(
SynthDef(\gaber, {
	arg out, freq = 440, sustain = 1, pan, amp = 0.1, width = 0.25;
	var env = LFGauss.ar(sustain, width, loop: 0, doneAction: Done.freeSelf);
	var son = FSinOsc.ar(freq, 0.5*pi, env);
	OffsetOut.ar(out, Pan2.ar(son, pan, amp));
}, \ir ! 6).add;
)

(
SynthDef(\gaber1, {
	arg out, freq = 440, sustain = 0.01, pan, amp = 0.1;
	var env = EnvGen.ar(Env.sine(sustain, amp), doneAction: Done.freeSelf);
	var snd = FSinOsc.ar(freq);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));
}, \ir ! 5).add;
)

(
Pbindef(\grain,
	\sustain, Pseq([0.001, 0.1], inf),
	\amp, Pseq([0.2, 0.1], inf),
).play;
)

(
Pbindef(\grain,
	\instrument, \gaber1,
	\freq, 1000,
	\dur, 0.5,
	\sustain, 30/1000,
	\amp, 0.2,
).play;
)

(
Pbindef(\grain,
	\sustain, Pseq((10..1)) / 1000
).play;
)

e = Env.sine.asSignal(400).as(Array).plot
w = Array.fill(400, {arg x; sin(x * 2pi/40)});

(
{ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2) }.play

)
