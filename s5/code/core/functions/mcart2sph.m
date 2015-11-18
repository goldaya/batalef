function M_sph = mcart2sph( M_cart, angleType )
%MCART2SPH translate a matrix of cartesian points into a matrix of 
%spherical points (in degrees or radians)
%   M_sph = mcart2sph(M_cart,angleType) accepts a nx3 matrix M_CART and 
%   transforms it into M_DEG, a nx3 matrix of azimuth, elevation, radius 
%   columns. The output values are either radians (by default and when the
%   ANGLETYPE variable is 'radian', or degrees when ANGLETYPE is 'degree'.
%   based in cart2sph().


    X = M_cart(:,1);
    Y = M_cart(:,2);
    Z = M_cart(:,3);
    
    [AZ,EL,R] = cart2sph(X,Y,Z);
    
    if ~exist('angleType','var')
        angleType = 'radian';
    end
    switch angleType
        case 'radian'
            % do nothing
        case 'degree'
            AZ = rad2deg(AZ);
            EL = rad2deg(EL);
        otherwise
            errid = 'mcart2sph:wrongAngleType';
            errstr = sprintf('Wrong angle type for mcart2sph: %s. only "radian" or "degree" are allowed',angleType);
            throwAsCaller(MException(errid,errstr));
    end
    
    M_sph = [AZ,EL,R];


end

