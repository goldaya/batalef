function [ output_args ] = mpgInit( input_args )
%MPGINIT Summary of this function goes here
%   Detailed explanation goes here

    global control;
    set(control.mpg.fig, 'Units','pixels');
    
    % align gui with main gui
    % get border, top and right outer positions of main gui
    mgOuter = get(control.mg.fig, 'OuterPosition');
    %mgInner = get(control.mg.fig, 'Position');
    %mgBorder = mgOuter - mnInner;
    top = mgOuter(2) + mgOuter(4);
    right = mgOuter(1) + mgOuter(3);
    pos = get(control.mpg.fig, 'Position');
    pos(1) = right;
    pos(2) = top - pos(4) + 10;
    set(control.mpg.fig, 'Position', pos);
    
    % init zoom
    control.mpg.zoom.power = getParam('peaks:manual:zoom:power');
    control.mpg.zoom.time  = getParam('peaks:manual:zoom:time' );
    
end

