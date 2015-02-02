function filterbuilder_i(varargin)
%FILTERBUILDER   Filter Design Dialog.
%   FILTERBUILDER(RESP) launches the filter design dialog for the specified
%   filter response RESP.  RESP can be any of the following strings.
%
%   'lp' 'lowpass'      - Lowpass filter design
%   'hp' 'highpass'     - Highpass filter design
%   'bp' 'bandpass'     - Bandpass filter design
%   'bs' 'bandstop'     - Bandstop filter design
%   'hb' 'halfband'     - Halfband filter design (*)
%   'nyquist'           - Nyquist filter design (*)
%   'diff'              - Differentiator filter design
%   'hilb'              - Hilbert filter design
%   'cic'               - Cascaded Integrator-Comb filter design (*)
%   'ciccomp'           - CIC compensator design (*)
%   'isinclp'           - Inverse sinc lowpass filter design (*)
%   'fracdelay'         - Fraction delay filter design (*)
%   'octave'            - Octave filter design (*)
%   'peak'              - Peaking filter design (*)
%   'notch'             - Notching filter design (*)
%   'parameq'           - Parametric equalizer design (*)
%   'arbmag'            - Arbitrary magnitude filter design
%   'pulseshaping'      - Pulse shaping filter design
%
%   FILTERBUILDER(H) launches the appropriate filter design dialog on the
%   filter object H.  H must have been designed using the filter design
%   dialog or an FDESIGN object.
%
%   (*) Filter Design Toolbox required
%
%   See also FDESIGN.

%   Author(s): J. Schickler
%   Copyright 2006-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2008/12/04 23:19:04 $

% Parse the inputs
[resp Hd] = parseInputs(varargin{:});
if isempty(resp), return; end

% Perform partial string completion to get a "valid" response.
validresp = getValidResponse(resp);

% Get the constructor and any set operations that are needed.
[resp, setops] = getConstructor(validresp);

% Build the object.
hdesigner = feval(resp, 'OperatingMode', 'MATLAB');

% If we have a DFILT use it to populate the GUI.
if ~isempty(Hd)
    setGUI(hdesigner, Hd);
    name = inputname(1);
    if ~isempty(name)
        set(hdesigner, 'VariableName', name);
    end
elseif ~isempty(setops)
    set(hdesigner, setops{:});
end

% always use "ifilt" for filter name
set(hdesigner, 'VariableName', 'ifilt');

% Render the dialog.
hdlg = DAStudio.Dialog(hdesigner);
%hdlg.enableApplyButton(true);

% -------------------------------------------------------------------------
function [resp setops] = getConstructor(validresp)

setops = {};

% Convert the response to the object constructor.
switch validresp
    case {'lowpass', 'lp'}
        resp = 'FilterDesignDialog.LowpassDesign';
    case {'highpass', 'hp'}
        resp = 'FilterDesignDialog.HighpassDesign';
    case {'bandpass', 'bp'}
        resp = 'FilterDesignDialog.BandpassDesign';
    case {'bandstop', 'bs'}
        resp = 'FilterDesignDialog.BandstopDesign';
    case {'halfband', 'hb'}
        resp = 'FilterDesignDialog.HalfbandDesign';
    case 'nyquist'
        resp = 'FilterDesignDialog.NyquistDesign';
    case 'differentiator'
        resp = 'FilterDesignDialog.DifferentiatorDesign';
    case 'hilbert transformer'
        resp = 'FilterDesignDialog.HilbertDesign';
    case {'cic', 'cascaded integrator-comb'}
        resp = 'FilterDesignDialog.CICDesign';
    case {'ciccomp', 'cic compensator'}
        resp = 'FilterDesignDialog.CICCompDesign';
    case {'isinclp', 'inverse-sinc lowpass'}
        resp = 'FilterDesignDialog.ISincLPDesign';
    case {'fracdelay', 'fractional delay'}
        resp = 'FilterDesignDialog.FracDelayDesign';
    case {'arbmag', 'arbitrary magnitude', 'arbitrary response'}
        resp = 'FilterDesignDialog.ArbMagDesign';
    case {'arbmagnphase', 'arbitrary magnitude and phase'}
        resp = 'FilterDesignDialog.ArbMagDesign';
        setops = {'ResponseType', 'Frequency response'};
    case 'octave'
        resp = 'FilterDesignDialog.OctaveDesign';
    case {'peak', 'notch', 'peaking filter', 'notching filter'}
        resp = 'FilterDesignDialog.PeakNotchDesign';
        setops = {'ResponseType', validresp(1:4)};
    case {'parameq', 'parametric equalizer'}
        resp = 'FilterDesignDialog.ParamEqDesign';
    case {'pulse shaping', 'pulseshaping'}
        resp = 'FilterDesignDialog.PulseShapingDesign';
