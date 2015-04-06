function [  ] = createFileObject( n, path, name, rawData, spectralData, fileCalls, channels, mics )
%CREATEFILEOBJECT Summary of this function goes here
%   rawData = [ channelsData, Fs ]
    
    global filesObject;
    
    if ~( exist('path', 'var') && exist('name', 'var') )
        err = MException( 'bats:files:addFile', 'No path or no filename');
        throw( err );
    end
    
    filesObject(n).selected = false;
    filesObject(n).path = path;
    filesObject(n).name = name;
    filesObject(n).fullname = strcat( path, name);
    
    % raw data (basic data) + channels
    if ( exist('rawData', 'var') && ~isempty(rawData) )
        filesObject(n).rawData = rawData;
        %filesObject(n).rawData.Fs = rawData.Fs;
        %filesObject(n).rawData.nSamples = rawData.nSamples;
        
        % channels data
        filesObject(n).channels = struct;
        if (exist('channels','var') && ~isempty(channels) )
            for j = 1:size(channels,1)
                channels(j) = updateChannelStructure(channels(j),rawData.Fs);
            end
            filesObject(n).channels = channels;
        else
            for i = 1 : rawData.nChannels
            filesObject(n).channels(i).channelCalls = [];
            end
        end
        % other channel specific stuff        
    else
        filesObject(n).rawData.data = [];
        filesObject(n).rawData.Fs = 0;
        filesObject(n).rawData.nSamples = 0;
        filesObject(n).channels = [];
        filesObject(n).rawData.status = 'Raw, Unloaded';
    end

    % file-level calls
    if exist('fileCalls', 'var') 
        filesObject(n).fileCalls = fileCalls;       
    else
        filesObject(n).fileCalls = [];
    end
    

    % spectral data
    if ( exist('spectralData', 'var') && ~isempty(spectralData) )
        filesObject(n).spectralData = spectralData;
    else
        filesObject(n).spectralData = [];
    end

    % Microphones
    if ( exist('mics', 'var') && ~isempty(mics) )
        % backward compatablity
        if isstruct(mics)
            if ~isfield(mics,'directivity')
                mics.directivity = [];
            end
            if ~isfield(mics,'subarray')
                mics.subarray = [];
            end
            filesObject(n).mics = mics;

        else
            filesObject(n).mics.matrix = mics;
            filesObject(n).mics.subarrays = [];
            filesObject(n).mics.directivity = [];
        end
    elseif ~isempty(filesObject(n).channels)
        a1 = ones(length(filesObject(n).channels),2);
        a2 = zeros(length(filesObject(n).channels),3);
        a3 = ones(length(filesObject(n).channels),1);
        filesObject(n).mics.matrix = [a1, a2, a3];
        filesObject(n).mics.subarrays = [];
        filesObject(n).mics.directivity = [];
    else
        filesObject(n).mics.matrix = [];
        filesObject(n).mics.subarrays = [];
        filesObject(n).mics.directivity = [];
    end    
    
    %{
    if ( exist('micPositions', 'var') && ~isempty(micPositions) )
        filesObject(n).micPositions = micPositions;
    elseif ~isempty(filesObject(n).channels)
        filesObject(n).micPositions = zeros(length(filesObject(n).channels),3);
    else
        filesObject(n).micPositions = [];
    end    
    
    % Microphone Gains
    if ( exist('micGains', 'var') && ~isempty(micGains) )
        filesObject(n).micGains = micGains;
    elseif ~isempty(filesObject(n).channels)
        filesObject(n).micGains = zeros(length(filesObject(n).channels),1);
    else
        filesObject(n).micGains = [];
    end        
    %}
end

