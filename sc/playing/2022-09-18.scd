Utils.loadSetup

p.clock.tempo = 1.5;
p.quant = 4;

~sound = {Resonz.ar(Pulse.ar(3, 0.3), Array.exprand(4, 120, 2500), 0.005).sum!2};
~sound.fadeTime = 4.0;
~sound.stop;

~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1);
~k.play;

~sn = Pbind(\instrument,\bplay,\buf,d[\s][0],\dur,2,\amp,1);
~sn.play;

~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,0.25,\amp,Pwhite(0.25,1));
~h.play

~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,0.75,\amp,1);
~c.play;

~oh = Pbind(\instrument,\bplay,\buf,d[\oh][0],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1);
~oh.play;

//Random rhythm with Pwhite
(
~sn = Pbind(\instrument,\bplay,\buf,d[\s][0],\dur,Pwhite(1,5.0),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,Pwhite(0.25,0.75),\amp,Pwhite(0.2,1));
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,Pwhite(0.75,2),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pwhite(1,5.0),\amp,1);
~sn.play;~h.play;~c.play;~t.play;
)
//even with a regular kickdrum the other rhythms don't sound good
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1);
~k.play
)

//same example but with all rhythms constrained
(
~sn = Pbind(\instrument,\bplay,\buf,d[\s][0],\dur,Pwhite(1,5.0).round(1),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,Pwhite(0.25,0.75).round(0.25),\amp,Pwhite(0.2,1));
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,Pwhite(0.75,2).round(0.75),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pwhite(1,5.0).round(0.5),\amp,1);
~sn.play;~h.play;~c.play;~t.play;
)
//sounds more palatable with everything arranged properly
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1);
~k.play;
)

(
~fx1 = Pbind(\instrument,\bplay,\buf,d[\sfx][0],\dur,Pwhite(1,5),\amp,1);
~fx2 = Pbind(\instrument,\bplay,\buf,d[\fx][0],\dur,Pwhite(1,10),\amp,1);
~fx3 = Pbind(\instrument,\bplay,\buf,d[\lfx][0],\dur,Pwhite(10,40),\amp,1);
~fx1.play;~fx2.play;~fx3.play;
)


//layering at different pitches - kicks
(
p.clock.tempo = 2.3;
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
~k.play;
)
//kicks at a different pitch. Evaluate this a few times to get different permutations
(
~k2 = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.8],inf)*4);
~k2.play;
)


//layering of slightly different rhythms
//rhythm 1
(
p.clock.tempo = 1.7;
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t.play;
)
//rhythm 2, using a different tom for contrast
//also re-evaluating rhythm 1 to get them playing together
(
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d[\t][1],\dur,Pseq([1,1,1,0.25],inf),\amp,1);
~t2.play;
)
//rhythm 3 for more
(
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d[\t][1],\dur,Pseq([1,1,1,0.25],inf),\amp,1);
~t3 = Pbind(\instrument,\bplay,\buf,d[\t][2],\dur,Pseq([1,1,1,0.75],inf),\amp,1);
~t3.play;
)
//kick underneath to illustrate
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1);
~oh = Pbind(\instrument,\bplay,\buf,d[\oh][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1,\rate,1);
~oh.play;
~k.play;
)



//complimentary rhythms:
//the 'polyrhythmic clap' from the Basics example
(
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,0.75,\amp,1);
~c.play;
)
//clap added at a similar rhythm (euclidean 3,8)
(
~c2 = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,Pbjorklund2(3,8)/4,\amp,1);
~c2.play;
)

//StageLimiter throttling
//a complex rhythm
(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
        0.25: [1,0.75,0.1,0.3,0.6,0.1],
        0.1: [0.5,1,2],
        2: [0.5,0.75,0.5,1]
        ), 4);
~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,l/2,\amp,1,\rate,2);
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l*2,\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,l,\amp,1,\rate,Pseq([1.2,1.4,1.7],inf));
~sn = Pbind(\instrument,\bplay,\buf,d[\s][0],\dur,l*4,\amp,1,\rate,0.8);
~ding = Pbind(\instrument,\bplay,\buf,d[\ding][0],\dur,Pwhite(1,5),\amp,1,\rate,0.2);
~h.play;~c.play;~t.play;~ding.play;~sn.play;
)
//extremely loud kick throttles everything else
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][2],\dur,4,\amp,100,\rate,0.5);
~k.play;
)

//trap(ish) hi-hats
//Has a choice of four rhythmic patterns with lesser chance for each, results in a mostly 0.25-duration hat which can potentially go quite quickly
(
p.clock.tempo = 75/60;
~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,Pwrand([0.25,Pseq([0.125],4),Pseq([0.25]/3,3),Pseq([0.125]/2,4)],[0.6,0.3,0.09,0.01],inf),\amp,1,\rate,2);
~h.play;
)



