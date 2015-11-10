%the function geys the distance of the speaker drom the unknown point and
%the coordinates of the speakers and return  the coordinates of the unknown
%point
function [ mobileLocEst] = tri( M,R )
%Calculating the location of unknown point in each axis
x=(R(1).^2-R(2).^2+M(2,1).^2)./(2*M(2,1));
y=(R(1).^2-R(3).^2+M(3,1).^2+M(3,2).^2)./(2*M(3,2))-x.*M(3,1)./M(3,2);
z=sqrt(R(1).^2-x.^2-y.^2);
%create a single vector
mobileLocEst =[ x y z] ;
mobileLocEst = real(mobileLocEst);
end