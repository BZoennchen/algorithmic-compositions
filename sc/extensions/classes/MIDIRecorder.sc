MIDIRecorder {
	var name, instrument, history, synths, <events, clock, noteOn, mono, paused, pauseTime, midiDefOn, midiDefOff;

	*new {
		arg name, instrument = \default, mono = false;
		^super.new.init(name, instrument, mono);
	}

	init {
		arg argname, arginstrument, argmono;
		name = argname ? name;
		instrument = arginstrument ? instrument;
		mono = argmono ? mono;
		history = Array.fill(127, {[]});
		synths = Array.newClear(127);
		clock = TempoClock();
		events = [];
		paused = true;
		noteOn = false;
		pauseTime = 0.0;

		clock.permanent = true;

		MIDIIn.connectAll;

		midiDefOn = MIDIdef.noteOn('on_'++name, {
			arg val, num, chan, src;
			var event;
			if((synths[num] == nil).and(not(mono && noteOn)),{
				noteOn = true;
				if(not(paused), {
					event = (\instrument: instrument, \start: clock.beats, \midinote: num, \delta: 0);
					history[num] = history[num].add(event);
					if(not(events.isEmpty),{
						var last = events[events.size-1];
						last[\delta] = event[\start] - last[\start];

					});
					synths[num] = Synth(instrument, [\freq, num.midicps]);
					events = events.add(event);
				});
			});
		});

		//TODO: buggy if paused and one plays
		midiDefOff = MIDIdef.noteOff('off_'++name, {
			arg val, num, chan, src, event;
			if(synths[num] != nil, {  // to be absolute save
				noteOn = false;
				if(not(paused), {
					var event = history[num][history[num].size-1];
					event[\dur] = clock.beats - event[\start];
				});

				synths[num].set(\gate, 0);
				synths[num] = nil;
			});
		});
	}

	record {
		this.flush;
		paused = false;
		noteOn = false;
	}

	flush {
		history = Array.fill(127, {[]});
		synths.do({arg synth; synth.set(\gate, 0);});
		synths = Array.newClear(127);
		events = [];
	}

	resume {
		clock = TempoClock(beats: clock.beats-pauseTime);
		paused = false;
		pauseTime = 0.0;
	}

	pause {
		pauseTime = clock.beats;
		paused = true;
	}

	isRecording {
		^paused.not;
	}

	printOn { arg stream;
		stream << this.class.name << "(" <<<* [name, events]  <<")"
	}

	play {
		this.pause();
		Routine({
			events.do({|event|
				event.play;
				event[\delta].wait;
			});
		}).play(clock);
	}

	free {
		midiDefOn.free;
		midiDefOff.free;
	}
}