function [  ] = bmgReadData(  )
%BMGREADDATA Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    beam = fileCallData(1,1,'Beam','All');
    U  = beam.micsUsed;
    A  = beam.micDirections(:,1);
    E  = beam.micDirections(:,2);
    Pm = beam.powerRaw;
    Pg = beam.powerAfterGain;
    Pd = beam.powerAfterDirect;
    Ps = beam.power;
    
    M = [A E Pm Pg Pd Ps];
    D(:,1) = num2cell(U);
    D(:,2:7) = num2cell(M);
    
    uithings = guidata(control.bmg.fig);
    set(uithings.uitabBeamData,'Data',D);

end

