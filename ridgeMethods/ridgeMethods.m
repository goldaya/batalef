% put a method in each cell of m.
% m{i} = {Name, Function name , parameters}
% Name :            will appear on the method selection menu
% function name :   please start with 'sum', e.g. sumFFT, and keep in the
% spectrogramMethod folder. Function must accept [TimeSignal, Fs, params (as struct)];
% parameters:       cell array of format {name, text to show on dialog, def value}. a dialog will appear
% once when this method is selected. The user's input will be kept and sent
% to the method function as a structure, with fields names like the
% parameters names
% 

m{1} = {'Basic','rdgmBasic', ...
        {...
        {'Finterval','Search Interval ( Hz )','ridge:basic:finterval'},...
        {'specWindow','Spectrogram: Window','ridge:basic:specWindow'},...
        {'specOverlap','Spectrogram: Overlap','ridge:basic:specOverlap'},...
        {'specNfft','Spectrogram: NFFT','ridge:basic:specNfft'}...
        }};

