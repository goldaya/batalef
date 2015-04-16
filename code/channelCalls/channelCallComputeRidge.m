function call = channelCallComputeRidge( call, dataset, Fs )
%CHANNELCALLCOMPUTERIDGE 

        try
            call.Ridge = rdgmAdminCompute(dataset, Fs);
            call.Ridge(:,1) = call.Ridge(:,1) + call.StartTime;
        catch err
            err.message; % dummy line
            call.Ridge = [];
        end
        
end

