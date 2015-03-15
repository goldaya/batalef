function [  ] = ccdmAdminBuildList(  )
%CCDMADMINBUILDLIST Summary of this function goes here
%   Detailed explanation goes here

    [~, menus] = mgGetHandles('callDetectionMenu');
    channelCallsDetectionMethods;
    for i = 1:length(m)
       h = uimenu(menus, 'Label', m{i}{1},'CallBack',@ccdmAdminMethodSelected,'UserData',i);
       % check methid asks for replace, channels params
    end


end

