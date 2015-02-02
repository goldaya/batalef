function [ point1, point2 ] = test( hObj, evt )
%TEST Summary of this function goes here
%   Detailed explanation goes here

        point1 = get(hObj,'CurrentPoint');
        rbbox;
        point2 = get(hObj,'CurrentPoint');
        
end

