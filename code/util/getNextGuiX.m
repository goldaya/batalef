function [ nextX ] = getNextGuiX( skip )
%GETNEXTGUIX Summary of this function goes here
%   Detailed explanation goes here


    global control;
    
    if ~exist('skip','var')
        skip = [];
    end
    
    nextX = 1;
    nextX = getNextGuiXCheckGui(control.mg.fig, nextX, skip);
    %nextX = getNextGuiXCheckGui(control.cg.fig, nextX, skip);
    
    nextX = getNextGuiXCheckGui(control.sug.fig, nextX, skip);  
    nextX = getNextGuiXCheckGui(control.sog.fig, nextX, skip);

end

