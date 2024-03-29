function [  ] = mgDisplayFile( k )
%MGDISPLAYFILE Put a file's channels on screen (according to filter etc).
%[0] for no display

    if k > 0 && ~validateFileIndex(k,true);
        msgbox(strcat(['no such file index ',num2str(k)]));
    end
    
    global control;
    if control.mg.k == k
        control.mg.lockZoom = true;
    else
        control.mg.lockZoom = false;
    end
    control.mg.k = k;
    
    % init slider step
    mgSetSlider(true,0);
    
    mgRefreshAxes();
    mgRefresh_textDisplayedFile();
    
    control.mg.lockZoom = true;
    
    % kill manual peak gui on file 0
    if k == 0
        mpgKill();
    end
    
    % auto spectrogram
    if k ~=0 && getParam('mainGUI:autospectro')
        spectrogramGUI([1,fileData(k,'nSamples')]);
    end
end

