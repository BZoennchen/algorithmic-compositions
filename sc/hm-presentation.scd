Utils.initTools;

// 1. REPL evaluation
10 + 3;
4 + 5;
Array.series(10, 0, 1);

Utils.initTools();

// 2. Variables and Scope

// 2.1 Global pre-initalized variable and 'normal' variables
(
x = 10;
x;
)

variable = 10;

var variable = 10;

// 2.2 Scope

x = 10;
(
x = x + 3;
x;
)

x = 10;
(
var x = 0;
x = x + 3;
x;
)

var variable = 10;
(
variable = variable + 3;
variable;
)


(
var variable = 10;
variable = variable + 3;
variable;
)

// 2.3 Global variables

3 + 5 * 3

~variable = 10;
(
~variable = ~variable + 3;
~variable;
)

// 3. Functions

(
var func = {
	var x = 10;
	x;
};
func.value();
)

(
var add = {
	arg a, b;
	a + b;
};
add.value(6,11)
)

// shortcut
(
var add = {
	|a = 5, b|
	a + b;
};
add.value(b: 11)
)



// 5. Our first sound

// 5.1 Play a 200 Hz sine wave
~sine = {SinOsc.ar(200, mul: 0.2)};
~sine.play();
~sine.plot();

// 5.2 Change arguments
~sine = {arg freq=200; SinOsc.ar(freq, mul: 0.2)};
~sineplay = ~sine.play();
~sineplay.set(\freq, 500);
~sineplay.release();

// 5.3 Explore some sounds

// Supercollider does not multiply before adding, you have to use brackets to enforce priority.
~twosines = {arg freq1=200, freq2=200; 0.2 * SinOsc.ar(freq1) + 0.2 * SinOsc.ar(freq2)};
~twosines.plot();

{arg freq1=200, freq2=200; (0.2 * SinOsc.ar(freq1)) + (0.2 * SinOsc.ar(freq2))}.plot();

{arg freq1=200, freq2=205; (0.2 * SinOsc.ar(freq1)) + (0.2 * SinOsc.ar(freq:freq2))}.play()

~sineplay = {arg freq1=200, freq2=205; (0.3 * SinOsc.ar(freq1)) + (0.3 * SinOsc.ar(freq:freq2))}.play()

~sineplay.set(\freq2, 201)

{arg freq1=200, freq2=200; (0.2 * SinOsc.ar(freq1)) + (0.2 * SinOsc.ar(freq:freq2,phase:pi))}.plot()

{arg freq1=200, freq2=200; (0.2 * SinOsc.ar(freq:freq2,phase:pi))}.plot()

// 5.4 Define a Synth
(
SynthDef.new(\sinewaves, {
	arg freq1=200, freq2=205, amp = 0.4, out = 0;
	var sig;
	sig = amp * 0.5 * SinOsc.ar(freq1);
	sig = sig + (amp * 0.5 * SinOsc.ar(freq:freq2));
	Out.ar(out, sig!2);
}).add();
)

rrand(0,10)!3
{rrand(0,10)}!3

// 5.5 Use a defined Synth

~sinewaves = Synth(\sinewaves);
~sinewaves.set(\freq1, 100);
~sinewaves.set(\amp, 0.2);

// 5.6 Envelope
[\linear, \exponential, \linear]
{EnvGen.kr(Env.new(levels: [0, 1, 0.4, 0], times: [0.1,0.4,0.1], curve: [2,0,-3]))}.plot(0.6);

(
SynthDef.new(\sinewaves, {
	arg freq1=200, freq2=205, amp = 0.4, out = 0;
	var sig, env;
	// doneAction: 2 removes the Synth from the server/memory if it is done!
	env = {EnvGen.kr(Env.new(levels: [0, 1, 0.4, 0], times: [0.1,0.4,0.1], curve: [2,0,-3]), doneAction: Done.freeSelf)};
	sig = amp * 0.5 * SinOsc.ar(freq1);
	sig = sig + (amp * 0.5 * SinOsc.ar(freq:freq2));
	sig = sig * env;
	Out.ar(out, sig!2);
}).add();
)

~sinewaves = Synth(\sinewaves);

