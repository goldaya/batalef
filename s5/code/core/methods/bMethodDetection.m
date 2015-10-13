classdef bMethodDetection < bMethods
    %BMETHODDETECTION Channel-Calls Detection methods handling & execution
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodDetection(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'detection',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [detections] = execute(me,dataset,envDataset,Fs)
        %[detections] = EXECUTE(dataset,Fs) : execute the detection method
        %   dataset is a subset of a single channel TS
        %   Fs is the sampling frequency
        %   detections is a Nx2 matrix, each row is a detection and has the
        %   time in column 1 and the amplitude value in column 2
            m = me.getMethod(me.Default);
            [~,D,P] = buildParamList(me,m);
            for i = 1:length(D)
                params.(P{i,3}) = D{i};
            end
            methodFunc = str2func(m.func);
            [detections] = ...
                methodFunc(dataset,envDataset,Fs,params);
        end
       
        function executeGOD(me,gui)
        %   On Demend execution in GUI
            P = gui.ProcessVector;
            Files = me.Application.Files(P);
            cellfun(@(f) me.augustinus(f,gui),Files,'UniformOutput',false);
            if me.RefreshGui
                gui.refresh();
            end
            msgbox('Finished calls detection');
        end
        
        function augustinus(me,File,gui)
            % break file into segments and execute
            
            switch gui.DetectionSettings.segmentation.type
                case 'none'
                    seg = {[]};
                case 'piecewise'
                    window  = gui.DetectionSettings.segmentation.params.window;
                    overlap = gui.DetectionSettings.segmentation.params.overlap;
                    delta   = window - overlap;
                    T = File.RawData.Length;
                    t = 0;
                    i = 0;
                    while t < T
                        dt = [0, window] + i*delta;
                        t = dt(2);
                        if dt(2) > T
                            dt(2) = T;
                        end
                        i = i + 1;
                        seg{i} = dt; %#ok<AGROW>
                    end
                case 'manual'
                    seg{1} = gui.DetectionSettings.segmentation.params.interval;
            end
            
            cellfun(@(dt) me.florence(File,dt),seg);
            
        end
        
        function florence(me,File,dt)
        %FLORENCE detection in a segment - for a file
                    
            % retrieve TS
            dataset = File.RawData.getTS([],dt);
            Fs = File.Fs;
            
            % execute for each channel
            if isempty(dt)
                dt = [0,File.Length];
            end
            cellfun(@(j) me.theMachine(File.channel(j),dataset(:,j),Fs,dt(1)),num2cell(1:File.ChannelsCount));
                        
        end
        
        function theMachine(me,Channel,dataset,Fs,timeOffset)
        %THEMACHINE filteration, envelope and detection for a single
        %channel + save
            
            m = me.getMethod(me.Default);
            
            % filteration
            dataset = me.Application.Methods.detectionFilter.execute(dataset,Fs);
            
            % envelope
            if m.extra.needEnv
                envDataset = me.Application.Methods.detectionEnvelope.execute(dataset,Fs);
            else
                envDataset = [];
            end
            
            % drop TS if unneeded
            if ~m.extra.needTS
                dataset = [];
            end
            
            % detection
            D = me.execute(dataset,envDataset,Fs);
            
            % save to data structure
            T = D(:,1) + timeOffset;
            A = D(:,2);
            Channel.addCalls([T,A],[],[],[],[]);
        end
        
        
    end
        
end

