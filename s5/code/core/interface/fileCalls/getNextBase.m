function [ j,s ] = getNextBase( fobj, currBaseChannel, currBaseCall )
%GETNEXTBASE Get the next base channel & call

    % init values
    j = currBaseChannel;
    s = currBaseCall;
    U = fobj.MicData.UseInLocalization;
    
    % loop through all channels (starting with current) and stop at first
    % usable base call
    for i = currBaseChannel : currBaseChannel+fobj.ChannelsCount
        s = s + 1;
        
        % get the right channel index, and check that it is used for
        % lozalization
        j = mod(i,fobj.ChannelsCount);
        if j == 0
            j = fobj.ChannelsCount;
        end
        if ~U(j)
            continue;
        end
        

        % unmatched calls has NaN in the file calls vector:
        cfc = fobj.getChannelFileCalls(j);
        f = find(isnan(cfc));
        S = f(f>=s);

        % a NaN call is an unmatched call and can be used as base
        if ~isempty(S)
            s = S(1);
            break;
        end
        
        % if we got to here, there are no usable base calls in this
        % channel. Clean output indexes, so if thos is the last loop round
        % the output will be zeros. (If its not the last round, then its
        % still ok since j,s are computed at each round.)
        j = 0;
        s = 0;
    end
        

end

