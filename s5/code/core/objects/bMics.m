classdef bMics < handle
    %BMICS Batalef - Microphones Array Object
    
    properties
        N
        Positions
        GainVector
        Directionality
        UseInMatching
        UseInLocalization
        UseInBeam
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMics(nMics)
        %BMICS Constructor
        %    h = bMics(NMICS) returns the object's handle, with NMICS the
        %    number of mics to handle
            me.N = nMics;
            me.Positions         = zeros(nMics,3);
            me.GainVector        = zeros(nMics,1);
            me.UseInMatching     = true(nMics,1);
            me.UseInLocalization = true(nMics,1);
            me.UseInBeam         = true(nMics,1);
            me.Directionality.Manage       = false;
            me.Directionality.Matrix       = zeros(0,3);
            me.Directionality.FreqSpecific = {};
            me.Directionality.Zero         = [0,0,0];
        end
        
        % TRANSLATE TO EXPORTABLE STRUCTURE
        function X = toStruct(me)
            X.N                 = me.N;
            X.Positions         = me.Positions;
            X.GainVector        = me.GainVector;
            X.Directionality    = me.Directionality;
            X.UseInMatching     = me.UseInMatching;
            X.UseInLocalization = me.UseInLocalization;
            X.UseInBeam         = me.UseInBeam;
        end
        
        % SET POSITIONS MATRIX
        function setPositions(me,positions)
            positions = me.enforceSize(positions);
            s = size(positions);
            if s(2) ~= 3
                err = MException('batalef:mics:wrongSize',...
                        sprintf('Microphones: input size [%i,%i] is invalid for 3d positions',s(1),s(2)));
                throw(err);
            end
            
            me.Positions = positions;
            
        end
        
        % SET GAIN VECTOR
        function setGainVector(me,gains)
            gains = me.enforceSize(gains);
            s = size(gains);
            if s(2) ~= 1
                err = MException('batalef:mics:wrongSize',...
                        sprintf('Microphones: input size [%i,%i] is invalid for 1d gain vector',s(1),s(2)));
                throw(err);
            end
            
            me.GainVector = gains;            
        end
        
        % SET DIRECTIONALITY MATRIX
        function setDirectionalityData(me,directMatrix)
            me.Directionality.Matrix       = zeros(0,3);
            me.Directionality.FreqSpecific = {};
            
            if isempty(directMatrix)
                return;
            end
            
            % [angle,freq,gain]
            s = size(directMatrix);
            if s(2) ~= 3
                err = MException('batalef:mics:wrongSize',...
                        sprintf('Microphones: input size [%i,%i] is invalid for 3d directionality data',s(1),s(2)));
                throw(err);
            end
            
            me.Directionality.Matrix = directMatrix;
            
            C = cell(0,3); % {freq,vector,surface}
            % create a vector of angles-gains for each frequency
            for i = 1:size(directMatrix,1)
                if isempty(C)
                    cellIdx = [];
                else
                    cellIdx = find([C{:,1}]==directMatrix(i,1),1);
                end
                if isempty(cellIdx)
                    cellIdx = size(C,1)+1;
                    C{cellIdx,1} = directMatrix(i,1);
                end
                V = C{cellIdx,2};
                V = [V; directMatrix(i,[2,3])];
                C{cellIdx,2} = V;
            end
            
            % create interpolated surface for each frequency
            A = linspace(0,180,18000);
            for i = size(C,1)
                V = C{i,2};
                C{i,3} = interp1(V(:,1),V(:,2),A,'linear','extrap');
            end
            
            me.Directionality.FreqSpecific = C;
        end
        
        
        % INTERPOLATE DIRECTIONALITY FOR FREQ AND ANGLE
        function gain = directionalGain(me, angle, freq)
            angleIdx = floor(angle*100);
            n = size(me.Directionality.FreqSpecific,1);
            vF = zeros(n,1);
            vG = zeros(n,1);
            for i = 1:n
                vF(i) = me.Directionality.FreqSpecific{i,1};
                vG(i) = me.Directionality.FreqSpecific{i,3}(angleIdx);
            end
            gain = interp1(vF,vG,freq,'linear','extrap');
        end
        
    end
    
    % HIDDEN INSTANCE METHODS
    methods (Hidden)
        % ENFORCE NUMBER OF MICS FOR ROWS DIMENSION
        function matOut = enforceSize(matIn)
            s = size(matIn);
            if s(1) == me.N
                matOut = matIn;
            elseif s(2) == me.N
                matOut = matIn';
            else
                err = MException('batalef:mics:wrongSize',...
                        sprintf('Microphones: input size [%i,%i] is invalid for #mics of %i',s(1),s(2),me.N));
                throw(err);
            end
        end        
    end
    
    % STATIC METHODS
    methods(Static)
       
        % CREATE OBJECT FROM STRUCT
        function O = buildObject(X)
            O = bMics(X.N);
            O.Positions         = X.Positions;
            O.GainVector        = X.GainVector;
            O.Directionality    = X.Directionality;
            O.UseInMatching     = X.UseInMatching;
            O.UseInLocalization = X.UseInLocalization;
            O.UseInBeam         = X.UseInBeam;            
        end
        
    end
    
end