s.boot;

(
var synth, recorder;

synth = \default;
recorder = MIDIRecorder(\rec, synth, amp: 1.0);

MIDIdef.cc('record', {
	arg val;
	//val.postln;
	if(val == 127, {
		if(recorder.isRecording, {
			recorder.pause;
			"start playing: " ++ recorder.postln;
			recorder.play;
			"clear recording".postln;
			recorder.flush;
		}, {
			recorder.record;
			"recording ...".postln;
		});
	});
});
)


