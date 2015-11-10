%the function gets the number of speaker,speed of sound,the distance
%between the unknown point and the speakers,the coordinates of the
%speakers and the num of dimensions.In order to get a single x y z of
%unknown point we need to use 5 speakers.
function [ mobileLocEsts ] = multi( nspeakers,nDim,v,R,cor_speakers)

% Calculation the of time between the far speakers to closest speaker  to the
% unknown point
t_stars=R./v;
[~,c] = min(t_stars);
t = t_stars-t_stars(c);
mobileLocEst=zeros(nDim,nspeakers-1);
far_speakers = 1:nspeakers;
far_speakers(c) = [];
p=transpose(cor_speakers);
m=1;
%Separate the coordinates of the speakers by axis
x=p(1,:);
y=p(2,:);
z=p(3,:);
% calculate the coefficients of the 3 planes
for  k=far_speakers;
   A = zeros(3, nDim);
b = zeros(3,1);
    j=1;
    for i =far_speakers
          if (i==k)
                     continue
          end
            A(j,1)=2*(x(i)-x(c))/(v*t(i))-2*(x(k)-x(c))/(v*t(k));
            A(j,2)=2*(y(i)-y(c))/(v*t(i))-2*(y(k)-y(c))/(v*t(k));
            A(j,3)=2*(z(i)-z(c))/(v*t(i))-2*(z(k)-z(c))/(v*t(k));
            b(j,1)=-(v*t(i)-v*t(k)-(x(i)^2+y(i)^2+z(i)^2-x(c)^2-y(c)^2-z(c)^2)/(v*t(i))+(x(k)^2+y(k)^2+z(k)^2-x(c)^2-y(c)^2-z(c)^2)/(v*t(k)));  
          j=j+1;
    end
 %Calculating the position of the unknown point

mobileLocEst(:,m)=A^(-1)*b;
 m=m+1;
end
%make average of the coordinates of the unknown point in each axis
mobileLocEsts=mean(transpose(mobileLocEst)) ;
mobileLocEsts = real(mobileLocEsts);
end
