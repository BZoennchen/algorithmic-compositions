
// shortcuts
// cmd + d, for help
// cmd + shift d, for help without knowing
// cmd + ., stop all sound

// A function
{arg input1, input2; input1+input2}.value(1,2);

// boot server
Server.local.boot;
s.boot;
Server.local.quit;
s.quit;

// server tools
s.makeWindow
s.meter;
s.scope;
FreqScope.new;
s.plotTree;

// play a function
~sine = { SinOsc.ar }.play;
~sine.free;

// duplicate
a = [1,2,3,4,5,6]
a!2 // == a.dup(2)

~sine = { SinOsc.ar(300, 0, 1, 0) }.plot(1.0/300.1);

/////////////////////// additive synthesis ///////////////
(
~sum = {
	var sig;
	sig = SinOsc.ar(400, mul:0.2);
	sig = sig + SinOsc.ar(250, mul:0.3);
	sig = sig + SinOsc.ar(1000, mul:0.07);
}.play;
)

/////////////////// modulation /////////////
(
~vib = {
	var sig, vib;
	vib = SinOsc.ar(6, 0, 20, 300);
	sig = SinOsc.ar(vib,mul:0.2)!2;
}.play;
)

(
~vib = {
	var sig, vib;
	vib = SinOsc.ar(6).range(280,320);
	sig = SinOsc.ar(vib,mul:0.2)!2;
}.play;
)

(
{
	var sig, mod;
	mod = LFSaw.ar(1).range(0, 500);
	sig = Pulse.ar(200+mod, 0.5, 0.1)!2;
}.play;
)

x = {SinOsc.ar([300,302]) * 0.2}.play;
y = {SinOsc.ar([400,402.5]) * 0.2}.play;
z = {SinOsc.ar([250,250.5]) * 0.2}.play;














