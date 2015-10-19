function call = channelCallComputeRidge( call, dataset, offset )
%CHANNELCALLCOMPUTERIDGE 

        try
            
            relStartTime  = call.Start.Time - offset;
            relPeakTime  = call.Peak.Time - offset;
            relEndTime  = call.End.Time - offset;

            call.Ridge = control.app.Methods.callAnalysisRidge.execute(dataset, Fs, relStartTime, relPeakTime, relEndTime, extParams);
            call.Ridge(:,1) = call.Ridge(:,1) + offset;
            
        catch err
            err.message; % dummy line
            call.Ridge = [];
        end
        
end

