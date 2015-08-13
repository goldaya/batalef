function [ out, add1, add2, add3 ] = channelData( k,j,par,varargin )
%CHANNELDATA Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    if ~getParFromVarargin( 'NoValidation', varargin )
        validateFileChannelIndex(k,j);
    end
    
    add1 = [];
    add2 = [];
    add3 = [];
    
    
    switch par
        
        case 'Fs'
            out = filesObject(k).rawData.Fs;
        
        case 'nSamples'
            out = filesObject(k).rawData.nSamples;
            
        case {'TimeSeries', 'TS'}
            [rdata, T] = fileData(k,'TimeSeries',getSamplesInterval(k,varargin));
            out = rdata(:,j);
            add1 = T;
            % filter
            filter2use = getParFromVarargin( 'Filter', varargin );
            if islogical(filter2use) && ~filter2use || isempty(filter2use)
                return;
            else
                Fs = channelData(k,j,'Fs');
                out = applyFilterToData(out, Fs, filter2use);
            end
                
            
        case 'Title'
            out = strcat(filesObject(k).name, ' - ', num2str(j));
        
        case 'Envelope'
            filter2use = getParFromVarargin('Filter',varargin);
            if islogical(filter2use) && ~filter2use
                filter2use = [];
            end
            p = getParFromVarargin( 'Percentile', varargin );
            if p > 0
                env = getEnvelope(k,j, getSamplesInterval(k,varargin),filter2use);
                out = prctile(env,p);
            else
                [out, add1] = getEnvelope(k,j, getSamplesInterval(k,varargin),filter2use);
            end
            
        case 'Calls'
            [out, add1, add2, add3] = getChannelCalls(k,j,varargin{:});
            
        case {'Pois','PointsOfInterest'}
            try
                out = filesObject(k).channels(j).pois;
            catch 
                out = [];
            end
                
            
        otherwise
            err = MException('bats:fileData:noPar','No such parameter "%s"', par);
            throw(err);    
    end
    
end