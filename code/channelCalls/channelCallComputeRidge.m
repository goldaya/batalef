function call = channelCallComputeRidge( call, dataset, Fs )
%CHANNELCALLCOMPUTERIDGE 

        try
            extParams.peakTime  = call.PeakTime;
            extParams.startTime = call.StartTime;
            call.Ridge = rdgmAdminCompute(dataset, Fs, extParams);
            call.Ridge(:,1) = call.Ridge(:,1) + call.StartTime;
        catch err
            err.message; % dummy line
            call.Ridge = [];
        end
        
end

