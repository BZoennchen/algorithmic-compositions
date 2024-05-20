s.boot;
s.plotTree

MIDIIn.connectAll;
MIDIFunc.trace(true);
MIDIFunc.trace(false);

(
SynthDef(\tri, {
	arg freq=200, harm=8, rel=0.6, amp=0.3, out=0, gate=1;
	var sig, env;
	sig = {LFTri.ar(freq + Rand(-2.0, 2.0))}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, (freq*harm).clip(20, 20000), 0.5);
	env = EnvGen.ar(Env.asr(0.001, 0.5, rel), gate: gate, doneAction: Done.freeSelf);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)


(
{
	loop{
		Synth(\tri, [
			\freq, rrand(40,90).nearestInScale([0,3,5,7,9, 10]).midicps,
			\harm, exprand(4,20),
			\amp, exprand(0.02, 0.1)
		]);
		0.16.wait;
	}
}.fork
)

(
// reset recording
t = TempoClock(1);
~history = Array.fill(127, {[]});
~synths = Array.fill(127, nil);
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan,src;
	var harm, amp, event, hist;
	if(~synths[num] == nil, {  // to be absolute save
		harm = exprand(4,20);
		amp = val.linexp(0, 127, 0.1, 1);
		~synths[num] = Synth(\tri, [\amp, amp, \freq, num.midicps, \harm, harm]);
		event = (\instrument: \tri, \start: t.beats, \freq: num.midicps, \harm: harm, \amp: amp);
		~history[num] = ~history[num].add(event);
	});
});

MIDIdef.noteOff(\off, {
	arg val, num, chan,src,event;
	if(~synths[num] != nil, {  // to be absolute save
		~synths[num].set(\gate, 0);
		~synths[num] = nil;
		event = ~history[num][~history[num].size-1];
		event[\dur] = t.beats - event[\start];
	});
});
)

(
// compute event sequence
~events = ~history.flat.sort({|a,b| a[\start] < b[\start]});
(0..(~events.size-1)).do({ arg i;
	if(i < (~events.size-2), {
		~events[i][\delta] = ~events[i+1][\start] - ~events[i][\start];
	},{
		~events[i][\delta] = 0;
	});
});
)

(
// play recording, i.e., event sequence
var index = 0;
t = TempoClock(1);
t.sched(0, {
	~events[index].play;
	index = index + 1;
	if(index < (~events.size), {~events[index-1].delta}, {nil});
});
)

