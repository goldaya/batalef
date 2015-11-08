% basic matching 
id   = 'basic';
name = 'Basic';
func = 'matchingBasic';

i=1;
params(i).ptype = 'app';
params(i).id    = 'error';
params(i).name  = 'Allowed Error (%)';
params(i).value = 10;
params(i).dtype = 'double';

i=i+1;
params(i).ptype = 'app';
params(i).id    = 'time';
params(i).name  = 'Time Point [Start\Peak\End]';
params(i).value = 'Start';
params(i).dtype = 'string';