ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;
Buffer.freeAll;

s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;

p = ProxySpace.push(s);
p.makeTempoClock;
p.clock.tempo_(96/60);
p.fadeTime_(2.5);
p.quant_(2.5);

s.waitForBoot({
	var synthpath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./synths");
	var snippetpath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./snippets");
	var samplepath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./samples/set1");

	// (1) load samples into buffers.
	d = Dictionary();
	d.add(\folders -> samplepath.entries);
	for(0, d[\folders].size-1, {arg i;
		var buffers = d[\folders][i].entries.collect({arg file; Buffer.read(s, file.fullPath);});
		d.add(d[\folders][i].folderName.asSymbol -> buffers);
		("load samples " ++ d[\folders][i].entries.size ++ " from " ++ d[\folders][i].folderName.asString).postln;
	});
	s.sync;
	"init samples!".postln;

	// (2) load all my personal snippets.
	for(0, snippetpath.entries.size-1,{ arg i;
		(snippetpath.entries[i].fullPath).load;
		("load snippet in " ++ snippetpath.entries[i].fullPath.asString).postln;
	});
	s.sync;
	"init personal snippets!".postln;

	// (3) load all my personal synths.
	for(0, synthpath.entries.size-1,{ arg i;
		(synthpath.entries[i].fullPath).load;
		("load synths in " ++ synthpath.entries[i].fullPath.asString).postln;
	});
	s.sync;
	"init personal synths!".postln;

	StageLimiter.activate;
	s.sync;
	s.freeAll;
});