function bmgSave(  )
%BMGSAVE Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    handles = guidata(control.bmg.fig);
    
    D = get(handles.uitabBeamData,'Data');
    U = cell2mat(D(:,1));
    M = cell2mat(D(:,2:7));
    AZ = M(:,1);
    EL = M(:,2);
    Pm = M(:,3);
    Pg = M(:,4);
    Pd = M(:,5);
    Ps = M(:,6);
    
    calculateBeamInner(control.bmg.k,control.bmg.a,U,AZ,EL,Pm,Pg,Pd,Ps,true);
   
    msgbox('Done recomputing beam');
end

