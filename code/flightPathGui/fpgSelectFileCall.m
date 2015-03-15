function [  ] = fpgSelectFileCall( a )
%FPGSELECTFILECALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = fpgGetHandles();
    
    % select call
    control.fpg.a = a;
    
    % refresh marks on uitable
    D = get(handles.uitabFileCalls, 'Data');
    n = size(D,1);
    V = zeros(n,1);
    if a > 0
        V(a) = 1;
    end
    l = num2cell(logical(V));
    D(:,1) = l;
    set(handles.uitabFileCalls, 'Data', D);
         
    
    % render beam display
    fpgRefreshBeam();
    
end