function [] = axesMousePosition(varargin)
    % WindowButtonMotionFcn for the figure.
    
    S = varargin{3};  % Get the structure.
    F = get(S.fh,'currentpoint');  % The current point w.r.t the figure.
    % Figure out of the current point is over the axes or not -> logicals.
    for i = 1:length(S.objs)
        O = S.objs(i);
        tf1 = O.AXP(1) <= F(1) && F(1) <= O.AXP(1) + O.AXP(3);
        tf2 = O.AXP(2) <= F(2) && F(2) <= O.AXP(2) + O.AXP(4);

        if tf1 && tf2
            % Calculate the current point w.r.t. the axes.
            Rx =  (F(1)-O.AXP(1))/O.AXP(3);
            Ry =  (F(2)-O.AXP(2))/O.AXP(4);
            O.callback(O.handle,Rx, Ry);

        end
    end
end