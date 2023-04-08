(
SynthDef(\acsound,{|freq=440,amp=0.1,dur= 0.2,cutoff=2000|
	var sound, filter;
	sound= Saw.ar(freq, amp)*EnvGen.kr(Env([0,1,1,0],[0.01,0.05,(dur.max(0.07))-0.06]),doneAction:Done.freeSelf);
	filter= LPF.ar(sound,Line.kr(cutoff,300,dur));
	Out.ar(0,filter.dup(2))
}).add;
)

Synth(\acsound);

(
{
	arg freq = 240, amp = 0.5, cutoff = 1000;
	var sig, env, atk = 0.01, dec = 0.05, sus = 1.0, rel = 0.2;
	var dur = atk + dec + rel + sus;
	env = Env([0,1,0.8,0.8,0], [atk,dec,sus,rel], [5,-5,-5]).ar(doneAction: Done.freeSelf);
	sig = Saw.ar(freq!2) * amp * env;
	sig = LPF.ar(sig, XLine.ar(start: cutoff, end: 200, dur: dur));
}.play;
)

Env([0,1,0.8,0], [0.01,0.05,0.2], [5,-5,-5]).plot
{XLine.ar(start: 1000, end: 200, dur: 0.2)}.plot(0.2)

/*Pbindef(\ppiano,
	\instrument,
).play;*/