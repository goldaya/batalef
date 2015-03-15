function [ K ] = mgResolveFilesToWork(  )
%MGRESOLVEFILESTOWORK Summary of this function goes here
%   Detailed explanation goes here

    K = appData('Files','Selected');
    
    %{
    handles = mgGetHandles();
    v = get(handles.tabFiles, 'UserData');
    if isempty(v)
        K = [];
    else
        K = v(:,1);
    end;
    %}

end

