function [  ] = batalefGuiKill( mainGui )
%BATALEFGUIKILL Kill the main gui and all its next guis
    
%     global control;
    mainGui.kill();
    disp('Batalef gui is dead');
%     control.mg = [];

end

