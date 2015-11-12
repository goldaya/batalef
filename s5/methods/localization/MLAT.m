function [estimated_bat_location] = MLAT( mics_locations, delays_array,sound_speed)
% the function receives an array of michrophone locations and the number of microphones.
% it also receives an array of delays (TDOA)
% it returns the estimated location (3 coordinates).
% in this implementation, there is a "shift" in the microphones numbers
% (not like in the multilateration algorithm):
% microphone #0 there will be #1 here, and so on.

c= sound_speed;

num_of_mics = numel(delays_array);
%cm to m
mics_locations=mics_locations;
%normalize to mic1
delays_array=delays_array-delays_array(1);

% initialization
A_vect = zeros(num_of_mics, 1);
B_vect = zeros(num_of_mics, 1);
C_vect = zeros(num_of_mics, 1);
D_vect = zeros(num_of_mics, 1);

for m = 3:num_of_mics
    A_vect(m) = 2*mics_locations(m,1)/(c*delays_array(m,1)) - 2*mics_locations(2,1)/(c*delays_array(2,1));
    B_vect(m) = 2*mics_locations(m,2)/(c*delays_array(m,1)) - 2*mics_locations(2,2)/(c*delays_array(2,1));
    C_vect(m) = 2*mics_locations(m,3)/(c*delays_array(m,1)) - 2*mics_locations(2,3)/(c*delays_array(2,1));
    D_vect(m) = c*( delays_array(m,1)-delays_array(2,1) ) - (mics_locations(m,1)^2+mics_locations(m,2)^2+mics_locations(m,3)^2)/(c*delays_array(m,1)) + (mics_locations(2,1)^2+mics_locations(2,2)^2+mics_locations(2,3)^2)/(c*delays_array(2,1));
end

A_matrix = [A_vect B_vect C_vect];
b = -D_vect;

warning('off','MATLAB:rankDeficientMatrix');
estimated_bat_location = linsolve(A_matrix, b);
warning('on','MATLAB:rankDeficientMatrix');