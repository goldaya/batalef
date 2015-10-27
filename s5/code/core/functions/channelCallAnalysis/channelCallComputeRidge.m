function call = channelCallComputeRidge( call )
%CHANNELCALLCOMPUTERIDGE 

        try

            call.Ridge = call.Application.Methods.callAnalysisRidge.execute(call);
            
        catch err
            % need dev: creat a new batalef excpetion and throw. this is a
            % non-gui function in definition !
            msgbox('Error in ridge computation, refer to console for error message');
            disp('~~~~~~~~~~~');
            disp('Ridge method error:');
            disp(err.message);
            disp('~~~~~~~~~~~');
            call.Ridge = zeros(0,3);
        end
        
end

