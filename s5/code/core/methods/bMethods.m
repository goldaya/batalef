classdef bMethods < handle
    
    properties (Access = {?bApplication,?bMethodSpectrogram,?bMethodFilter,?bMethodEnvelope,?bMethodDetection})
        GuiTop
        Type
        Methods = [];
        Menus
        Default
        DefinitionExtention
        ParamPreamble
        Application
        RefreshGui = false;
    end
    
    
    methods
        
        % SUPERCLASS CONSTRUCTOR
        function me = bMethods(type,paramPreamble,definitionExtention,app,gui,withNone)
            me.ParamPreamble       = paramPreamble;
            me.Type                = type;
            me.DefinitionExtention = definitionExtention;
            me.Application         = app;
            me.GuiTop              = gui;
            
            if withNone
                m.id = 'none';
                m.name = 'None';
                m.func = [];
                m.params = [];
                me.Methods{1} = m;
            end
            me.readMethods();
            
            % select appropriate method
            if strcmp(type,'default') && ~isempty(me.Methods)
                if isempty(gui)
                    p = me.Application.Parameters;
                else
                    p = me.GuiTop.Parameters;
                end
            
                dpar = strcat('methods_',me.ParamPreamble,'_defMethod');
                if p.has(dpar)
                    me.Default = p.get(dpar);
                else
                    me.Default = me.Methods{1}.id;
                    p.add(dpar,me.Methods{1}.id,'string');
                end
            end
        end
        
        % READ METHODS
        function readMethods(me)
            F = rdir(me.Application.BatalefDirectory,strcat('*_',me.DefinitionExtention,'_bmd.m'));
            for i = 1:length(F)
                m = me.readDefinitionFile(F(i).fullpath);
                try
                    me.register(m);
                catch err
                    if strncmp(err.identifier,'batalef:defaultMethods',22)
                        disp(err.message);
                    else
                        err.rethrow();
                    end
                end
            end
        end
        
        
        % READ METHOD DEFINITION FILE
        function m = readDefinitionFile(~,definitionFile)
            run(definitionFile) 
            try
                m.id   = id;
                m.name = name;
                m.func = func;
                if exist('params','var')
                    m.params = params;
                end
                % extra method-type-specific data
                % (currently for channel calls detection only)
                if exist('extra','var') 
                    m.extra = extra;
                end
            catch err
                if strcmp(err.identifier,'MATLAB:UndefinedFunction')
                    m = [];
                    return;
                else
                    err.rethrow();
                end
            end
        end
            
        % EXISTS            
        function val = exists(me, id)
            if isempty(me.Methods)
                val = false;
            else
                val = max(strcmp(id,cellfun(@(m) m.id,me.Methods,'UniformOutput',false)));
            end
        end
        
        % GET METHOD
        function m = getMethod(me, id)
            I = find(strcmp(id,cellfun(@(m) m.id,me.Methods,'UniformOutput',false)),1);
            if isempty(I)
                errstr = sprintf('No such method id: %s',id);
                errid  = 'batalef:methods:noMethod';
                err    = MException(errid,errstr);
                throwAsCaller(err);
            end
            m = me.Methods{I};
        end
        
        % REGISTER
        function register(me, method)
            % check first func is accessible
            if isempty(which(method.func))
                errstr = sprintf('The function %s is inaccessible',method.func);
                err = MException('batalef:defaultMethods:functionInaccessible',errstr);
                throw(err);
            end
               
            % check method is already registered
            if me.exists(method.id)
                errstr = sprintf('Already have method %s.',method.id);
                errid  = 'batalef:defaultMethods:alreadyExists';
                err = MException(errid,errstr);
                throw(err);
            end
            
            % add
            me.Methods = [me.Methods;{method}];
            
        end
        
        % CREATE MENU
        function createMenu(me,menu,gui)
            me.Menus = [me.Menus,{menu}];
            for i = 1:length(me.Methods)
                uimenu(menu,'Label',me.Methods{i}.name,...
                    'UserData',{me.Methods{i}.id,gui},...
                    'Callback',@(h,~)me.onGuiMethodSelection(h));
            end
            if strcmp(me.Type,'default')
                selectMenuItem(menu,me.Default);
            end
                
        end
        
        % REMOVE MENU FROM LIST
        function removeMenu(me,menu)
            I = cellfun(@(m) m==menu,me.Menus);
            me.Menus(I) = [];
        end

        % ON GUI METHOD SELECTION
        function onGuiMethodSelection(me,h)
            userData = get(h,'UserData');
            methodID = userData{1};
            switch me.Type
                case 'default'
                    cellfun(@(m) selectMenuItem(m,methodID),me.Menus);
                    me.askParamsGui(methodID,[]);
                    me.Default = methodID;
                case 'onDemend'
                    me.Default = methodID;
                    me.askParamsGui(methodID,[]);
                    gui = userData{2};
                    me.executeGOD(gui);
            end
            
        end
        
        % GUI PROMPT
        function askParamsGui(me,id,file)
            m = me.getMethod(id);
            [Q,D,P] = buildParamList(me,m,file);
            if isempty(Q)
            else
                title = sprintf('Parameters for %s',m.name);
                D = cellfun(@(d) {num2str(d)},D);
                A = inputdlg(Q,title,[1,70],D);
                if isempty(A)
                    % do nothing
                else
                    me.saveParams(P,A);
                end
            end
        end
        
        % CLI PROMPT
        function askParamsCli(me,id,file) %#ok<INUSD>
        end
        
        % BUILD PARAMS LIST
        function [Q,D,P] = buildParamList(me,m,file)
            Q = cell(length(m.params),1);
            D = cell(length(m.params),1);
            P = cell(length(m.params),3);
            for i = 1:length(m.params)
                switch m.params(i).ptype
                    case 'app'
                        p = me.Application.Parameters;
                    case 'gui'
                        if isempty(me.GuiTop)
                            errstr = sprintf('Method has gui-parameter but there is no gui.\nMethod: %\nParameter(id/name): %s / %s', m.name,m.params(i).id,m.params(i).name);
                            errid  = 'batalef:methods:parameters:guiParam4NonGuiUse';
                            err    = MException(errid,errstr);
                            throwAsCaller(err);                            
                        else
                            p = me.GuiTop.Parameters;
                        end
                    case 'file'
                        if exist('file','var') && ~isempty(file)
                            p = file.Parameters;
                        else
                            errstr = sprintf('Method has file-parameter for non file based use.\nMethod: %\nParameter(id/name): %s / %s', m.name,m.params(i).id,m.params(i).name);
                            errid  = 'batalef:methods:parameters:fileParam4NonFileUse';
                            err    = MException(errid,errstr);
                            throwAsCaller(err);
                        end
                end
                pID = me.getFullParamID(m.id,m.params(i).id);
                if p.has(pID)
                    pValue = p.get(pID);
                else
                    p.add(pID,m.params(i).value,m.params(i).dtype)
                    pValue = m.params(i).value;                    
                end
                
                Q{i} = m.params(i).name;
                D{i} = pValue;
                P{i,1} = p;
                P{i,2} = pID;
                P{i,3} = m.params(i).id;

            end

        end
        
        % GET PARAM FULL ID
        function pFullID = getFullParamID(me,mid,pid)
            pFullID = strcat('methods_',me.ParamPreamble,'_',mid,'_',pid);
        end            
        
        % SAVE PARAMS
        function saveParams(me,P,A) %#ok<INUSL>
            for i = 1:length(P)
                o = P{i,1};
                p = P{i,2};
                if strcmp(o.getType(p),'string');
                    v = A{i};
                else
                    v = str2num(A{i}); %#ok<ST2NM>
                end
                o.set(p,v); 
            end
        end
        
    end
end

