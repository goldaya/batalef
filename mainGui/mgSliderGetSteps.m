function [ steps ] = mgSliderGetSteps(  )
%MGSLIDERGETSTEPS Summary of this function goes here
%   Detailed explanation goes here

    steps = max(1,1+length(appData('Channels','Filtered')) - appData('Axes','Count'));

end