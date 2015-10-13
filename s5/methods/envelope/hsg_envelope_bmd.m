% Hilbert Savitzky Golay envelope definition
id   = 'HSG';
name = 'Hilbert Savitzky Golay';
func = 'envHSG';

params(1).ptype = 'app';
params(1).id    = 'rank';
params(1).name  = 'S-G filter rank';
params(1).value = 3;
params(1).dtype = 'integer';

params(2).ptype = 'app';
params(2).id    = 'minWindow';
params(2).name  = 'Minimal window size (samples)';
params(2).value = 21;
params(2).dtype = 'double';

params(3).ptype = 'app';
params(3).id    = 'maxWindow';
params(3).name  = 'Maximal window size (samples)';
params(3).value = 201;
params(3).dtype = 'double';

params(4).ptype = 'app';
params(4).id    = 'windowsNumber';
params(4).name  = 'Number of windows';
params(4).value = 2500;
params(4).dtype = 'double';

