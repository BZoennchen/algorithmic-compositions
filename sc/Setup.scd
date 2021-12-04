(
Task({
	var synthpath, snippetpath, samplepath;

	synthpath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./synths");
	snippetpath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./snippets");
	samplepath = PathName(thisProcess.nowExecutingPath.dirname +/+ "./samples/set1");

	// load all my personal snippets.
	for(0, snippetpath.entries.size-1,{ arg i; (snippetpath.entries[i].fullPath).load;});
	"init personal snippets!".postln;

	// load all my personal synths.
	for(0, synthpath.entries.size-1,{ arg i; (synthpath.entries[i].fullPath).load;});
	"init personal synths!".postln;

	3.wait;
	d = Dictionary.new;
	d.add(\foldernames -> samplepath.entries);
	for (0, d[\foldernames].size-1,
		{arg i; d.add(d[\foldernames][i].folderName -> d[\foldernames][i].entries.collect({
					arg sf;
					Buffer.read(s,sf.fullPath);
				});
		)});
		//wait, because otherwise it won't work for some reason
		3.wait;
		"init samples!".postln;
}).start;
)