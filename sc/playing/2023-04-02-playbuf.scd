b = Buffer.read(s, "../samples/experimental/waterboiler.WAV".resolveRelative);

b.play
b.query

(
SynthDef(\playbuff, {
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
K2A
b.query

Synth(\playbuff, [buf: b.bufnum, rate: 1, pos: b.sampleRate * 160, atk: 1.0, rel: 1.0]);

Synth(\playbuff, [buf: b.bufnum, rate: 4, pos: b.sampleRate * 160, atk: 1.0, rel: 1.0]);

(
fork {
	300.do {
		var rates = [1, 3, 4, 6, 10], durs = [1/4, 1/8, 1/8, 1/2, 1] / 16;
		Synth(\playbuff, [
			buf: b.bufnum,
			rate: rates.choose,
			pos: b.sampleRate * rrand(140, 160),
			atk: 0.01,
			rel: 0.05]
		);
		durs.choose.wait;
	}
};
)

BufFrames
BufDur

{BufRd.ar(1, b.bufnum, K2A.ar(MouseX.kr(0, 40*48000.0)))}.play
(
{
	var len = 4, start = 30, rate = 0.5, srate = b.sampleRate, dur = len/rate, env;
    env = EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: dur, gate: Impulse.kr(1/dur));
	BufRd.ar(
		numChannels: 2,
		bufnum: b,
		phase: SinOsc.ar(1/dur).range(start, start+len) * srate
	) * env;
}.play
)

(10/4).reciprocal

(
[-3,0,2].do { |n|
	Synth(\playbuff, [
	buf: b.bufnum,
	rate: n.midiratio,
	pos: b.sampleRate * 160,
	atk: 1.1,
	rel: 1.1
]);
}


)

8645952 / 48000.0