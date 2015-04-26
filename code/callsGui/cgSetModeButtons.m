function [ output_args ] = cgSetModeButtons( input_args )
%CGSETMODEBUTTONS -INTERNAL- Enable or disable the sliders and buttons 
%according to display/processing mode.

    global control;
    global c;
    handles = cgGetHandles();
    
    % display vs. processing mode
    if control.cg.mode == c.display
        
        % disable processing knobs and levers
        set( findall(handles.panelProcCheckboxes, '-property', 'Enable'), 'Enable', 'off');
        set(handles.panelProcCheckboxes,   'Visible', 'off'  );
        set( findall(handles.panelButtons, '-property', 'Enable'), 'Enable', 'off');
        set( findall(handles.panelSliders, '-property', 'Enable'), 'Enable', 'off');
        set(handles.pbManual,              'Enable',  'off' );
        set(handles.dfaMenu,               'Enable',  'off' );
        
        % enable display radiobuttons
        set( findall(handles.panelProcRadiobuttons, '-property', 'Enable'), 'Enable', 'on');
        set(handles.panelProcRadiobuttons, 'Visible', 'on' );
        
    else
       
        % enable processing knobs and levers
        set( findall(handles.panelProcCheckboxes, '-property', 'Enable'), 'Enable', 'on');
        set(handles.panelProcCheckboxes,   'Visible', 'on'  );
        set( findall(handles.panelButtons, '-property', 'Enable'), 'Enable', 'on');
        set( findall(handles.panelSliders, '-property', 'Enable'), 'Enable', 'on');
        set(handles.pbManual,              'Enable',  'on' );
        set(handles.dfaMenu,               'Enable',  'on' );
        
        % disable display radiobuttons
        set( findall(handles.panelProcRadiobuttons, '-property', 'Enable'), 'Enable', 'off');
        set(handles.panelProcRadiobuttons, 'Visible', 'off' );

        
    end


end

