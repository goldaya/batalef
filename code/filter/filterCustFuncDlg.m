function [ out, cancel ] = filterCustFuncDlg(  )
%FILTERCUSTFUNCDLG Dialog to get a filter function

    title = 'Custom Function Filter';
    Q{1} = 'Function name in base worksapce. must accept Dataset and Fs as inputs';
    
    A = inputdlg(Q,title,[1,70]);
    
    if isempty(A)
        out = [];
        cancel = true;
    else
        out = A{1};
        cancel = false;
    end
               
end

