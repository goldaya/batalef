function [ output_args ] = pdgFcOnSeqSelection(  )
%PDGFCONSEQSELECTION Summary of this function goes here
%   Detailed explanation goes here

    global pdg;
    
    handles = pdgGetHandles();
    seqs = get(handles.ddSeqs, 'UserData');
    if isempty(seqs)
        return;
    end
    selectedSeq = seqs{get(handles.ddSeqs, 'Value')};
    
    % nothing implemented yet
    return;
    
    % approximate time and location
    channelCallsTimes = seqChannelCallsTimes( pdg.k, selectedSeq );
    [t, x] = approxCallTimeLocation( channelCallsTimes, fileData(pdg.k, 'Mics'));
    

end

