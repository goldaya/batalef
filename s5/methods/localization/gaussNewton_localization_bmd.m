% Gauss Newton localization
id   = 'gaussNewton';
name = 'Gauss Newton';
func = 'locGaussNewton';

i=1;
params(i).ptype = 'app';
params(i).id    = 'accuracy';
params(i).name  = 'Accuracy (error)';
params(i).value = 0.01;
params(i).dtype = 'double';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'maxn';
params(i).name  = 'Maximum iterations (integer)';
params(i).value = 1000;
params(i).dtype = 'integer';

% i=i+1;
% params(i).ptype = 'app';
% params(i).id    = 'x0method';
% params(i).name  = 'x0 method to use [mlat\array]';
% params(i).value = 'mlat';
% params(i).dtype = 'string';