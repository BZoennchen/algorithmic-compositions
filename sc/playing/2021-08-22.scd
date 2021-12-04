(
SynthDef(\sine, {
	var sig, env;
	sig = FSinOsc.ar(\freq.ir(220), \phase.ir(0), \amp.ir(0.5));
	env = Env.sine(\dur.ir(0.5)).kr(2);
	sig = Pan2.ar(sig*env,\pan.ir(0));
	Out.ar(0,sig);
}).add;
)

(
Synth.grain(\sine,[
	freq: {1.0.rand2}.linexp(-1,1,200,2000),
	phase: {1.0.rand2}*pi,
	amp: {1.0.rand2}.linlin(-1,1,0.01,0.1),
	dur: {1.0.rand2}.linlin(-1,1,0.01,0.1),
	pan: {1.0}.rand2
]);
)

(
r = Routine {
	loop {
		Synth.grain(\sine,[
			freq: {1.0.rand2}.linexp(-1,1,200,2000),
			phase: {1.0.rand2}*pi,
			amp: {1.0.rand2}.linlin(-1,1,0.01,0.1),
			dur: {1.0.rand2}.linlin(-1,1,0.01,0.1),
			pan: {1.0}.rand2
		]);
		(1/60).wait;
	};
};
r.play;
)

(
Ndef(\pedestrian,  {
	SinOsc.ar(2500, 0, 0.02) * LFPulse.ar(5)
}).play
)

(
Ndef(\pedestrian,  {
	LPF.ar(WhiteNoise.ar(1.0) * Dust.ar(20), 4000)
}).play
)

(
Ndef(\phonesource, {
	var onoff;
	onoff = LFPulse.ar(1/6, width: 1/3);
	SinOsc.ar([480, 440], 0, onoff).sum * 0.2;
})
)

(
Ndef(\bouncer, {

	var bounceperiod, bouncetrigs, amp, fm, mainosc;
	bounceperiod = Line.kr(0.3, 0, 3, doneAction: 2);
	bouncetrigs = Impulse.kr(bounceperiod.reciprocal.min(30));

	amp = EnvGen.ar(Env.perc(0.001, 0.0), bouncetrigs);
	amp = Amplitude.ar(amp, 0, bounceperiod) * Line.kr(1, 0.05, 3);

	fm = SinOsc.ar(120).range(0, Line.ar(1, 0, 3)) + (amp * Line.ar(1, 0, 3).cubed * 130 + 80);

	mainosc = SinOsc.ar(fm, pi/2);
	amp * mainosc;
}).play
)