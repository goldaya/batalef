function [ rc, funcName, failed ] = applyWildCard( K )
%APPLYWILDCARD Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    failed = [];
    % must have files indexes
    if isempty(K)
        rc = 3;
        return;
    end

    str{1} = 'Function name in base workspace. Function must accept {TimeSeries, Fs} as cellarray and return this cellarray format';
    defAns{1} = '';
 
    A = inputdlg(str,'Wild Card Function',[1,70],defAns);
    
    % abort when user canceled
    if isempty(A)
        funcName = [];
        rc = 4;
        return;
    else
        funcName = A{1};
    end
        
    % do
    for k = 1:length(K)
        TS = fileData(K(k),'TimeSeries');
        Fs = fileData(K(k),'Fs');
        nChannels = fileData(K(k),'Channels','Count');
        try
            R = eval(strcat(funcName,'({TS,Fs})'));
         catch err
            if strcmp('MATLAB:UndefinedFunction',err.identifier)
                try
                    custFunc = evalin('base', funcName);
                    R = custFunc({TS,Fs});
                catch err
                    throw(err);
                end
            else
                throw(err);
            end
        end
            
        
        [nSamples,newNChannels] = size(R{1});
        if newNChannels ~= nChannels
            msgbox('Number of channels should not change. Aborting.',strcat(['File ',num2str(K(k))]));
            failed = [failed, K(k)];
        else
            rdata.data = R{1};
            rdata.Fs = R{2};
            rdata.nSamples = nSamples;
            rdata.nChannels = nChannels;
            rdata.status = strcat(['Wildcard: ',A{1}]);
            filesObject(K(k)).rawData = rdata;
        end
    end
    
    switch length(failed)
        case 0
            rc = 0;
        case length(K)
            rc = 2;
        otherwise
            rc = 1;
    end
    
    if rc < 2
        mgRefreshFilesTable();
    end
    
end