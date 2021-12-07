

{VarLag.kr(LFNoise0.kr(5).range(0,100),1/5,warp:\sine)}.plot(4)

{LFNoise0.kr(5).range(0,100)}.plot(4)

(
x = SynthDef("basic_w_overtones_varsaw_modulation",
    {
        arg hz=131.81, amp=0.5;
        var sig;

        // the drone zone!
        sig = Mix.ar(
            VarSaw.ar(
                freq: Lag.kr(hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp ,
            ) +
            VarSaw.ar(
                freq: Lag.kr(2*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp/2,
            ) +
            VarSaw.ar(
                freq: Lag.kr(4*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp/4,
            )
        );

        // spread the signal
        sig = Splay.ar(sig);

        // pan
        sig = Balance2.ar(sig[0] ,sig[1],SinOsc.kr(
            LFNoise0.kr(0.1).range(0.05,0.2)
        )*0.1);

        // make sound!
        Out.ar(0,sig);
    }
).play;
)

(
x = SynthDef("dreamcrusher",
    {
        arg hz=131.81, amp=0.5,t_trig=0;
        var local, ampcheck, sig, env;

		// envelope to clamp looping
		env=EnvGen.ar(
			Env.new(
				levels: [0,1,1,0],
				times: [0.5,1,0.5],
			),
			gate:t_trig,
		);

        // the oscillator part
        sig = Mix.ar(
            VarSaw.ar(
                freq: Lag.kr(hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp,
            ) +
            VarSaw.ar(
                freq: Lag.kr(2*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp/2,
            ) +
            VarSaw.ar(
                freq: Lag.kr(4*hz * SinOsc.kr(LFNoise0.kr(1)).range(0.99,1.01),1),
                width: SinOsc.kr(LFNoise0.kr(1)).range(0.4,0.6),
                mul: amp/4,
            )
        );

        // spread the signal
        sig = Splay.ar(sig);

        // pan
        sig = Balance2.ar(sig[0] ,sig[1],SinOsc.kr(
            LFNoise0.kr(0.1).range(0.05,0.5)
        )*0.1);

        // feedback directly taken from the docs
        // https://depts.washington.edu/dxscdoc/Help/Classes/LocalOut.html
        ampcheck = Amplitude.kr(sig);
		sig = sig * (ampcheck > 0.22); // noise gate
        local = LocalIn.ar(2);
        local = OnePole.ar(local, 0.4);
        local = OnePole.ar(local, -0.08);
        local = Rotate2.ar(local[0], local[1],0.2);
        local = DelayN.ar(local, 0.3,
            VarLag.kr(LFNoise0.kr(0.1).range(0.15,0.3),1/0.1,warp:\sine)
        );
        local = LeakDC.ar(local);
        sig = ((local + sig) * 1.25).softclip;

        // filter with drunken walk modulation
        sig = LPF.ar(sig,
            VarLag.kr(LFNoise0.kr(0.3).range(hz,16000),1/0.3,warp:\sine)
        );

        // feedback
        LocalOut.ar(sig*
            VarLag.kr(LFNoise0.kr(2).range(0.9,1.2),1/2,warp:\sine)
        );

        // panning
        sig = Balance2.ar(sig[0] * 0.2,sig[1]*0.2,SinOsc.kr(
            LFNoise0.kr(0.1).range(0.05,0.2)
        )*0.1)*amp;

        // send it out
        Out.ar(0,sig);
    }
).play;
)










//////////// my suff
(
SynthDef(\drone, {
    var sig, amp, freqmod, widthmod;
	amp = 0.85;
	freqmod = SinOsc.kr(LFNoise0.kr(1)).range(1-\detune.kr(0.01), 1+\detune.kr(0.01));
	widthmod = SinOsc.kr(LFNoise0.kr(1)).range(0.35, 0.65);
	sig = VarSaw.ar(\freq.kr(150) * freqmod) * amp;
	Out.ar(0, sig);
}).play;
)
Synth(\drone);


(
SynthDef(\drone, {
    var sig, amp, freqmod, widthmod, local, n = 3;
	amp = 0.25;

	sig = Array.fill(n, {
		arg i;
		freqmod = SinOsc.kr(LFNoise0.kr(1)).range(1-\detune.kr(0.01), 1+\detune.kr(0.01));
		widthmod = SinOsc.kr(LFNoise0.kr(1)).range(0.35, 0.65);
		sig = VarSaw.ar((i+1)*\freq.kr(150) * freqmod) * (i+1).reciprocal;
	}) * amp;

	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], SinOsc.kr(LFNoise0.kr(0.1).range(0.05,0.2))*0.1);

	local = LocalIn.ar(2);


	sig = LPF.ar(sig, VarLag.kr(LFNoise0.kr(0.3).range(\freq.kr(150),16000),1/0.3,warp:\sine));


	Out.ar(0, sig);
}).play;
)

Synth(\drone);


({
	var sig = LFNoise1.ar(50);
	[sig, OnePole.ar(sig, 0.5)]
}.plot(3)
)

{ SinOsc.ar(220).softclip }.play

({
	var sig = WhiteNoise.ar(0.5!2) * 0.5 * SinOsc.kr(1);
	sig * (Amplitude.ar(sig) > 0.1);
}.play
)

({
	var freg = 100;
	var attackTime = 0.1;
	var releaseTime = 0.2;
	var env = EnvGen.ar(Env.perc(attackTime: attackTime, releaseTime: releaseTime));
	var sig = SinOsc.ar(freg) * env;
	[Amplitude.ar(sig, attackTime, releaseTime)>0.2, sig, abs(sig)]
}.plot(0.4);
)

{ { (0..17).normalize(0, 15.0.rand).sin }.dup(4) }.dup(3).plot;

({
	var freg = 20;
	var attackTime = 0.1;
	var releaseTime = 0.2;
	var env = EnvGen.ar(Env.perc(attackTime: attackTime, releaseTime: releaseTime));
	var sig = SinOsc.ar(freg) * env;
	sig
}.plot(0.4);
)

(2*400).reciprocal

(
{
	var freq = 220;
	var sample_rate = 48000;
	var dt = sample_rate.reciprocal;
	[OneZero.ar(SinOsc.ar(freq), -0.5) * 2 / dt / (2 * pi * freq), SinOsc.ar(freq)]
}.plot(1/220)
)

Lag