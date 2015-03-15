function [ env ] = computeEnvelope( dataset, Fs )
%COMPUTEENVELOPE Summary of this function goes here
%   Detailed explanation goes here

    env = envmAdminCompute( dataset, Fs );
    
    %{

    global c;
    global control;
    
    % get envelope method
    method = getParam('envelope:method');
    
    switch method
        case c.hilbert
            % get params
            rank = getParam('envelope:hilbert:rank');
            nWindows = getParam('envelope:hilbert:nWindows');
            minWindow = getParam('envelope:hilbert:minWindow');
            env = hilbertEnvelope(dataset, rank, nWindows, minWindow);
            
        case c.custom
            envFunc = evalin('base',control.envelopeCustomFunction);
            env = envFunc(dataset);

        otherwise
            err = MException('bats:envelope:wrongMethod','Envelope method %f is not defined. Check constants "c" struct.', method);
            throw(err);            
    end
    
    %}
end

