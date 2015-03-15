function [ i ] = mgGetSliderStep(  )
%MGGETSLIDERSTEP Get the current position of the slider

    [~,slider] = mgGetHandles('sliderChannels');
    if strcmp(get(slider, 'Visible'),'on')
        M = get(slider, 'Max');
        v = get(slider, 'Value');
        i = M - v;
    else
        i = 0;
    end

end

