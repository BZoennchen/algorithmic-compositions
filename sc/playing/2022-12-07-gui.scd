s.reboot;

(
n = 30;
SynthDef(\sine, {
	var sig, env, harm, amps;
	harm = Control.names([\harm]).ir(Array.series(n, 1, 1));
	amps = Control.names([\amp]).ir(Array.fill(n, 0.1));

	sig = Mix(SinOsc.ar(\freq.kr(220)*harm) * amps);
	env = EnvGen.ar(Env(levels: [0, 1.0, \decLvl.kr(0.5), 0], times: [\attk.kr(0.01), \dec.kr(0.5), \rel.kr(1.0)], curve: [\c1.kr(5),\c2.kr(-3),\c3.kr(-5)]), doneAction: Done.freeSelf);
	sig = sig * env;
	Out.ar(0, sig!2);
}).add;


Window.closeAll();
a = 1390;
w = Window("Addative Synth", Rect(Window.screenBounds.width/2-250, Window.screenBounds.height/2-100, a, 200), false);
w.alwaysOnTop_(true);
w.front();

~envs = [
	(\decLvl: 0.5, \attk: 0.01, \dec: 0.5, \rel: 1.0, \c1: 4, \c2: -3, \c3: -5),
	(\decLvl: 1.0, \attk: 0.01, \dec: 0.0, \rel: 0.8, \c1: 4, \c2: -3, \c3: -5),
	(\decLvl: 1.0, \attk: 0.01, \dec: 0.0, \rel: 0.4, \c1: 4, \c2: -3, \c3: -5),
	(\decLvl: 0.4, \attk: 0.3, \dec: 0.2, \rel: 1.0, \c1: 4, \c2: -3, \c3: -5),
	(\decLvl: 1.0, \attk: 0.3, \dec: 0.0, \rel: 1.0, \c1: 1, \c2: -1, \c3: -1)
];
~env = ~envs[0];

~amp = 0.3;
~freq = 220;
~amps = Array.fill(n, {0.0});
~phases = Array.fill(n, 0);
~signal = Signal.sineFill(100, ~amps, ~phases);

~plotter = Plotter("sine", Rect(5, 5, 250, 190), w);
~plotter.value = ~signal;
~penv = Plotter("env", Rect(a-345, 5, 250, 190), w);
~penv.value = Env(levels: [0,1.0,~env[\decLvl],0], times: [~env[\attk],~env[\dec],~env[\rel]], curve: [5,-3,-5]).asSignal;

~sliders = [];
~routine = nil;
~smaster = Slider(w, Rect(255+10+(n*25), 5, 20, 190));
~smaster.background_(Color(0.5, 0.5, 0.8, 0.1));
~smaster.value_(~amp);
~smaster.action_({arg sl;
	    ~amps = ~amps / ~amp;
	    ~amp  = max(min(sl.value, 1.0), 0.1);
	    ~amps = ~amps * ~amp;
		~setAmps.();
	});

~setAmps = {
	for(0, ~sliders.size-1, {
		arg i;
		~sliders[i].value_(~amps[i] * (i+1) + 0.5);
		~sliders[i].refresh;
	});
	~signal = Signal.sineFill(10000, ~amps, ~phases);
	~plotter.value = ~signal;
	~plotter.refresh;
};

~bplay = Button(w, Rect(a-85, 145, 70, 20)).states_([['Play', Color.black, Color(0.3, 0.8, 0.1, 1.0)]])
.action_({arg b;
	Synth(\sine, [\amp, ~amps, \freq, ~freq, \decLvl, ~env[\decLvl], \attk, ~env[\attk], \dec, ~env[\dec], \rel, ~env[\rel], \c1, ~env[\c1], \c2, ~env[\c2], \c3, ~env[\c3]]);
});

~tfreq = TextField(w, Rect(a-85, 120, 70, 20));
~tfreq.string = ~freq.asString;
~tfreq.action_({arg field;
	~freq = field.value.asFloat;
});

~bEnv = Button(w, Rect(a-85, 55, 70, 20)).states_([
	['Env1', Color.black, Color(1.0, 1.0, 1.0, 1.0)],
	['Env2', Color.black, Color(1.0, 1.0, 1.0, 1.0)],
	['Env3', Color.black, Color(1.0, 1.0, 1.0, 1.0)],
	['Env4', Color.black, Color(1.0, 1.0, 1.0, 1.0)],
	['Env5', Color.black, Color(1.0, 1.0, 1.0, 1.0)]
])
.action_({arg b;
	~env = ~envs[b.value];
	~penv.value = Env(levels: [0,1.0,~env[\decLvl],0], times: [~env[\attk],~env[\dec],~env[\rel]], curve: [~env[\c1], ~env[\c2], ~env[\c3]]).asSignal;
	~penv.refresh;
});

~bStart = Button(w, Rect(a-85, 170, 70, 20)).states_([
	['Start', Color.black, Color(0.3, 0.8, 0.1, 1.0)],
	['Stop', Color.black, Color(0.8, 0.3, 0.1, 1.0)],
])
.action_({arg b;
	switch(b.value,
		0, {~routine.stop();},
		1, {~routine.reset();~routine.play();},
	);
});


~breset = Button(w, Rect(a-85, 5, 70, 20)).states_([['Reset', Color.black, Color(0.8, 0.6, 0, 1.0)]])
.action_({arg b;
	~amps = Array.fill(n, {0.0});
	~amp = 0.3;
	~smaster.value_(~amp);
	~setAmps.();
	~env = ~envs[0];
	~penv.value = Env(levels: [0,1.0,~env[\decLvl],0], times: [~env[\attk],~env[\dec], ~env[\rel]], curve: [~env[\c1], ~env[\c2], ~env[\c3]]).asSignal;
	~penv.refresh;
});

~bsaw = Button(w, Rect(a-85, 30, 70, 20)).states_([
	['Saw', Color.black, Color(0.6, 0.5, 0.9, 1.0)],
	['Pulse', Color.black, Color(0.6, 0.5, 0.8, 1.0)],
	['Tri', Color.black, Color(0.6, 0.5, 0.7, 1.0)]
])
.action_({arg b;
	~amps = switch(b.value,
		0, {Array.fill(n, {arg i; ((i+1)%2 == 0).if({0}, {(-1)**floor(i/2)/((i+1)**2)})})*8/(pi**2)*~amp},
		1, {Array.fill(n, {arg i; (-1)**(i)/(i+1);})*2/pi*~amp;},
		2, {Array.fill(n, {arg i; ((i+1)%2 == 0).if({0}, {1/(i+1)})})*4/pi*~amp;},
	);
	~setAmps.();
});

~sliders = Array.fill(n, {arg i;
	var sl = Slider(w, Rect(255+5+(i*25), 5, 20, 190));
	sl.background_(Color(0, 0.5, 0.8, 0.1));
	sl.value_(~amps[i] * (i+i) + 0.5);
	sl.action_({arg sl;
		~amps[i] = sl.value - 0.5 / (i+1);
		~setAmps.();
	});
});

~setAmps.();

~routine = Routine({
	loop {
		1.wait;
		Synth(\sine, [\amp, ~amps, \freq, ~freq, \decLvl, ~env[\decLvl], \attk, ~env[\attk], \dec, ~env[\dec], \rel, ~env[\rel], \c1, ~env[\c1], \c2, ~env[\c2], \c3, ~env[\c3]]);
	};
})
)