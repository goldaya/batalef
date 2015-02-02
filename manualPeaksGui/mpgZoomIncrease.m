function [ output_args ] = mpgZoomIncrease( incFactor )
%MPGZOOMINCREASE Summary of this function goes here
%   Detailed explanation goes here

    global control;

    control.mpg.zoom.power = control.mpg.zoom.power * incFactor;
    control.mpg.zoom.time  = control.mpg.zoom.time  * incFactor;
    setParam('peaks:manual:zoom:power', control.mpg.zoom.power);
    setParam('peaks:manual:zoom:time' , control.mpg.zoom.time);
    
    
end