(
{
	var sig, env, freq1=200, freq2=205, amp = 0.4;
	// doneAction: 2 removes the Synth from the server/memory if it is done!
	env = {EnvGen.kr(Env.new(
		levels: [0, 1, 0.4, 0],
		times: [0.1,0.4,0.1],
		curve: [2,0,-3]))};
	sig = amp * 0.5 * SinOsc.ar(freq1);
	sig = sig + (amp * 0.5 * SinOsc.ar(freq:freq2));
	sig = sig * env;
	sig;
}.plot(0.6)
)


// 6. Explore Sound
{ SinOsc.ar(MouseX.kr(10, 500))!2 * 0.5 }.play()

{ LPF.ar(in: Saw.ar(MouseX.kr(10, 500))!2 * 0.2, freq: MouseY.kr(0, 5000)) }.play()

{ LPF.ar(in: WhiteNoise.ar(mul: 0.2), freq: MouseX.kr(0, 500)) }.play()

{ LPF.ar(in: WhiteNoise.ar(mul: 0.4), freq: 1000) * EnvGen.ar(Env.perc(0.1, 0.7)) }.play()

{ EnvGen.ar(Env.perc(0.1, 0.7)) }.plot(0.8);

{ SinOsc.ar(100, mul: 0.2) + LPF.ar(in: WhiteNoise.ar(mul: 0.4), freq: 1000) * EnvGen.ar(Env.perc(0.1, 0.7)) }.play();




// 7. Example of an algorithmic composition by Eli Fieldsteel!

