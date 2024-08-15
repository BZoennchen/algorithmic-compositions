(

SynthDef.new(\pluck,{arg amp=1, sus=1, pan=0, freq=440, vib=0, fmod=0, rate=0, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.01, rel=0.01, peak=1, level=0.8;
	var osc, env;
	sus = sus * blur;
	freq = [freq, freq+fmod];
	amp=(amp + 1e-05);
	freq=(freq + [0, LFNoise2.ar(50).range(-2, 2)]);
	osc=((SinOsc.ar((freq * 1.002), phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) * 0.3) + (SinOsc.ar(freq, phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) * 0.3));
	osc=((osc * XLine.kr(amp, (amp / 10000), (sus * 4), doneAction: Done.freeSelf)) * 0.3);
	osc = Mix(osc) * 0.5;
	osc = Pan2.ar(osc, pan);
	Out.ar(bus, osc)
}).add;

SynthDef.new(\soft,
{|amp=1, sus=1, pan=0, freq=440, vib=0, fmod=0, rate=0, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.01, rel=0.01, peak=1, level=0.8|
var osc, env;
sus = sus * blur;
freq = [freq, freq+fmod];
freq=(freq / 2);
amp=(amp / (200 * (1 + rate)));
osc=Klank.ar(`[[7, 5, 3, 1], [8, 4, 2, 1], [2, 4, 8, 16]], LFNoise0.ar((rate / sus)), freq);
env=EnvGen.ar(Env(times: sus,levels: [0, amp, 0],curve: 'lin'), doneAction: Done.freeSelf);
osc=(osc * env);
osc = Mix(osc) * 0.5;
osc = Pan2.ar(osc, pan);
	Out.ar(bus, osc)}).add;

SynthDef.new(\marimba,
{|amp=1, sus=1, pan=0, freq=440, vib=0, fmod=0, rate=0, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.01, rel=0.01, peak=1, level=0.8|
var osc, env;
sus = sus * blur;
freq = [freq, freq+fmod];
osc=Klank.ar(`[[0.5, 1, 4, 9], [0.5, 1, 1, 1], [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007]), freq, [0, 2]);
sus=1;
env=EnvGen.ar(Env.perc(attackTime: 0.001,releaseTime: sus,level: amp,curve: -6), doneAction: Done.freeSelf);
osc=(osc * env);
osc = Mix(osc) * 0.5;
osc = Pan2.ar(osc, pan);
	Out.ar(bus, osc)}).add;

SynthDef.new(\growl,
{|amp=1, sus=1, pan=0, freq=440, vib=0, fmod=0, rate=0, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.01, rel=0.01, peak=1, level=0.8|
var osc, env;
sus = sus * blur;
freq = [freq, freq+fmod];
sus=(sus * 1.5);
osc=(SinOsc.ar((freq + SinOsc.kr(0.5, add: 1, mul: 2)), mul: amp) * Saw.ar(((sus / 1.5) * 32)));
env=EnvGen.ar(Env(times: [(sus / 2), (sus / 2)],levels: [0, amp, 0],curve: 'lin'), doneAction: Done.freeSelf);
osc=(osc * env);
osc = Mix(osc) * 0.5;
osc = Pan2.ar(osc, pan);
	Out.ar(bus, osc)}).add;

)
