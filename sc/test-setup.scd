Utils.initTools(true);
p = Utils.initProxy(s);
p.clock.tempo = 1
("Setup.scd").loadRelative;

//start a basic kick drum pattern
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~k.play;

//start a basic snare pattern
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,1);
~sn.play;

//start a basic hi-hat pattern
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pwhite(0.2,1));
~h.play;

~arr = Array.new(2);
