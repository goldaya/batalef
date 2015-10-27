function call = channelCallComputeRidge( call )
%CHANNELCALLCOMPUTERIDGE 

        try

            call.Ridge = control.app.Methods.callAnalysisRidge.execute(call);
            
        catch err
            err.message; % dummy line
            call.Ridge = [];
        end
        
end