(
//cleanup
Pdef.all.do(_.clear);
Pbindef.all.do(_.clear);
~wt_buf.do(_.free);
t.stop;
ServerTree.remove(~add_reverb);

//initialization
s = Server.local;
t = TempoClock.new(90/60).permanent_(true);
s.newBusAllocators;
~rbus = Bus.audio(s,2);

s.waitForBoot({

	//10 wavetables with increasing complexity
	~wt_sig = 10.collect({
		arg i;

		//random number of envelope segments
		var numSegs = i.linexp(0,9,4,40).round;

		Env(
			//env always begins and ends with zero
			//inner points are random from -1.0 to 1.0
			[0]++({1.0.rand}.dup(numSegs-1) * [1,-1]).scramble++[0],

			//greater segment duration variety in higher-index wavetables
			{exprand(1,i.linexp(0,9,1,50))}.dup(numSegs),

			//low-index wavetables tend to be sinusoidal
			//high index wavetables tend to have sharp angles and corners
			{[\sine,0,exprand(1,20) * [1,-1].choose].wchoose([9-i,3,i].normalizeSum)}.dup(numSegs)
		).asSignal(1024);
	});

	//load into 10 buffers in wavetable format
	~wt_buf = Buffer.allocConsecutive(10, s, 2048, 1, {
		arg buf, index;
		buf.setnMsg(0, ~wt_sig[index].asWavetable);
	});

	SynthDef(\osc, {
		arg buf=0, freq=200, detune=0.2,
		amp=0.2, pan=0, out=0, rout=0, rsend=(-20),
		atk=0.01, sus=1, rel=0.01, c0=1, c1=(-1);
		var sig, env, detuneCtrl;
		env = EnvGen.ar(
			Env([0,1,1,0],[atk,sus,rel],[c0,0,c1]),
			doneAction:2
		);

		//array of eight Oscs with uniquely detune frequencies
		//and unique initial phase offsets
		detuneCtrl = LFNoise1.kr(0.1!8).bipolar(detune).midiratio;
		sig = Osc.ar(buf, freq * detuneCtrl, {Rand(0,2pi)}!8);

		sig = Splay.ar(sig); //spread 8 signals over stereo field
		sig = LeakDC.ar(sig); //remove DC bias
		sig = Balance2.ar(sig[0], sig[1], pan, amp); //L/R balance (pan)
		sig = sig * env;
		Out.ar(out, sig);
		Out.ar(rout, sig * rsend.dbamp); //"post-fader" send to reverb
	}).add;

	SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500;
		var sig;
		sig = In.ar(in, 2).sum;
		sig = DelayN.ar(sig, 0.03, 0.03);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = SplayAz.ar(2, sig);
		sig = LPF.ar(sig, lpf);
		5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;

	s.sync;

	//instantiate reverb and re-instantiate when cmd-period is pressed
	~add_reverb = {Synth(\reverb, [\in, ~rbus])};
	ServerTree.add(~add_reverb);
	s.freeAll;

	s.sync;

	//background pad using simple wavetables
	Pbindef(\pad,
		\instrument, \osc,
		\dur, Pwrand([1,4,6,9,12],[0.35,0.25,0.2,0.15,0.05],inf),
		\atk, Pexprand(3,6),
		\sus, 0,
		\rel, Pexprand(5,10),
		\c0, Pexprand(1,2),
		\c1, Pexprand(1,2).neg,
		\detune, Pfunc({rrand(0.15,0.4)}!3),
		\buf, Prand(~wt_buf[0..3], inf),
		\scale, Scale.minorPentatonic,
		\degree, Pfunc({
			(-12,-10..12).scramble[0..rrand(1,3)]
		}),
		\amp, Pexprand(0.05,0.07),
		\pan, Pwhite(-0.4,0.4),
		\out, 0,
		\rout, ~rbus,
		\rsend, -10,
	).play;

	//arpeggiated bass pulse using mid/high complexity wavetables
	Pbindef(\pulse,
		\instrument, \osc,
		\dur, Pseq([
			Pstutter(24,Pseq([1/4],1)),
			Prand([1,2,4,6,12],1)
		],inf),
		\atk, 0.001,
		\sus, 0,
		\rel, Pexprand(0.4,1),
		\c0, 0,
		\c1, Pwhite(5,10).neg,
		\detune, 0.3,
		\buf, Prand(~wt_buf[4..9], inf),
		\scale, Scale.minorPentatonic,
		\degree, Pseq([Prand([-15,-10,-5],24), Pseq([\],1)],inf)
		+ Pstutter(25,Pwrand([0,2,-1],[0.78,0.1,0.12],inf)),
		\amp, Pseq([Pgeom(0.45,-1.dbamp,25)],inf),
		\pan, Pwhite(0.01,0.3) * Pseq([1,-1],inf),
		\out, 0,
		\rout, ~rbus,
		\rsend, -10,
	).play(t, quant:1);

	//minimal melody using simple wavetables
	Pbindef(\melody,
		\instrument, \osc,
		\dur, Prand([
			Pseq([Prand([12,16,20]),2,1.5,0.5],1),
			Pseq([Prand([12,16,20]),1.5,1,1.5],1),
		],inf),
		\atk, 0.01,
		\sus, 0.3,
		\rel, 1.5,
		\c0, -2,
		\c1, -2,
		\detune, Pexprand(0.18,0.25),
		\buf, Pwrand([
			Pseq([~wt_buf[0]],4),
			Pseq([~wt_buf[1]],4),
			Pseq([~wt_buf[2]],4),
		],[9,3,1].normalizeSum,inf),
		\midinote, Pxrand([
			Pseq([\,67,60,Prand([58,70,\])],1),
			Pseq([\,67,58,Prand([57,63,\])],1),
			Pseq([\,70,72,Prand([65,79,\])],1)
		],inf),
		\amp, Pseq([0,0.18,0.24,0.28],inf),
		\out, 0,
		\rout, ~rbus,
		\rsend, -6,
	).play(t, quant:1);

	//infinite sequence of various finite rhythmic patterns
	//all very short envelopes
	Pdef(\rhythms,
		Pwrand([
			Pbind(
				\instrument, \osc,
				\dur,Pseq([1/8],4),
				\freq, Pstutter(4, Prand([
					Pexprand(10000,20000,1),
					Pexprand(100,200,1),
					Pexprand(1,2,1)
				],inf)),
				\detune, 100,
				\buf, Pstutter(4, Prand(~wt_buf[5..9],inf)),
				\atk, 0,
				\sus, 0,
				\rel, Pstutter(2, Pexprand(0.01,0.06)),
				\c1, exprand(8,20).neg,
				\amp, Pgeom(0.9, -6.dbamp, 4) * Pstutter(4,Pexprand(0.3,1)),
				\pan, Pwhite(-0.6,0.6),
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-30,-15),
			),

			Pbind(
				\instrument, \osc,
				\dur, Pseq([1/4],2),
				\freq, Pstutter(2, Pexprand(1,200)),
				\detune, Pstutter(2, Pexprand(1,100)),
				\buf, Pstutter(2, Prand(~wt_buf[8..9],inf)),
				\atk, 0,
				\sus, 0,
				\rel, Pstutter(2, Pexprand(0.01,0.2)),
				\c1, -10,
				\amp, Pgeom(0.4, -3.dbamp, 2)  * Pexprand(0.4,1),
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-30,-15),
			),

			Pbind(
				\instrument, \osc,
				\dur, Pseq([1/2,1/4,1/4],1),
				\freq, Pstutter(6, Pexprand(1000,2000)),
				\detune, 100,
				\buf, Pstutter(6, Prand(~wt_buf[2..5],inf)),
				\atk, 0,
				\sus, Pseq([1/3,0,0],1),
				\rel, Pseq([0,Pexprand(0.01,0.3,2)],1),
				\c1, -12,
				\amp, Pseq([0.1,0.5,0.3],1),
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-30,-18),
			),

			Pbind(
				\instrument, \osc,
				\dur, Pseq([1/4,1/2,1/4],1),
				\freq, Pstutter(6, Pexprand(1000,2000)),
				\detune, 100,
				\buf, Pstutter(6, Prand(~wt_buf[2..5],inf)),
				\atk, 0,
				\sus, Pseq([0,1/3,0],1),
				\rel, Pseq([Pexprand(0.01,0.3,1),0,Pexprand(0.01,0.3,1)],1),
				\c1, -12,
				\amp, Pseq([0.5,0.1,0.4],1),
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-30,-18),
			),

			Pbind(
				\instrument, \osc,
				\dur, Pseq([1/6],6),
				\freq, Pstutter(6, Pexprand(1,200)),
				\detune, Pstutter(6, Pexprand(1,100)),
				\buf, Pstutter(6, Prand(~wt_buf[8..9],inf)),
				\atk, 0,
				\sus, 0,
				\rel, Pstutter(6, Pexprand(0.01,0.1)),
				\c1, -10,
				\amp, Pgeom(0.7, -4.dbamp, 6)  * Pexprand(0.4,1),
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-30,-18),
			),

			Pbind(
				\instrument, \osc,
				\dur, Prand([
					Pseq([1/2],2),
					Pseq([1],2),
					Pseq([1,1/2,1/2],1),
					Pseq([2],1),
				],1),
				\freq, Pstutter(2, Pexprand(1,200)),
				\detune, Pstutter(2, Pexprand(1,100)),
				\buf, Pstutter(2, Prand(~wt_buf[8..9],inf)),
				\atk, 0,
				\sus, 0,
				\rel, Pstutter(2, Pexprand(0.01,0.2)),
				\c1, -10,
				\amp, 0.5,
				\out, 0,
				\rout, ~rbus,
				\rsend, Pwhite(-20,-10),
			),

			Pbind(
				\instrument, \osc,
				\dur, Prand([
					Pseq([1/16],16),
					Pseq([1/16],8)
				],1),
				\freq, Pstutter(16,Pexprand(1000,20000,inf)),
				\detune, 0,
				\buf, Pstutter(16, Prand(~wt_buf[0..9],inf)),
				\atk, 0,
				\sus, 0,
				\rel, Pexprand(0.02,0.04),
				\c1, -4,
				\amp, 0.13,
				\pan, Pseq([1,-1],inf),
				\out, 0,
				\rout, ~rbus,
				\rsend, -30,
			)
		],
		[40,18,3,3,15,25,5].normalizeSum, inf)
	).play(t,quant:1);
});
)

//view wavetables
~wt_sig.reverseDo(_.plot);

(
//can stop individually or all at once
Pdef(\rhythms).stop;
Pbindef(\melody).stop;
Pbindef(\pad).stop;
Pbindef(\pulse).stop;
)





