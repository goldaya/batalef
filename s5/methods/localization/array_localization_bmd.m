% fixed array localization
id   = 'array';
name = 'Fixed Array';
func = 'locDiscreteArray';

i=1;
params(i).ptype = 'app';
params(i).id    = 'xRes';
params(i).name  = 'X Resolution (m)';
params(i).value = 0.1;
params(i).dtype = 'double';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'xLim';
params(i).name  = 'X Limits ([m,m])';
params(i).value = [-3,3];
params(i).dtype = 'vector';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'yRes';
params(i).name  = 'Y Resolution (m)';
params(i).value = 0.1;
params(i).dtype = 'double';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'yLim';
params(i).name  = 'Y Limits ([m,m])';
params(i).value = [-3,3];
params(i).dtype = 'vector';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'zRes';
params(i).name  = 'Z Resolution (m)';
params(i).value = 0.1;
params(i).dtype = 'double';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'zLim';
params(i).name  = 'Z Limits ([m,m])';
params(i).value = [-3,3];
params(i).dtype = 'vector';
