function [ I ] = pwpdgSetIntervals( k )
%PWPDGSETINTERVALS Summary of this function goes here
%   Detailed explanation goes here

    nSamples = fileData(k,'nSamples','NoValidation');
    Fs = fileData(k,'Fs','NoValidation');
    handles = pwpdgGetHandles();
    window = str2double(get(handles.textWindow, 'String'));
    overlap = str2double(get(handles.textOverlap, 'String'));
    I = peaksPwEquidistantIntervals(nSamples, Fs, window, overlap);
    
end

