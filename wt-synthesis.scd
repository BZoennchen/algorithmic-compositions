// WT-Synthesis


// (1) Env
(
var env, signal, wt;

// free the prev-buffer
~buffEnv.free;

// (1.1) create your desired wave
env = Env.rand(numSegs: 16, dur: 1, bipolar: true);
signal = env.asSignal(1024);

// (1.2) transform the wave into wave table format.
wt = signal.asWavetable;

// (1.3) load the wave table into a (server) buffer
~buffEnv = Buffer.alloc(s, 2048);
~buffEnv.loadCollection(wt);

// (1.4) play your wave table
{Osc.ar(~buffEnv, 200) * EnvGen.ar(Env.perc(2, 3)) * 0.2!2}.play
)



// (2) Signal filled with sine waves i.e. a sum of sine waves
(
var signal, wt, amps;

// free the prev-buffer
~buffSigSines.free;

// (2.1) create your desired wave, here it is a Saw tooth wave
amps = 16.collect({arg k; (2.0 / pi) * (-1).pow(k) / (k+1)});
signal = Signal.sineFill(1024,amps);

// (2.2) transform the wave into wave table format.
wt = signal.asWavetable;

// (2.3) load the wave table into a (server) buffer
~buffSigSines = Buffer.alloc(s, 2048);
~buffSigSines.loadCollection(wt);

//~buffSig.sine2, ~buffSig.sine3 can also be used!

// (2.4) play your wave table
{Osc.ar(~buffSigSines, 200) * EnvGen.ar(Env.perc(2, 3)) * 0.2!2}.play
)

// (3) Signal
(
var signal, wt;

// free the prev-buffer
~buffSigFilled.free;

// (3.1) create an empty (all zeros) signal of fixed size
signal = Signal.newClear(1024);

// (3.2) construct your signal i.e. fill it with values other than 0
signal.waveFill({
	arg x, old, i; // x is [0;1) by default we change it here to [0;2pi)
	(sin(x.pow(1.3)) * 1.5).fold(-1,1);
}, 0, 2pi);

//signal.plot;

// (3.3) transform the wave into wave table format.
wt = signal.asWavetable;

// (3.4) load the wave table into a (server) buffer
~buffSigFilled = Buffer.alloc(s, 2048);
~buffSigFilled.loadCollection(wt);

// (3.5) play your wave table
{Osc.ar(~buffSigFilled, 200) * EnvGen.ar(Env.perc(2, 3)) * 0.2!2}.play
)














