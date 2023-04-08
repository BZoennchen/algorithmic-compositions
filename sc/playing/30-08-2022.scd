p = ProxySpace.push(s);

n = 16;

~clock = {Impulse.ar(n)}
~clock.play;

~beat = {Stepper.ar(~clock, min: 0, max: n)}
~beat.play;

~trigger1 = {PulseCount.ar(~clock);}

~env = {Linen.kr(gate: ~beat, doneAction: Done.none, releaseTime: 0.1);}


~bleep = {SinOsc.ar(TChoose.kr(~trigger1, [300, 350, 600, 500]))!2 * 0.5 * ~env;}
~bleep.play;

(
Tdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
Tdef(\b, { |e| 100.do { |i| Tdef(\a).set(\otto, 8.rand); exprand(0.1, 3.0).wait } });
t = TdefAllGui(8);
)

Trig