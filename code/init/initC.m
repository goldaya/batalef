function [  ] = initC(  )
%INITC Initialize the constants structure

    global c;
    c = struct;
    c.never         = -1;
    c.no            = 0;
    c.yes           = 1;
    c.always        = 3;
    c.ask           = 4;

    % data load density
    c.load          = 1;
    c.loadIfMust    = 0;
    c.dontLoad      = -1;

    % calls gui show values
    c.saved         = 5;
    c.calculated    = 6;
    c.mix           = 7;

    % main gui axes mode
    c.link = 1;
    c.keep = 2;
    c.tight = 3;
    %
    c.numbered      = 8;

    % methods
    c.custom        = 12;
    c.hilbert       = 11; % envelope
    c.stft          = 13; % spectral
    c.butter        = 14; % filter
    c.function      = 15; % use user's function
    c.builder       = 16; % filter using ilterbuilder

    % butter filter types
    c.lowPass       = 100;
    c.highPass      = 101;
    c.bandPass      = 102;
    c.bandStop      = 103;
    
end