end

% -------------------------------------------------------------------------
function validresp = getValidResponse(resp)

% List of the valid responses.
validresps_spt = {'lowpass', 'lp', 'highpass', 'hp', 'bandpass', 'bp', ...
    'bandstop', 'bs', 'differentiator', ...
    'hilbert transformer', 'arbmag', 'arbitrary magnitude',...
    'arbitrary response', 'pulse shaping', 'pulseshaping'};

validresps_fdtbx = {
    'halfband', 'hb', 'nyquist', 'cascaded integrator-comb', 'cic', 'ciccomp', ...
    'cic compensator', 'isinclp', 'inverse-sinc lowpass', 'fracdelay', ...
    'fractional delay', 'octave', ...
    'peak', 'notch', 'peaking filter', 'notching filter', 'parameq', ...
    'parametric equalizer', 'arbmagnphase', 'arbitrary magnitude and phase'};

validresps = {validresps_spt{:}, validresps_fdtbx{:}};

% Find the passed response in the valid responses.  STRNCMPI is used for
% partial string completion.
indx = find(strncmpi(resp, validresps, length(resp)));

% Error if we do not have exactly 1 found response.
if isempty(indx)
    error(generatemsgid('InvalidEnum'),'''%s'' is not a recognized filter response.', resp);
elseif length(indx) > 1
    % If we have a collision check for an exact match.  This is for the
    % 'cic' case.
    indx = find(strcmpi(resp, validresps));
    if isempty(indx)
        error(generatemsgid('GUIErr'),'The filter response ''%s'' is ambiguous.', resp);
    end
end

if ~isfdtbxinstalled && indx>length(validresps_spt)
    error(generatemsgid('InvalidEnum'),'''%s'' is Filter Design Toolbox required.', resp);
end

validresp = validresps{indx};

% -------------------------------------------------------------------------
function [resp Hd] = parseInputs(varargin)

Hd = [];

if nargin < 1
    % List all of the responses with their full names, to hard code the
    % list instead of function query dues to performance reason.
    entries = {'Lowpass', ...
        'Highpass', ...
        'Bandpass', ...
        'Bandstop', ...
        'Differentiator', ...
        'Hilbert Transformer', ...
        'Arbitrary Response', ...
        'Pulse Shaping'
        };
    if isfdtbxinstalled
        entries = {entries{:},...
            'Nyquist', ...
            'Halfband', ...
            'Cascaded Integrator-Comb', ...
            'CIC Compensator', ...
            'Inverse-sinc Lowpass', ...
            'Octave', ...
            'Peak', ...
            'Notch', ...
            'Parametric Equalizer', ...
            'Fractional Delay'};
    end
    % Bring up a LISTDLG to let the user select the response.
    [selection, ok] = listdlg('PromptString', 'Select a filter response:', ...
        'SelectionMode', 'single', ...
        'ListSize', [200 180], ...
        'InitialValue', 1, ...
        'Name', 'Response Selection', ...
        'ListString', entries);
    
    % If OK was not pressed, return.
    if ok
        resp = entries{selection};
    else
        resp = '';
    end
elseif isa(varargin{1}, 'dfilt.basefilter')
    
    % If we are passed a filter, get the type from the class name of the
    Hd = varargin{1};
    hfdesign = getfdesign(Hd);
    if isempty(hfdesign)
        error(generatemsgid('GUIErr'),'No design found, cannot edit filter.');
    end
    
    resp = get(hfdesign, 'Response');
elseif ischar(varargin{1})
    resp = varargin{1};
else
    error(generatemsgid('InvalidParam'),'Invalid input.');
end

% [EOF]
