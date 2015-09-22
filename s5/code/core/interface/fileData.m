function varargout = fileData( fileIdx, varargin )
%FILEDATA get file information
    global control;
    [varargout{1:nargout}] = control.app.getFileData(fileIdx,varargin{:});
end

