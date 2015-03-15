function [ output_args ] = mgDisplayDecimation( do )
%MGDISPLAYDECIMATION Set decimation for displayed signals

    global control;

    if do
        ret = decimation();
        if ret.p > 0 && ret.q > 0
            [p,q] = rat(ret.p/ret.q, 10^-2);
            setParam('mainGUI:decimateDisplay',true);
            control.mg.decimateDisplay.p = p;
            control.mg.decimateDisplay.q = q;
        elseif ret.N > 0
            n = fileData(appData('Files','Displayed'),'nSamples');
            [p,q] = rat(ret.N/n, 10^-2);
            control.mg.decimateDisplay.p = p;
            control.mg.decimateDisplay.q = q;            
            setParam('mainGUI:decimateDisplay',true); 
        else
            setParam('mainGUI:decimateDisplay',false); 
        end
    else
       setParam('mainGUI:decimateDisplay',false); 
    end
end

