% basic ridge
id   = 'basic';
name = 'Basic';
func = 'rdgmBasic';

params(1).ptype = 'app';
params(1).id    = 'fInterval';
params(1).name  = 'Search Interval ( Hz )';
params(1).value = '10000';
params(1).dtype = 'double';

params(2).ptype = 'app';
params(2).id    = 'startPoint';
params(2).name  = 'Start Point [Start/Peak]';
params(2).value = 'Peak';
params(2).dtype = 'string';

params(3).ptype = 'app';
params(3).id    = 'useInternalSpectrogram';
params(3).name  = 'Recompute spectrogram ( STFT ) ? [ Yes / No ]';
params(3).value = 'No';
params(3).dtype = 'string';

params(4).ptype = 'app';
params(4).id    = 'internalSpecWindow';
params(4).name  = 'STFT Window  (samples)';
params(4).value = 300;
params(4).dtype = 'integer';

params(5).ptype = 'app';
params(5).id    = 'internalSpecOverlap';
params(5).name  = 'STFT Overlap (samples)';
params(5).value = 75;
params(5).dtype = 'integer';

params(6).ptype = 'app';
params(6).id    = 'internalSpecNfft';
params(6).name  = 'STFT nfft (samples)';
params(6).value = 512;
params(6).dtype = 'integer';
