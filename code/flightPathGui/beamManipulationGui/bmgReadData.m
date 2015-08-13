function [  ] = bmgReadData(  )
%BMGREADDATA Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    beam = fileCallData(control.bmg.k,control.bmg.a,'Beam','All');
    U  = beam.micsUsed;
%     A  = beam.micDirections(:,1);
%     E  = beam.micDirections(:,2);
%     Pm = beam.powerRaw;
%     Pg = beam.powerAfterGain;
%     Pd = beam.powerAfterDirect;
%     Ps = beam.power;
%     
%     M = [A E Pm Pg Pd Ps];

    M = beam.powers;
    M = M(:,[1,2,3,10,11,12]);
    D = [num2cell(U),num2cell(M)];
    uithings = guidata(control.bmg.fig);
    set(uithings.uitabBeamData,'Data',D);

end