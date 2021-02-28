(
SynthDef(\playBuff, {
	arg buf, freq=440, out=0, amp=0.2, pan=0, atk=0.01, sus=1, rel=0.01, detune=0.2;
	var env, sig, c0, c1, detuneCtrl;
	c0 = 1;
	c1 = -1;
	env = EnvGen.ar(Env([0,1,1,0],[atk,sus,rel],[c0,0,c1]), doneAction:2);

	detuneCtrl = LFNoise1.kr(0.1!8).bipolar(detune).midiratio;
	sig = Osc.ar(buf, freq * detuneCtrl, {Rand(0,2pi)}!8);
	sig = Splay.ar(sig); //spread 8 signals over stereo field
	sig = LeakDC.ar(sig); //remove DC bias
	sig = Balance2.ar(sig[0], sig[1], pan, amp); //L/R balance (pan)
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

(
var env, buff;
env = Env.rand(5,1,true).asSignal(1024);
~buff = Buffer.alloc(s, 2048);
~buff .loadCollection(env.asWavetable);
)

Synth(\playBuff, [\buf, ~buff, \atk, 3, \sus, 0, \rel, 6, \amp, 0.06]);