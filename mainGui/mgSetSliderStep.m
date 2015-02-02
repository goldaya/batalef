function [  ] = mgSetSliderStep( i )
%MGSETSLIDERSTEP Set the slider value according to step

    [~,slider] = mgGetHandles('sliderChannels');
    M = get(slider,'Max');
    v = M - i;
    if v < 0
        return;
    else
        set(slider,'Value',v);
    end

end

