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
    n = 0;
    [r,D,R] = ofun(x,micArray,dT,sonicSpeed);
    while sum(r.^2) > params.accuracy
        J = jack(D,R);
        x = x-((J'*J)\J'*r)';
        [r,D,R] = ofun(x,micArray,dT,sonicSpeed);
        
        n = n + 1;
        if n >= params.maxn
            break;
        end
    end

end

% Jacobian
function [J] = jack(D,R)
    
    Nmics = length(R);
    A = D(2:Nmics,:)./(R(2:Nmics)*ones(1,3));
    B = ones(Nmics-1,1)*D(1,:)./R(1);
    J = A - B;
    
end

% objective function 
function [r,D,R] = ofun(x,M,dT,sonic)

    N = size(M,1);
    D = ones(N,1)*x-M;  % Diff matrix
    P = D.^2;                   % Powers of 2 of diff matrix
    R = sqrt(sum(P,2));         % Distance between x and each mic    
    r = R(2:N)-dT(2:N).*sonic-R(1);    

end

