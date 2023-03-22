s.boot;
NetAddr.langPort; // default is 57120

// init synth
(
SynthDef(\sine_sum, {
    var sig, harmonics, amps, phases;

    harmonics = [1, 3, 5, 6, 7, 8, 9];
    phases = [0, 0, 0, 0.5, 0.25, 0, 0] * 2*pi;
    amps = [0.5, 0.3, 0.2, 0.2, 0.1, 0.1, 0.1].normalizeSum();

    sig = harmonics.collect({ arg k, index;
        var env = EnvGen.ar(Env.asr(
            attackTime: \attk.kr(0.01) * Rand(0.8,1.2),
			releaseTime: \rel.kr(3.0) * Rand(0.9,1.1) * k.linexp(1, 9, 1.0, 0.7),
			curve: \curve.kr(-4)), gate: \gate.kr(1)
        );

        var vibrato = LFNoise1.ar(\detuneFreq.kr(5)!harmonics.size).bipolar(\detune.kr(0.1)).midiratio;
        var harmonicFreq = \freq.kr(220) * vibrato * k;
        amps[index] * SinOsc.ar(harmonicFreq, phases[index]) / k * env.pow(1+((k-1)/3));
    }).sum;

    sig = LPF.ar(sig, 4*\freq.kr(220));
    sig = sig * \amp.kr(0.5);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(0, sig);
}).add;
)

// init osc
(
var melodyGenerator, synth, tempo, recorder, sendMessage, encodingToEvents, eventToEncoding, events, sendMelody, minDur = 0.25, amp = 1.0;

melodyGenerator = NetAddr("localhost", 6449);
synth = \sine_sum;
recorder = MIDIRecorder(\rec, synth, mono: true, amp: 1.0);

sendMelody = {
	arg seed;
	melodyGenerator.sendMsg('/rnn/input', seed);
};

encodingToEvents = {
	// [60, "_", "_", "_"] -> p = 60, d = 1.0
	arg melody;
	var minDuration = 0.25, pivot = nil, count = 0, events = [], event = nil, toMidi;

	toMidi = {
		arg char;
		if(char == 'r', {\r}, {char.asInteger})
	};

	melody.do({
		arg item, i;
		count = count + 1;
		if(pivot != nil, {
			//if(pivot != item, {
			if(item != '_', {
				event = (
					\sustain: minDuration*(count),
					\dur: minDuration*(count),
					\midinote: toMidi.(pivot),
					\instrument: synth,
					\amp: amp);
				count = 0;
				pivot = item;
				events = events.add(event);
			});
			//});
		},{
			pivot = item;
			count = 0;
		});
	});

	event = (
		\sustain: minDuration*(count+1),
		\dur: minDuration*(count+1),
		\midinote: toMidi.(pivot),
		\instrument: synth,
		\amp: amp);
	events = events.add(event);
	events;
};

eventToEncoding = {
	arg events;
	var encoding = "", result = "", time = 0, minRestDur = 0.5, rests;
	// (1) filter bad events
	events = events.select({|event| event.sustain.isFloat});
	minDur = events.collect({|event| event.sustain}).minItem;
	//minDur = [minDur, minRestDur].minItem;
	//minRestDur = [minDur, 0.25].maxItem;

	rests = events.collect { |event|
		var rest;
		rest = event.start - time;
		time = event.start + event.sustain;
		rest;
	};

	("rests: " ++ rests).postln;
	("minRestDur: " ++ minRestDur).postln;
	("minDur: " ++ minDur).postln;
	//events.postln;

	events.do { |event, i|
		var durmsg = "";
		//event.sustain.postln;
		(event.sustain / minDur).asInteger.do {
			durmsg = durmsg ++ "_ "
		};
		encoding = encoding ++ event.midinote ++ " " ++ durmsg;

		if(i < (rests.size-1), {
			if(rests[i+1] >= minRestDur, {
				(rests[i+1] / minDur).asInteger.do {
					durmsg = durmsg ++ "_ "
				};
				encoding = encoding ++ "r" ++ " " ++ durmsg;
			});
		});
	};

	encoding.do { |char,i|
		if(i < (encoding.size-1), {result = result ++ char;});
	};
	result
};

MIDIdef.cc('record', {
	arg val;
	//val.postln;
	if(val == 127, {
		if(recorder.isRecording, {
			recorder.pause;
			("sending: " ++ eventToEncoding.(recorder.events)).postln;
			sendMelody.(eventToEncoding.(recorder.events));
			recorder.flush;
		}, {
			recorder.record;
			"recording ...".postln;
		});
	});
});

OSCdef(
    \getMelody,
    {
        arg val; val.postln;
		tempo = TempoClock(0.25/minDur);
		Routine({
			events = encodingToEvents.(val);
			events.do({ |event, i|
				event.play;
				event.dur.wait;
			});
		}).play(tempo);
    },
    '/sc/input',
    recvPort: 6448
);
)

