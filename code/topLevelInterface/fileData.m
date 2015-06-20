function [ out, add1 ] = fileData( k, par, varargin )
%FILEDATA Get specific data about/of file
%   (k, par) = parameter 'par' of file 'k'.
%   parameters: 'path', 'name', 'fullpath', 
%       'Fs'        = Sampling freq
%       'nSamples'  = Number of samples
%       'nChannels' = Number of channels
%       'rawData'   = Raw data from audio file
%       'length'    = Audio length in secondes
%       'T'         = Returns a vector of time coordinates for samples

    global filesObject;
    
    %{
    if ~getParFromVarargin( 'NoValidation', varargin )
        validateFileIndex(k);
    end    
    %}
    
    out = [];
    add1 = [];    
    
    
    switch par
        
        case 'Path'
            out = filesObject(k).path;
        
        case 'Name'
            out = filesObject(k).name;
        
        case 'Fullpath'
            out = strcat(filesObject(k).path, filesObject(k).name);
        
        case 'Extension'
            out = filesObject(k).extension;
        
        case 'NakedName'
            out = filesObject(k).naked;
            
        case 'Fs'
            out = filesObject(k).rawData.Fs;
        
        case 'nSamples'
            out = filesObject(k).rawData.nSamples;
        
        case 'nChannels'
            out = filesObject(k).rawData.nChannels;
        
        case 'Length'
            out = filesObject(k).rawData.nSamples/filesObject(k).rawData.Fs;
        
        case {'TimeSeries', 'TS'}
            samplesInterval = getSamplesInterval(k,varargin);
            T = fileData(k,'T');
            out = getTimeSeries(k,samplesInterval);
            add1 = T(samplesInterval(1):samplesInterval(2));
            switch getParFromVarargin('Value',varargin)
                case false
                    
                case 'MinMax'
                    Min = min(min(out));
                    Max = max(max(out));
                    out = Min;
                    add1 = Max;
            end
            
        case 'IsLoaded'
            try
                if isempty(filesObject(k).rawData.data)
                    out = false;
                else
                    out = true;
                end
            catch ME
                if strcmp(ME.identifier,'MATLAB:nonExistentField')
                    out = false;
                else % not this error, do not catch
                    throw(ME);
                end
            end
            
        case 'T'
            samplesInterval = getSamplesInterval(k,varargin);
            T1 = (1:filesObject(k).rawData.nSamples)./filesObject(k).rawData.Fs;
            T2 = T1(samplesInterval(1):samplesInterval(2));
            T3 = transpose(T2);
            out = T3;
            
        case 'Mics'
            if length(varargin)>=1
                switch varargin{1}
                    case 'Count'
                        out = size(filesObject(k).mics.matrix, 1);
                    case 'Matrix'
                        out = filesObject(k).mics.matrix;
                    case 'Positions'
                        M = filesObject(k).mics.matrix;
                        out = M(:,3:5);
                        if getParFromVarargin('LocalizationUsage',varargin)
                            U = logical(M(:,1));
                            out = out(U);
                        elseif getParFromVarargin('BeamUsage',varargin)
                            U = logical(M(:,1));
                            out = out(U);
                        end
                    case 'LocalizationUsage'
                        M = filesObject(k).mics.matrix;
                        out = logical(M(:,1));
                    case 'BeamUsage'
                        M = filesObject(k).mics.matrix;
                        out = logical(M(:,2));
                    case {'Gain','Gains'}
                        M = filesObject(k).mics.matrix;
                        out = M(:,6);
                    case 'MaxDiff'
                        M = filesObject(k).mics.matrix;
                        P = M(:,3:5);
                        out = maxTimeDiffBetweenChannels(P);
                        Fs = filesObject(k).rawData.Fs;
                        add1 = round(out.*Fs);
                    case 'Subarrays'
                        out = filesObject(k).mics.subarrays;
                    case 'Directivity'
                        out = filesObject(k).mics.directivity;
                        
                end
            else
                out = filesObject(k).mics;
                %out = fileData(k,'Mics','Positions','NoValidation',true);
            end
            
        case 'Channels'
            switch varargin{1}
                case 'Count'
                    out = filesObject(k).rawData.nChannels;
                    
                case 'Calls'
                    switch varargin{2}
                        case 'Matrix'
                            N = fileData(k,'Channels','Count','NoValidation',true);
                            for j = 1:N
                                n = channelData(k,j,'Calls','Count');
                                M = channelData(k,j,'Calls','Matrix');
                                callStarts2 = M(2:n,1);
                                callStarts1 = M(1:n-1,1);
                                IPI = [0; callStarts2 - callStarts1];
                                Duration = M(:,9) - M(:,1);
                                A = zeros(n,1) + j;
                                B = transpose(linspace(1,n,n));
                                out = [out; A B M(:,1:12) IPI Duration M(:,13:14)];
                            end
                            
                        case 'Ridge'
                            N = fileData(k,'Channels','Count','NoValidation',true);
                            out = cell(N,1);
                            for j = 1:N
                                out{j} = channelData(k,j,'Calls','Ridge');
                            end
                            
                        case 'TS'
                            N = fileData(k,'Channels','Count','NoValidation',true);
                            out = cell(N,1);
                            for j = 1:N
                                out{j} = channelData(k,j,'Calls','TS');
                            end
                            
                    end
            end
            
        case 'Calls'
            switch varargin{1}
                case 'Count'
                    out = length(filesObject(k).fileCalls);
                    
                case 'Times'
                    n = length(filesObject(k).fileCalls);
                    out = zeros(n,1);
                    for a=1:n
                        %out(a) = fileCallData(k,a,'Time',varargin{2},'NoValidation', true);
                        out(a) = fileCallData(k,a,'Time','NoValidation', true);
                    end
                    
                case 'Locations'
                    n = length(filesObject(k).fileCalls);
                    out = zeros(n,3);
                    for a=1:n
                        out(a,:) = fileCallData(k,a,'Location','NoValidation', true);
                    end  

                case 'Beam'
                    n = length(filesObject(k).fileCalls);
                    out = cell(n,1);
                    for a=1:n
                        out{a} = fileCallData(k,a,'BeamStructure','NoValidation', true);
                    end  
                    
                case 'Data'
                    n = length(filesObject(k).fileCalls);
                    out = cell(n,1);
                    for a=1:n
                        out{a} = fileCallData(k,a,'Data');
                    end
            end
            
        case 'Call'
            switch varargin{1}
                case 'Data'
                    
            end
            
            
        case 'DataStatus'
            q = getParFromVarargin( 'Set', varargin );
            if ~q
                out = filesObject(k).rawData.status;
            else
                filesObject(k).rawData.status = q;
            end
            
        case 'Select'
            if ~isempty(varargin) > 0 && islogical(varargin{1})
                selected = varargin{1};
            else
                throw(MException('bats:fileData:selectionParWrong','Selection value in "fileData" is wrong'));
            end
            filesObject(k).selected = selected;
            
        case 'isSelected'
            out = filesObject(k).selected;
            
        otherwise
            err = MException('bats:fileData:noPar','No such parameter "%s"', par);
            throw(err);
    end

end

