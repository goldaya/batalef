function [ call ] = calculateCall( callInput, overwrite, callWindowInPoints,startRelativeThreshold,endRelativeThreshold,gapTolerance)
%CALCULATECALL Extract call's features
    
    % call object
    if isobject(callInput) && strcmp(class(callInput),'channelCall')
        call = callInput;
    elseif isvector(callInput) && length(callInput)==3
        call = channelCall(callInput(1),callInput(2),callInput(3));
    else
        err = MException('channelCall:calculation:wrongInput','Wrong input for call identifier');
        throw(err);
    end
    
    % load data, overwrite?
    if call.Saved && ~overwrite
        return;
    end
    
    % find peak, start and end
    spoint = round( call.DetectionPoint - callWindowInPoints/2 );
    epoint = round( call.DetectionPoint + callWindowInPoints/2 );
    if spoint < 1
        spoint = 1;
    end
    if epoint > fileData(call.k,'nSamples','NoValidation')
        epoint = fileData(call.k,'nSamples','NoValidation');
    end
    [dataset] = channelData(call.k, call.j, 'Envelope', [spoint,epoint]); 
    call.findPeak([spoint,epoint],dataset);

    startValue = call.PeakValue * startRelativeThreshold;
    endValue = call.PeakValue * endRelativeThreshold;
    call.realiseCallInterval( dataset, spoint, startValue, endValue, gapTolerance);
    
    % get spectral info - uses somAdminCompute inside
    call.computeSpectralData([spoint,epoint]);%specWindow, specOverlap, specNfft);
    
    % ridge
    call.computeRidge();
    
end

