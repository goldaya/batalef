function [  ] = fpgSelectFileCall( a )
%FPGSELECTFILECALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = fpgGetHandles();
    jTable = findjobj(handles.uitabFileCalls);
    %jScrollPane = jTable.getViewport.getView();
    scroll = get(get(jTable,'VerticalScrollBar'),'Value');
    
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
    %jScrollPane.changeSelection(a-1,0,false,false);
    pause('on');
    pause(0.01);
    set(get(jTable,'VerticalScrollBar'),'Value',scroll);
    pause(0.01);
    set(handles.uitabFileCalls,'Visible','off');
    pause(0.01);
    set(handles.uitabFileCalls,'Visible','on');
         
    
    % render beam display
    fpgRefreshBeam();
    
end