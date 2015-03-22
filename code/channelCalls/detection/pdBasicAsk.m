function [ do, percentile, minDistance, replace, channel, filter ] = pdBasicAsk(  )
%PDBASICASK Get basic peak detectin parameters from user


    global c;
    
    do = false;
    percentile = 0;
    minDistance = 0;
    replace = false;
    filter = [];
    channel = 0;
    

    % ask for parameters
    Q{1} = 'Percentile';
    D{1} = num2str(getParam('peaks:percentile'));
    
    Q{2} = 'Minimal distance between peaks (msec)';
    D{2} = num2str(getParam('peaks:minDistance'));
    
    Q{3} = 'Filter (No/Butter/Function/Builder)';
    switch getParam('peaks:filter')
        case c.butter
            D{3} = 'Butter';
        case c.function
            D{3} = 'Function';
        case c.builder
            D{3} = 'Builder';
        otherwise
            D{3} = 'No';
    end
    
    Q{4} = 'Channels to work on. Could be a single index or " All " ';
    D{4} = 'All';
    

    Q{5} = 'New peaks: Replace/Add';
    D{5} = 'Replace';

    
    ready = false;
    title = 'Peak Detection';
    while ~ready
        A = inputdlg(Q,title,[1,70],D);  
    
        % exit on cancel
        if isempty(A)
            return;
        end
    
        switch A{5}
            case 'Replace'
                replace = true;
            case 'Add'
                replace = false;
            otherwise
                title = 'Peak Detection - Wrong Replacement parameter: use "Add" or "Replace"';
                D = A;
                continue;
        end
        
        switch A{3}
            case 'No'
                filter = [];
                filterType = c.no;
            case 'Butter'
                [filter, cancel] = filterButterDlg();
                if cancel
                   return; 
                end
                if ~isempty(filter)
                    filter.method = c.butter;
                    filterType = c.butter;
                end
            case 'Function'
                [filter, cancel] = filterCustFuncDlg();
                if cancel
                    return
                end
                if ~isempty(filter)
                    filter.method = c.function;
                    filterType = c.function;
                end
            case 'Builder'
                [filter, cancel] = filterBuilderGetFilter();
                if cancel
                    return;
                end
                if ~isempty(filter)
                    filterType = c.builder; 
                end
            otherwise
                title = 'Peak Detection - Wrong Filter Type';
                D = A;
                continue;
        end
        
        if strcmp(A{4},'All')
            channel = 'All';
        elseif isnan(str2double(A{4}))
            title = 'Peak Detection - Wrong channel specification';
            D = A;
            continue;
        else
            channel = str2double(A{4});
        end
        
        ready = true;
        
    end
    
    do = true;
    percentile = str2double(A{1});
	minDistance = str2double(A{2}); 
    
    
    % keep values
    if ~isempty(filter)
        setParam('peaks:filter',filterType);
    end
    setParam('peaks:percentile',percentile);
    setParam('peaks:minDistance',minDistance);
    
end

