% -------------------------------------
%Gauss Newton
%-------------------------------------
function [ mobileLocEst ] = gaussnewton( SpeakerLocations , mobileLocEst,MaxIterations,SpeakerNum,DistanceToSpeakers)

    % If the given initial coordinates are too large
    % (This may happen if the previews algorithem failed to converge)
    if  abs(mobileLocEst(1))>30
      mobileLocEst(1)=1;  
    end
    if  abs(mobileLocEst(2))>30
      mobileLocEst(2)=1;  
    end
    if  abs(mobileLocEst(3))>30
      mobileLocEst(3)=1;  
    end
    
    % Calculate the maximum array dimention ( the errs on the high side)
    MaxSpeakerLoc = max(SpeakerLocations(:));
    MinpeakerLoc=min(SpeakerLocations(:));
    MaxArrayDimention = MaxSpeakerLoc-MinpeakerLoc;
    DistanceMean = mean(DistanceToSpeakers) ;
    
    % If one of the distances measured is too big or too small, ignore it
    % The value is compared to the average measurement
    RowDelNum = 0;
    for CurrDistance = 1: SpeakerNum    
        if (SpeakerNum - RowDelNum >= 3)
            if abs(DistanceToSpeakers(CurrDistance))> (abs(DistanceMean) + abs(MaxArrayDimention))
                 RowDelNum = RowDelNum+1;
                RowsToDelete(RowDelNum)=CurrDistance;
            end
        end
    end
    
    % If impossible values are found, ignore those measurements
    if RowDelNum > 0  
        SpeakerLocations([RowsToDelete],:) = [];
        DistanceToSpeakers([RowsToDelete],:) = [];
        SpeakerNum = SpeakerNum-RowDelNum;
    end

    MaxDelta = 100;
    i = 1;
    DeltaLimit =  10e-15;
    % Main loop
    while (i<MaxIterations) && (MaxDelta > DeltaLimit)
        
        %Build the jacobian matrix 
        
        % distanceEst = sqrt( (x_Est-x_Spkr)^2 + (y_Est-y_Spkr)^2 + (Z_Est-Z_Spkr)^2 )
        % J = d(distanceEst)/dx, d(distanceEst)/dy, d(distanceEst)/dz
        % J=(x_Est-x_Spkr)/distanceEst, (y_Est-y_Spkr)/distanceEst,
        % (Z_Est-Z_Spkr)^2 )/distanceEst
        
        %Calculate the Distance to each speaker with the Estimated location
        distanceEst   = sqrt(sum( (SpeakerLocations - repmat(mobileLocEst,SpeakerNum,1)).^2 , 2));
        
        % calculate derivitives 
         Dx = (mobileLocEst(1)-SpeakerLocations(:,1))./distanceEst;
         Dy=(mobileLocEst(2)-SpeakerLocations(:,2))./distanceEst;
         Dz = (mobileLocEst(3)-SpeakerLocations(:,3))./distanceEst;
         %Build the jacobian
         Jacobian   = [Dx, Dy  , Dz ];   
        
         % This iteration's Error
        Error =  distanceEst - DistanceToSpeakers;            
        
        % Calculating  The Delta value for the newxt estimate
        delta = - (Jacobian.'*Jacobian)^-1*Jacobian.' * (Error);
        
        % Add the delta to the estimate
        mobileLocEst = mobileLocEst + delta.';
        
        MaxDelta = max(delta);
        i = i +1;
    end
end

