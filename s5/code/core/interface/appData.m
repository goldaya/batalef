function [ varargout ] = appData( varargin )
%APPDATA Application data

    global control;
    [varargout{1:nargout}] = control.app.getAppData(varargin{:});

end

