function tan(x) {
	return(sin(x) / cos(x))
}

function min(x, y) {
	if (x < y) return(x)
	else return(y)
}

function calculateThreadlibSpecs() {
	Designator = $2;
	P = $3;
	H = P / 2 / tan(phi / 2);
	DPitchExt = ($7 + $8) / 2;
	DSupportExt = ($9 + $10) / 2;
	DValleyExt = $10;
	DCrestExt = ($5 + $6) / 2;
	ZValleyExt = (DPitchExt + H - DValleyExt) / 2 * tan(phi / 2); 
	ZCrestExt = (DPitchExt + H - DCrestExt) / 2 * tan(phi / 2);

	DPitchInt = ($14 + $15) / 2;
	DSupportInt = ($16 + $17) / 2;
	DValleyInt = $17;
	DCrestInt = $13;
	# for some reason, the data sometimes has dRMax > H. We have to fix this:
	dRMax = min((DValleyInt - DPitchInt + H) / 2, 0.99 * H);
	DValleyInt = DPitchInt - H + 2 * dRMax;
	# now, continue as usual
	ZValleyInt = dRMax * tan(phi / 2);
	ZCrestInt = (DCrestInt - DPitchInt + H) / 2 * tan(phi / 2);
}

BEGIN {
	FS = "\t";
	pi = atan2(0, -1);
	deg = pi / 180;
	phi = 30 * deg;
}

/^[^#]/ {
	calculateThreadlibSpecs();

	# External thread:
	printf	Designator "-ext,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", DValleyExt / 2		# Rrot
	printf	"%.4f,", DSupportExt			# Dsupport
	printf	0 ","					# r0
	printf	"%.4f,", -ZValleyExt			# z0
	printf	0 ","					# r1
	printf	"%.4f,", +ZValleyExt			# z1
	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r2
	printf	"%.4f,", +ZCrestExt			# z2
	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r3
	printf	"%.4f\n", -ZCrestExt;			# z3

	# Internal thread:
	printf	Designator "-int,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", -DValleyInt / 2		# Rrot
	printf	"%.4f,", DSupportInt			# Dsupport
	printf	0 ","					# r0
	printf	"%.4f,", +ZValleyInt			# z0
	printf	0 ","					# r1
	printf	"%.4f,", -ZValleyInt			# z1
	printf	"%.4f,", -(DCrestInt - DValleyInt) / 2	# r2
	printf	"%.4f,", -ZCrestInt			# z2
	printf	"%.4f,", -(DCrestInt - DValleyInt) / 2	# r3
	printf	"%.4f\n", +ZCrestInt;			# z3
}

