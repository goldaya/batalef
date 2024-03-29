function [  ] = createFileObject( n, fullname, rawData, spectralData, fileCalls, channels, mics )
%CREATEFILEOBJECT Summary of this function goes here
%   rawData = [ channelsData, Fs ]
    
    global filesObject;
    
    if ~exist('fullname', 'var') 
        err = MException( 'bats:files:addFile', 'No path or no filename');
        throw( err );
    end
    
    filesObject(n).selected  = false;
    filesObject(n).fullname  = fullname;
    [path,naked,ext] = fileparts(fullname);
    filesObject(n).path      = strcat( path, filesep() );
    filesObject(n).name      = strcat(naked,ext);
    filesObject(n).naked     = naked;
    filesObject(n).extension = ext;
    
    % raw data (basic data) + channels
    if ( exist('rawData', 'var') && ~isempty(rawData) )
        filesObject(n).rawData = rawData;
        
        % channels data
        filesObject(n).channels = struct;
        if (exist('channels','var') && ~isempty(channels) )
            for j = 1:length(channels)
                channelsNew(j) = updateChannelStructure(channels(j),rawData.Fs);
            end
            filesObject(n).channels = channelsNew;
        else
            for j = 1 : rawData.nChannels
                filesObject(n).channels(j).calls.detection       = zeros(0, 2);
                filesObject(n).channels(j).calls.features        = cell( 0,13);
                filesObject(n).channels(j).calls.forLocalization = cell( 0,13);
                filesObject(n).channels(j).calls.forBeam         = cell( 0,13);
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
    
end

