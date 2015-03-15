function [  ] = mgSetSlider( revalue, newvalue )
%MGSETSLIDER Summary of this function goes here
%   Detailed explanation goes here

    handles = mgGetHandles();
    
    if isempty(appData('Channels','Filtered'))
        set(handles.sliderChannels, 'Visible', 'off');
        return;
    end
    
    steps = mgSliderGetSteps();
    if steps == 1
        set(handles.sliderChannels, 'Value', 0);
        set(handles.sliderChannels, 'Visible', 'off');
    else
        m = steps - 1;
        set(handles.sliderChannels, 'Max', m);
        set(handles.sliderChannels, 'SliderStep', [1,1]./double(m));
        if exist('revalue','var') && revalue
            set(handles.sliderChannels, 'Value', m-newvalue );
        else
            set(handles.sliderChannels, 'Value', m ); %...
            %get(handles.sliderChannels, 'Value') + n);
        end
        set(handles.sliderChannels, 'Visible', 'on');
    end
end

