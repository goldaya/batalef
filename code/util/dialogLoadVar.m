function [ D ] = dialogLoadVar(  )
%DIALOGLOADVAR Ask for Variable name and output its contents
%   Detailed explanation goes here

    varName = inputdlg('Variable Name');
    D = evalin('base',varName{1});
    
end

