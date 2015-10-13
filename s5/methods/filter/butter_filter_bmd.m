% butter filter method definition
id   = 'butter';
name = 'Butterworth';
func = 'filterButter';
params(1).ptype = 'app';
params(1).id    = 'type';
params(1).name  = 'Filter Type (lowpass/highpass/bandpass/bandstop)';
params(1).value = 'lowpass';
params(1).dtype = 'string';

params(2).ptype = 'app';
params(2).id    = 'f1';
params(2).name  = 'Freq. 1 (Hz)';
params(2).value = 40000;
params(2).dtype = 'double';

params(3).ptype = 'app';
params(3).id    = 'f2';
params(3).name  = 'Freq. 2 (Hz)';
params(3).value = 70000;
params(3).dtype = 'double';

params(4).ptype = 'app';
params(4).id    = 'order';
params(4).name  = 'Order (odd integer for low/highpass, even for band pass/stop)';
params(4).value = 3;
params(4).dtype = 'integer';

