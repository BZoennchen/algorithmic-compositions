s.boot;

(
~size = 2048;
~sig = Signal.sineFill(
	~size,
	[1, 0, 0.5, 0, 0.5, 0.25, 0, 0.1],
	[0, 0, pi/2, 0, pi, 0, 0, pi]
);
)

~sig.plot();

(
~imag = Signal.newClear(~size);
~cosTable = Signal.fftCosTable(~size);
~complex = fft(~sig, ~imag, ~cosTable);
)

(

plot([
	~complex.magnitude[0..15],
	~complex.phase[0..15]
]).plotMode_(\bars);


)