function [ out, out2 ] = channelCallData( k,j,s,par, varargin )
%CHANNELCALLDATA Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    out = [];
    out2 = [];
    
    if ~getParFromVarargin( 'NoValidation', varargin )    
        validateFileChannelIndex(k,j);
    
        % validate call existance
        if size(filesObject(k).channels(j).channelCalls,1) < s
            out = 'no call';
            return;
        end
    end 
    
    type = getParFromVarargin( 'NoValidation', varargin );
    if type == false
        type = channelCall.features;
    end

    
    call = channelCall(k,j,s,type,false);
    
    
    if isempty(varargin)
        par2 = '';
    else
        par2 = varargin{1};
    end
    
    switch par
           
        case 'Detection'
            switch par2
                case 'Point'
                    out = channelCall.inPoints(call,call.DetectionTime);
                case 'Time'
                    out = call.DetectionTime;
                case 'Value'
                    out = call.DetectionValue;
                otherwise
                    out = call.Detection;
            end
                    
        case 'Start'
            switch par2
                case 'Point'
                    out = channelCall.inPoints(call,call.StartTime);
                case 'Time'
                    out = call.StartTime;
                case 'Value'
                    out = call.StartValue;
                case 'Freq'
                    out = call.StartFreq;
                case 'Power'
                    out = call.StartPower;
                otherwise
                    out = call.Start;
            end
           
        case 'End'
            switch par2
                case 'Point'
                    out = channelCall.inPoints(call,call.EndTime);
                case 'Time'
                    out = call.EndTime;
                case 'Value'
                    out = call.EndValue;
                case 'Freq'
                    out = call.EndFreq;
                case 'Power'
                    out = call.EndPower;
                otherwise
                    out = call.End;
            end          
           
        case 'Peak'
            switch par2
                case 'Point'
                    out = channelCall.inPoints(call,call.PeakTime);
                case 'Time'
                    out = call.PeakTime;
                case 'Value'
                    out = call.PeakValue;
                case 'Freq'
                    out = call.PeakFreq;
                case 'Power'
                    out = call.PeakPower;
                otherwise
                    out = call.Peak;
            end            
           
           
           
        case 'Duration'
            out = call.Duration;
           
        case 'Ridge'
            out = call.Ridge;
           

        case 'TS'
            out = call.TimeSignal;
            
        case 'FileCall'
            out = call.FileCall;
            
        case 'Object'
            out = call;
               
    end

end

