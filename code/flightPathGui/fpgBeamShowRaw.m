function fpgBeamShowRaw(  )
%FPGBEAMSHOWRAW 

    [k,a] = fpgGetCurrent();
    if a==0
        return;
    end
    
    beamData = fileCallData(k,a,'Beam');
    R = beamData.raw;
    %R = fileCallData(k,a,'Beam','Raw');
    
    if isempty(R)
        msgbox('No data');
    else
        AZ = beamData.coordinates(:,1);
        EL = beamData.coordinates(:,2);
        %C = fileCallData(k,a,'Beam','Coordinates','NoValidation',true);
        %AZ = C(:,1);
        %EL = C(:,2);
        %EL = flipud(EL);
        fig = figure;
        set(fig,'Name',strcat(['Beam - Raw . Call #',num2str(a)]),'numbertitle','off');
    
        %I = fileCallData(k,a,'Beam','Interpolated');
        I = beamData.interpolated;
        imagesc(AZ,EL,R,[min(min(I)),max(max(I))])
        set(gca,'YDir','normal');
        
        % mic numbers
        M = beamData.micDirections;
        for i = 1 : size(M,1)
            h = text(M(i,1),M(i,2),num2str(i));
            set(h,'Color',[1,1,1]);
        end
        
        
    end
    
end

