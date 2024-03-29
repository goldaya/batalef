function [ channelOut ] = updateChannelStructure( channelIn, Fs )
%UPDATECHANNELSTRUCTURE -INTERNAL- update the channel structure to current

    % channel calls cell array
    if isfield(channelIn,'channelCalls')
        M = cell2mat(channelIn.channelCalls(:,[1:11,14:16]));
        calls.detection = [M(:,1)./Fs,M(:,2)];
        calls.features  = zeros(size(M,1),13);
        calls.features(:, 1) = M(:, 6)./Fs;  % start time
        calls.features(:, 2) = M(:, 7) ;     % start value
        calls.features(:, 3) = M(:, 8) ;     % start freq
        calls.features(:, 4) = M(:,12) ;     % start power
        
        calls.features(:, 5) = M(:, 3)./Fs;  % peak time
        calls.features(:, 6) = M(:, 4) ;     % peak value
        calls.features(:, 7) = M(:, 5) ;     % peak freq
        calls.features(:, 8) = M(:,13) ;     % peak power

        calls.features(:, 9) = M(:, 9)./Fs;  % end time
        calls.features(:,10) = M(:,10) ;     % end value
        calls.features(:,11) = M(:,11) ;     % end freq
        calls.features(:,12) = M(:,14) ;     % end power
        
        calls.features = num2cell(calls.features);
        
        calls.features(:,13) = channelIn.channelCalls(:,13) ;     % ridge
        emptyCell = num2cell(zeros(size(M,1),13));
        emptyCell(:,13) = {[]};
        calls.forLocalization = emptyCell;
        calls.forBeam = emptyCell;
        
        channelOut.calls = calls;
        
    else
        channelOut = channelIn;
    end
    
    % points of intereste
    if isfield(channelIn,'pois')
        channelOut.pois = channelIn.pois;
    else
        channelOut.pois = [];
    end

end

