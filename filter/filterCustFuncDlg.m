function [ out ] = filterCustFuncDlg(  )
%FILTERCUSTFUNCDLG Dialog to get a filter function

    title = 'Custom Function Filter';
    Q{1} = 'Function name in base worksapce. must accept Dataset and Fs as inputs';
    
    A = inputdlg(Q,title,[1,70]);
    
    out = A{1};
    
end

