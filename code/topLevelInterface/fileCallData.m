function [ out1 ] = fileCallData( k, a, par, varargin )
%FILECALLDATA Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    out1 = [];

    if ~exist('par', 'var') || isempty(par) || ~ischar(par)
        err = MException('bats:fileCall:getData:noParameter','No parameter was asked');
        throw(err);
    end
    
    if ~getParFromVarargin( 'NoValidation', varargin )
        validateFileCallIndex( k, a );
    end
    
    pos = getParFromVarargin('Position',varargin);
    if ~pos
        pos = 'Start';
    end
            
    switch par
        case 'Data'
            out1 = filesObject(k).fileCalls{a};
            
        case 'ChannelCalls'
            out1 = filesObject(k).fileCalls{a}.channelCalls;
            
        case 'Time'
            out1 = filesObject(k).fileCalls{a}.time;

        case 'Location'
            out1 = filesObject(k).fileCalls{a}.location;            
            
        case 'Power'
            CC = filesObject(k).fileCalls{a}.channelCalls;
            out1 = zeros(length(CC),1);
            for i = 1:length(CC)
                if CC(i) > 0
                    out1(i) = channelCallData(k,i,CC(i),pos,'Power');
                end
            end

        case 'Value'
            CC = filesObject(k).fileCalls{a}.channelCalls;
            out1 = zeros(length(CC),1);
            for i = 1:length(CC)
                if CC(i) > 0
                    out1(i) = channelCallData(k,i,CC(i),pos,'Value');
                end
            end
            
        case 'Beam'
            switch varargin{1}
                case {'Int','Interpolated'}
                    out1 = filesObject(k).fileCalls{a}.beam.interpolated;
                    
                case 'Raw'
                    out1 = filesObject(k).fileCalls{a}.beam.raw;
                    
                case 'Leads'
                    out1 = filesObject(k).fileCalls{a}.beam.leads;
                    
                case {'Coordinates','Coors'}
                    out1 = filesObject(k).fileCalls{a}.beam.coordinates;
                    
                case 'Mics'
                    out1 = filesObject(k).fileCalls{a}.beam.micDirections;
               
                case 'All'
                    out1 = filesObject(k).fileCalls{a}.beam;
            end
    end
    
end

