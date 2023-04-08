b = Buffer.read(s, "../samples/experimental/waterboiler.WAV".resolveRelative);

b.play
b.query

(
SynthDef(\play, {
	var sig, env;

	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: \buf.kr(0),
		rate: BufRateScale.kr(\buf.kr(0)) * \rate.kr(1.0),
		startPos: \pos.kr(0.0)
	);

	env = EnvGen.kr(Env([0, 1, 0], [\atk.ir(0.02), \rel.ir(3)], [-2, -4]), doneAction: Done.freeSelf);

	sig = sig * env;
	sig = sig * \amp.kr(1);

	Out.ar(\out.kr(0), sig);
}).add;
)

b.query

(
[-3,0,2].do { |n|
	Synth(\play, [
	buf: b.bufnum,
	rate: n.midiratio,
	pos: b.sampleRate * 160,
	atk: 1.1,
	rel: 1.1
]);
}


)

8645952 / 48000.0