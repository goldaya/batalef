function fpgBeamShowRaw(  )
%FPGBEAMSHOWRAW 

    [k,~,~,a] = fpgGetCurrent();
    if a==0
        return;
    end
    
    R = fileCallData(k,a,'Beam','Raw');
    
    
    if isempty(R)
        msgbox('No data');
    else
        C = fileCallData(k,a,'Beam','Coordinates','NoValidation',true);
        AZ = C(:,1);
        EL = C(:,2);
        EL = flipud(EL);
        fig = figure;
        set(fig,'Name',strcat(['Beam - Raw . Call #',num2str(a)]),'numbertitle','off');
        imagesc(AZ,EL,R)
    end
    
end

