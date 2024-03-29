function [ do, percentile, minDistance, replace, channel, filter, fixedThreshold ] = pdBasicAsk( dialog )
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
    
    Q{2} = 'Fixed threshold (No/<value>)';
    fixedThreshold = getParam('peaks:fixedThreshold');
    if fixedThreshold == 0
        D{2} = 'No';
    else
        D{2} = num2str(fixedThreshold);
    end
    
    Q{3} = 'Minimal distance between peaks (msec)';
    D{3} = num2str(getParam('peaks:minDistance'));
    
    Q{4} = 'Filter (No/Butter/Function/Builder)';
    switch getParam('peaks:filter')
        case c.butter
            D{4} = 'Butter';
        case c.function
            D{4} = 'Function';
        case c.builder
            D{4} = 'Builder';
        otherwise
            D{4} = 'No';
    end
    
    Q{5} = 'Channels to work on. Could be a single index or " All " ';
    D{5} = 'All';
    

    Q{6} = 'New peaks: Replace/Add';
    D{6} = 'Replace';

    if dialog
    ready = false;
    title = 'Peak Detection';
    while ~ready
        A = inputdlg(Q,title,[1,70],D);  
    
        % exit on cancel
        if isempty(A)
            return;
        end
    
        switch A{6}
            case 'Replace'
                replace = true;
            case 'Add'
                replace = false;
            otherwise
                title = 'Peak Detection - Wrong Replacement parameter: use "Add" or "Replace"';
                D = A;
                continue;
        end
        
        switch A{4}
            case 'No'
                filter = [];
                filterType = c.no;
            case 'Butter'
                [params, filter, cancel] = filterButterDlg();
                if cancel
                   return; 
                else
                    filterButterKeepValues(params.type,params.order,params.f1,params.f2);
                end
                if ~isempty(params)  && isempty(filter)
                    filter = params;
                end
                if ~isempty(filter) && isstruct(filter)
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
        
        if strcmp(A{5},'All')
            channel = 'All';
        elseif isnan(str2double(A{5}))
            title = 'Peak Detection - Wrong channel specification';
            D = A;
            continue;
        else
            channel = str2double(A{5});
        end
        
        ready = true;
        
    end
    else
        A = D;
        filterType = getParam('filter:butter:type');
        if filterType == c.butter
            filter.method = c.butter;
            filter.f1 = num2str(getParam('filter:butter:f1'));
            filter.f2 = num2str(getParam('filter:butter:f2'));
            filter.order = num2str(getParam('filter:butter:order'));  
        end        
    end
    
    do = true;
    percentile = str2double(A{1});
	minDistance = str2double(A{3});
    if strcmp(A{2},'No')
        fixedThreshold = 0;
    else
        fixedThreshold = str2double(A{2});
    end
    
    
    % keep values
    if isempty(filter)
        filterType = c.none;
    end
    setParam('peaks:filter',filterType);
    setParam('peaks:percentile',percentile);
    setParam('peaks:minDistance',minDistance);
    setParam('peaks:fixedThreshold',fixedThreshold);
    
end

