function [ S,T,O ] = matchingBasic( fileObject,j,s,params )
%MATCHINGBASIC Matching: Basic
    
    S = [];
    T = [];
    O = {};
    
    baseCall = fileObject.channel(j).call(s);
    baseCall.loadCall('forLocalization');
    m = fileObject.MicData;
    nChannels = fileObject.ChannelsCount;
    dev = 1 + params.error/100;
    M = m.Positions;
    sonic = agetParam('defaultSoundSpeed');
    
    U = m.UseInLocalization;
    if ~U(j)
        return; % base channel is not used in localization... pointless
    else
        U(j) = false; % will use U for looping through non base channels
    end
    
    A = zeros(nChannels,2);
    A(j,:) = [s,baseCall.(params.time).Time];
    
    for i = 1:nChannels
        if U(i)
            % find closest mic which was already added to X
            Y = find(A(:,1));
            Mi = M(Y,:) - ones(size(Y))*M(i,:);
            [dX,l] = max(sqrt(sum(Mi.^2,2)));
            Ji = Y(l);
            
            % get calls possibel for the matched call in channel Ji
            dT = (dX*dev)/sonic;
            timeInterval = A(Ji,2)+[-dT,+dT];
            CHi = fileObject.channel(i);
            [Ii,Ti] = CHi.getCalls('Index','Time','Type','forLocalization','TimePoint',params.time,'TimeInterval',timeInterval);
            
            % find the closest call which is not matched already
            dTi = abs(Ti - A(Ji,2));
            while ~isempty(Ii)
                [valmin,argmin] = min(dTi);
                if isnan(CHi.call(Ii(argmin)).FileCall)
                    A(i,:) = [Ii(argmin),valmin+A(Ji,2)];
                    break;
                else
                    dTi(argmin) = [];
                    Ii(argmin) = [];
                end
            end
            
            % if while loop ended without a break, then there is no call to
            % macth for this channel, do not change the matrix A.
            
        end
    end
    
    S = A(:,1);
    T = A(:,2);
    O = {};
      
    
end

