function [  ] = initB(  )
%INITB Initialize the Batalef environment

    global filesObject;
    global control;
    global c;
    
    
    % init files object
    filesObject = struct([]);
    

    % init control
    control.params.currentFile = 'default.bpf';
    control.specClicks = 0;
    control.specStartLine = [];
    control.tsPlot = [];
    control.peaksPlot = [];
    control.envelopeCustomFunction = '';
    control.pwpdIntervals = [];

    control.mg.fig = [];
    control.cg.fig = [];
    control.fpg.fig = [];
    control.sog.fig = [];
    control.sug.fig = [];
    control.mpg.fig = [];
    control.mcg.fig = [];
    control.pwpdg.fig = [];


    % parameters
    fid = fopen('./common/default.bpf');
    C = textscan(fid, '%s %s %f'); % name, type, value(float)
    fclose(fid);
    C{3} = num2cell(C{3});
    control.params.common = C;
    loadParametersFile('./user/default.bpf');
    control.params.dialog = true;
    
    control.askOverwrite = c.never;

    control.spectrum.method = getParam('spectrum:method');
    control.envelope.method = getParam('envelope:method');
    control.spectrogram.method = getParam('spectrogram:method');
    control.ridge.method = getParam('ridge:method');
    control.beam.method = getParam('beam:method');
    
    control.mg = [];
    control.mg.k = 0;
    control.mg.lockZoom = false;
    control.mg.axesMode = c.tight;
    control.mg.linkAxes = false;
    control.mg.channelsFilter = [];
    control.mg.nAxes = 1; % this value is for startup, dont change!
    control.mg.axesHeight = getParam('mainGUI:axesHeight');
    control.mg.tm.startVerticalLines = [];
    control.mg.tm.endVerticalLines = [];
    control.mg.tm.on = false;
    control.mg.so.startVerticalLines = [];
    control.mg.so.endVerticalLines = [];
    control.mg.so.on = false;
    control.mg.su.startVerticalLines = [];
    control.mg.su.endVerticalLines = [];
    control.mg.su.on = false;
    control.mg.Mpwpd.startVerticalLines = [];
    control.mg.Mpwpd.endVerticalLines = [];
    control.mg.Rm.startVerticalLines = [];
    control.mg.Rm.endVerticalLines = [];
    control.mg.Rm.on = false;
    control.mg.callsMarks = [];
    control.mg.callsNumbers = [];
    
    control.sog.tm.startVerticalLines = [];
    control.sog.tm.endVerticalLines = [];
    control.sog.tm.on = false;

end