//four randomised euclidean rhythms with four different samples.
//sounds better, producing a much greater variety of rhythmic forms.
(
p.clock.tempo = 2.2;
~k = Pbind(\instrument,\bplay,\buf,d[\k][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d[\s][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d[\ch][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~k.play;
~sn.play;
~h.play;
~t.play;
)


//Complex rhythm that obfuscates the central rhythmic centre
(
p.clock.tempo = 1.5;
~h = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,Pbjorklund2(Pwhite(10,35),41,inf,Pwhite(0,10).asStream)/8,\amp,Pexprand(0.1,1),\pan,-1);
~h2 = Pbind(\instrument,\bplay,\buf,d[\ch][0],\dur,Pbjorklund2(Pwhite(10,35),40,inf,Pwhite(0,10).asStream)/8,\amp,Pexprand(0.1,1),\pan,1);
~sn = Pbind(\instrument,\bplay,\buf,d[\s][0],\dur,Pbjorklund2(Pwhite(1,5),Pwhite(1,32))/4,\amp,1,\rate,Pwrand([1,-1],[0.8,0.2],inf),\pos,Pkey(\rate).linlin(1,-1,0,0.999));
~ding = Pbind(\instrument,\bplay,\buf,d[\ding][0],\dur,Pbjorklund2(Pwhite(1,3),25)/4,\amp,0.6,\rate,0.6,\pan,-1);
~ding2 = Pbind(\instrument,\bplay,\buf,d[\ding][0],\dur,Pbjorklund2(Pwhite(1,3),20)/4,\amp,0.6,\rate,0.7,\pan,1);
~t1 = Pbind(\instrument,\bplay,\buf,d[\mt][0],\dur,Pbjorklund2(Pseq([1,1,1,Pwhite(10,15,1).asStream],inf),36,inf,Pwhite(0,2).asStream)/8,\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(Pseq([1,1,1,Pwhite(10,15,1).asStream],inf),40,inf,Pwhite(0,2).asStream)/8,\amp,1,\rate,2);
~t1.play;~t2.play;~h.play;~h2.play;~sn.play;~ding.play;~ding2.play;
)
//a slightly more rhythmic element, tracing the rhythm out a bit more
(
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,Scale.minor,\degree,Pwrand([0,4],[0.8,0.2],inf),\octave,Pwrand([2,3],[0.8,0.2],inf),\dur,0.125,\d,0.25,\a,Pexprand(0.0001,200),\pan,0,\amp,1);
~ring1.play;
)
//Add unce unce unce and simmer gently to unify flavours.
(
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,Scale.minor,\degree,Pwrand([0,4],[0.8,0.2],inf),\octave,Pwrand([2,3,4],[0.6,0.2,0.2],inf),\dur,0.125,\d,0.2,\a,Pexprand(0.02,900),\pan,0,\amp,1);
~k = Pbind(\instrument,\bplay,\buf,d[\k][1],\dur,0.5,\amp,2);
~k.play;
)
//offbeat hat because cheesy rhythms are good fun
(
~oh = Pbind(\instrument,\bplay,\buf,d[\oh][1],\dur,Pseq([0.5,Pseq([1],inf)],inf)/2,\amp,1)
~oh.play
)


//working with offsets - doing a lot with a little
//basic kick
(
p.clock.tempo = 2.13;
p.quant = 1;
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1);
~k.play;
)
//Basic 5-16 euclidean rhythm
(
~c = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7);
~c.play;
)
//add another layer at a different pitch
//NOTE: These two might not sound at the same time even though they are the same rhythm, as the rhythmic cycle is longer than 1 beat
(
~c2 = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7,\rate,1.1);
~c2.play;
)
//if you want them to sound together, trigger them together
(
~c2 = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7,\rate,1.1);
~c = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7);
)
//offset both
//Note: I am using .asStream here, because a standard Pwhite will not work in the offset argument of Pbjorklund2, as the values need to be embedded as a stream.
//A general rule of mine is that if pattern classes don't work properly, use .asStream on the end of them and they likely will.
(
~c = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16,inf,Pwhite(1,10).asStream)/4,\amp,0.7);
~c2 = Pbind(\instrument,\bplay,\buf,d[\t][0],\dur,Pbjorklund2(5,16,inf,Pwhite(1,15).asStream)/4,\amp,0.7,\rate,1.1);
~c.play;
~c2.play;
)
//and another, slightly different sample
(
~c3 = Pbind(\instrument,\bplay,\buf,d[\t][1],\dur,Pbjorklund2(5,16,inf,Pwhite(0,8).asStream)/4,\amp,0.7,\rate,0.9);
~c3.play
)
//now do the same to the kick
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][2],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
)
//another kick, slightly different rhythm
(
~k2 = Pbind(\instrument,\bplay,\buf,d[\k][2],\dur,Pbjorklund2(3,16,inf,Pwhite(1,10).asStream)/4,\amp,1,\rate,Pseq([1.1,1.4],inf));
~k2.play;
)
//add sub kick on 1, and you have minimal techno.
(
~sk = Pbind(\instrument,\bplay,\buf,d[\sk][0],\dur,1,\amp,2);
~sk.play;
)


//give a central rhythm to be used by other patterns
l = Pbjorklund2(Pseq([3,3,3,4,3,3,3,5],inf),8)/4;
//block-execute (Ctrl/Cmd+Enter) between these brackets
(
p.clock.tempo = 2.1;
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1,\rate,0.9);
~c3 = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1,\rate,1.1);
~c2 = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1);
~c.play;
~c2.play;
~c3.play;
)
//now individually execute (Shift+Enter) some of these lines to refresh the 'dur'. Listen for variations in rhythm.
~c = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1,\rate,0.9);
~c3 = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1,\rate,1.1);
~c2 = Pbind(\instrument,\bplay,\buf,d[\c][0],\dur,l,\amp,1);
//if you want to reset, execute the block again







