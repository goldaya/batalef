function [ A ] = cbdlg(Q,title,D)
%CBDLG popup a checkbox list for user selection
%   [A] = cbdlg(Q)returns the answers logicals vector A. Each element is a
%   true/false indicator, according to the user choice for the questions in
%   Q, which should be a cell array of strings. In case the user aborted
%   using the "Cancel" button, A will return empty.
%
%   [A] = cbdlg(Q,TITLE) also shows the desired title for the popup.
%
%   [A] = cbdlg(Q,TITLE,D) allows assignment of default answers. D shouuld
%   be a logical vector.

    nQ = length(Q);
    if exist('D','var')
        if length(D) ~= nQ
            errid  = 'cbdlg:dimensionMismatch';
            errstr = 'Dimensions of the questions cell array and the default answers vector mismatch';
            throwAsCaller(MException(errid,errstr));
        end
    else
        D = false(nQ);
    end
    
    
    % create dialog box
    maxStrLen = max(cellfun(@(q)length(q),Q));
    h = 4 + 2*nQ;
    w = max(10+maxStrLen,29);
    scrSize = uiPosition(0,'character');
    dpos = [(scrSize(3)-w)/2,(scrSize(4)-h)/2,w,h];
    d = dialog('Visible','off',...
        'WindowStyle','modal',...
        'Units','character',...
        'Position',dpos,...
        'KeyPressFcn',@(h,e)doFigureKeyPress(h,e)...
        );
    
    % title
    if exist('title','var')
        set(d,'Name',title);
    end
    
    % create buttons
    uicontrol(d,...
        'Style','pushbutton',...
        'Units','character',...
        'Position',[3,1,10,2],...
        'String','OK',...
        'Callback',@(~,~)press('OK')...
        );
    
    uicontrol(d,...
        'Style','pushbutton',...
        'Units','character',...
        'Position',[16,1,10,2],...
        'String','Cancel',...
        'Callback',@(~,~)press('Cancel')...
        );    
    

    % create checkboxes
    CB = arrayfun(@(i)uicontrol(d,'Style','checkbox','Value',D(i),'Units','character','Position',[3,3.5+(nQ-i)*2+0.4,maxStrLen+6,1.2],'String',Q{i}),1:nQ,'UniformOutput',false);

    % display 
    set(d,'Visible','on');
    uiwait(d);
    
    % CALLBACKS
    % on button press
    function press(in)
        switch in
            case 'OK'
                A = cellfun(@(h)get(h,'Value'),CB);
            case 'Cancel'
                A = [];
        end
        uiresume(gcbf);
        delete(d);
    end

    % on keyboard press
    function doFigureKeyPress(obj, evd)  %#ok
        switch(evd.Key)
            case {'return','space'}
                press('OK');
            case 'escape'
                press('Cancel');
        end
    end
end