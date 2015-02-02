function [  ] = pdgInitFileCallsTab(  )
%PDGINITFILECALLSTAB Summary of this function goes here
%   Detailed explanation goes here

    global pdg;
    handles = pdgGetHandles();
    
    P = fileData(pdg.k,'Mics');
    if isempty(P)
        pdgClearMicPositions();
    else
        set(handles.tabMicPositions, 'Data', P);
    end
    
    n = fileData(pdg.k, 'nChannels');
    set(handles.ddBaseChannel, 'String', 1:n);
    
end

