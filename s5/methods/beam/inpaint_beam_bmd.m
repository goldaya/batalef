% inpaint surface fitting
id   = 'inpaint';
name = 'Surface Fitting';
func = 'beamInpaint';
i = 0;

%{
i = i + 1 ;
params(i).ptype = 'app';
params(i).id    = 'type';
params(i).name  = 'Filter Type (lowpass/highpass/bandpass/bandstop)';
params(i).value = 'lowpass';
params(i).dtype = 'string';

i = i + 1 ;
params(i).ptype = 'app';
params(i).id    = 'f1';
params(i).name  = 'Freq. 1 (Hz)';
params(i).value = 40000;
params(i).dtype = 'double';

i = i + 1 ;
params(i).ptype = 'app';
params(i).id    = 'f2';
params(i).name  = 'Freq. 2 (Hz)';
params(i).value = 70000;
params(i).dtype = 'double';

i = i + 1 ;
params(i).ptype = 'app';
params(i).id    = 'order';
params(i).name  = 'Order (odd integer for low/highpass, even for band pass/stop)';
params(i).value = 3;
params(i).dtype = 'integer';
%}