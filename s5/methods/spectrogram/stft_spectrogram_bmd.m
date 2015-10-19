id   = 'stft';
name = 'STFT';
func = 'somSTFT';
params(1).ptype = 'app';
params(1).id    = 'window';
params(1).name  = 'Window Size';
params(1).value = 30;
params(1).dtype = 'integer';

params(2).ptype = 'app';
params(2).id    = 'overlap';
params(2).name  = 'Overlap';
params(2).value = 7;
params(2).dtype = 'integer';

params(3).ptype = 'app';
params(3).id    = 'nfft';
params(3).name  = 'NFFT';
params(3).value = 512;
params(3).dtype = 'integer';
