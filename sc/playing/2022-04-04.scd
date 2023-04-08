s.boot;

(
var maxNumBus = s.options.numControlBusChannels;
var maxDivision = 96;
var f = {
	~clock = {arg bpm = 60;
		var tick = Impulse.kr(bpm/60.0 * maxDivision);
		var count = PulseCount.kr(tick);
		Out.kr(maxNumBus-1, count);
	}.play;
	"clock reint".postln;
};

f.();

ServerTree.removeAll();
ServerTree.add(f, s);

~tg = {arg div;
	Trig1.kr(((In.kr(maxNumBus-1) % (maxDivision / div )).floor < 1), 0.01);
};

~tc = {arg div;
	var out = (In.kr(maxNumBus-1) / (maxDivision / div)).floor;
	out.postln;
	out
};

~gate ={arg div, n, seqs;
	Mix(seqs.collect({arg c; (~tc.(div) % n).floor eq: c}) * ~tg.(div));
};

)

{~gate.(4, 32, [8])}.plot(10)

Ndef(\bass).fadeTime_(2).play;
(
Ndef(\bass, {
	var gate = ~tg.(1);
	var note = 55;
	var env = Env.perc(0.0, 0.5).ar(gate: gate);
	var sig = SinOsc.ar(note.midicps, 0.0, env) * 0.5;
	Pan2.ar(sig);
})
)

5 % (4.1)

{Mix([1,0.5,0.25].collect({arg c; SinOsc.ar(100) eq: c}))}.plot(4/100)

5.eq({})