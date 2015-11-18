function [ x ] = locGaussNewton( dT,micArray,sonicSpeed,params,~ )
%LOCGAUSSNEWTON Compute bat location using iterative Gauss-Newton method

    % start with some estimated x0.
%     switch params.x0method
%         case 'mlat'
            x = MLAT(micArray,dT,sonicSpeed)';
%         case 'array'
%             arrayParams = struct();
%             [~,D,P] = me.buildParamList();
%             for i = 1:length(D)
%                 arrayParams.(P{i,3}) = D{i};
%             end            
%             x = locDiscreteArray(dT,micArray,sonicSpeed,arrayParams,extParams);
%         otherwise
%             errid = 'batalef:localization:gaussNewton:wrongX0Method';
%             errstr = 'Wrong x0 method for the gauss-newton localization. Should be "mlat" or "array"';
%             throwAsCaller(MException(errid,errstr));
%     end
    
    % iterations
    iter = 0;
    N = size(micArray,1);
    [D5,D4] = getMatrices(x,micArray);
    r = objectiveR(D4,sonicSpeed,dT);
    while sum(r.^2) > params.accuracy && iter < params.maxn
        J = (D5(2:N,:) - ones(N-1,1)*D5(1,:))/sonicSpeed;
        J1 = J';
        J2 = J1*J;
        y = x - J2\J1*r;
        x = y;
        [D5,D4] = getMatrices(x,micArray);
        r = objectiveR(D4,sonicSpeed,dT);
        iter = iter + 1;
    end
end
 
function [D5,D4,D3,D2,D1] = getMatrices(x,M)
    D1 = ones(size(M,1),1)*x - M;
    D2 = D1.^2;
    D3 = sum(D2,2);
    D4 = sqrt(D3);
    D5 = D1./(D4*ones(1,3));
end
 
function r = objectiveR(D4,s,dT)
    n = size(D4,1);
    r = (D4(2:n)-ones(n-1,1)*D4(1))/s - dT(2:n);
end
