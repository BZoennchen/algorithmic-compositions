s.boot;


NetAddr.langPort;



(
SynthDef(\fireworks,{
	var sig;
	sig = Dust.ar([\density.kr(3), \density.kr(3)-0.5]);
	sig = Ringz.ar(sig, freq: \freq.kr(300), decaytime: 0.1) * 0.55;
	sig = FreeVerb.ar(sig, 0.6, 0.9, 0.8);
	sig = LPF.ar(in: sig, freq: \cutofffreq.kr(21000));
	Out.ar(0, sig);
}).add;
)

~fireworks = Synth(\test);

(
OSCdef(
	\getCoords,
	{
		arg val; var x, y;
		x = val[1];
		y = val[2];
		~fireworks.set(\density, x.linlin(0, 650, 0.6, 10));
		~fireworks.set(\freq, y.linlin(0, 460, 100, 600));
	},
	'/wek/inputs',
	recvPort: 6448
);
)


(
OSCdef(\self, {arg val; val.postln;},'/self');
)

~me = NetAddr("localhost", NetAddr.langPort);
~me.sendMsg('\self', 42);


({
	var amp;
	amp = SinOsc.ar(0.25).range(0,1);
	SendReply.kr(Impulse.kr(30), '/amp', amp);
	WhiteNoise.ar(0.2!2) * amp;
}.play;
)

(
OSCdef(\self, {arg val; val.postln;},'/amp');
)










