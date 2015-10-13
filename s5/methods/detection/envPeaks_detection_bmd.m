% Find peaks on envelope using MATLAB's built-in findpeaks() function
id   = 'envPeaks';
name = 'findpeaks() on envelope';
func = 'detectEnvPeaks';
extra.needTS  = false;
extra.needEnv = true;

params(1).ptype = 'app';
params(1).id    = 'percentile';
params(1).name  = 'Percentile';
params(1).value = 95;
params(1).dtype = 'double';

params(2).ptype = 'app';
params(2).id    = 'fixedThreshold';
params(2).name  = 'Fixed threshold (<value>/empty for "no")';
params(2).value = [];
params(2).dtype = 'double';

params(3).ptype = 'app';
params(3).id    = 'minimalDistance';
params(3).name  = 'Minimal distance between peaks (sec)';
params(3).value = 0.02;
params(3).dtype = 'double';