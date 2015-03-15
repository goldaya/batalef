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
    
    cv = filesObject(k).channels(j).channelCalls(s,:);
    Fs = fileData(k,'Fs');
    
    if isempty(varargin)
        par2 = '';
    else
        par2 = varargin{1};
    end
    
    switch par
           
        case 'Detection'
            switch par2
                case 'Point'
                    out = cv{1};
                case 'Time'
                    out = cv{1}/Fs;
                case 'Value'
                    out = cv{2};
                otherwise
                    out.Point = cv{1};
                    out.Time = cv{1}/Fs;
                    out.Value = cv{2};
            end
                    
        case 'Start'
            switch par2
                case 'Point'
                    out = cv{6};
                case 'Time'
                    out = cv{6}/Fs;
                case 'Value'
                    out = cv{7};
                case 'Freq'
                    out = cv{8};
                case 'Power'
                    out = cv{15};
                otherwise
                    out.Point = cv{6};
                    out.Time  = cv{6}/Fs;
                    out.Value = cv{7};
                    out.Freq  = cv{8};
                    out.Power = cv{15};
            end
           
        case 'End'
            switch par2
                case 'Point'
                    out = cv{9};
                case 'Time'
                    out = cv{9}/Fs;
                case 'Value'
                    out = cv{10};
                case 'Freq'
                    out = cv{11};
                case 'Power'
                    out = cv{16};
                otherwise
                    out.Point = cv{9};
                    out.Time  = cv{9}/Fs;
                    out.Value = cv{10};
                    out.Freq  = cv{11};
                    out.Power = cv{16};
            end          
           
        case 'Peak'
            switch par2
                case 'Point'
                    out = cv{3};
                case 'Time'
                    out = cv{3}/Fs;
                case 'Value'
                    out = cv{4};
                case 'Freq'
                    out = cv{5};
                case 'Power'
                    out = cv{14};
                otherwise
                    out.Point = cv{3};
                    out.Time  = cv{3}/Fs;
                    out.Value = cv{4};
                    out.Freq  = cv{5};
                    out.Power = cv{14};
            end            
           
           
           
        case 'Duration'
            switch par2
                case 'Time'
                    out = (cv{9}-cv(6))/Fs;
                case 'Point'
                    out = (cv{9}-cv{6});
                otherwise
                    out.Point = (cv{9}-cv{6});
                    out.Time  = out.Point/Fs;
            end
           
        case 'Ridge'
               out = cv{13};
           

        case 'TS'
            if cv{9} > cv{6}
                [out, out2] = channelData(k,j,'TimeSeries',[cv{6},cv{9}]);
            else
                out = [];
            end
            
        case 'FileCall'
            out = getFileCall4ChannelCall(k,j,s);
            
        case 'Object'
            out = channelCall(k,j,s);
               
    end

end

