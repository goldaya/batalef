%% Usage of this script by trey:
%% The audiofiles are kept in root/audio/<batname>/audio/
%% This script requires therefore that <batname> be passed as well as <configfile>
%% One likely invocation on the cluster would therefore look like:
%%  bash> cat <<"EOF" | qsub -V -d `pwd` -q long -
%% module add matlab ; matlab -nodesktop -nosplash -r "configfile='default.bpf'; bat='v580'; backgroundFolder; quit;"
%% EOF
%% An important caveat: the qsub on deepthought is different from umiacs's, so that commandline won't work I am betting.
%% Instead: write a script that looks something like:
%% #PBS <put pbs parameters here>
%% cd <workingdirectory>
%% module add matlab && matlab -nodesktop -nosplash -r "configfile='default.bpf'; bat='v580'; backgroundFolder; quit;"
%%
%% Then submit it with 'qsub scriptname.sh'

function [  ] = backgroundFolder(audiopath, bat, configfile, createSecondaryFiles, secondaryConfigfile, matrixOutputOnly)
  %BACKGROUNDFOLDER 
  % init batalef structures
  audiopath = strcat(audiopath, filesep());
  elapsed = cputime;
  starttime = cputime;
  output_str = sprintf('Processing new directory: %s, bat: %s, using config file: %s.', audiopath, bat, configfile);
  disp(output_str);
  global control;
  initC();
  initB();
  global filesObject;
  parFile = dir(configfile);
  if isempty(parFile)
    throw(MException('bats:backgroundRun:noParametersFileInFolder','There is no parameters file in working directory'));
  end
  control.params.currentFile = configfile;
  output_str = sprintf('The parameter file name is: %s', configfile);
  disp(output_str);
  loadParametersFile(configfile);
  envmAdminMethodSelectedInternal(control.envelope.method, true, false);
  somAdminMethodSelectedInternal(control.spectrogram.method, true, false);
  sumAdminMethodSelectedInternal(control.spectrum.method, true, false);

  % add files to system
  audioarg = strcat(audiopath,'*.wav');
  files = dir(audioarg);
  output_str = sprintf('About to process files specified in: %s specified by: %s', audioarg, audiopath);
  disp(output_str);
  disp(files);
  if isempty(files) % do nothing
    return;
  elseif iscell(files) % multiple files
    s = size(files);
    nK = s(2);
    for i=1:nK
      inputfile = strcat(audiopath, files{1,i});
      output_str = sprintf('%d/%d Processing %s', i, nK, inputfile);
      disp(output_str);
      rawData = readRawDataFromFile(inputfile, getParam('rawData:loadWithMatrix'));
      createFileObject(i, audiopath, files{1,i}, rawData);
    end  
  elseif isstruct(files)
    s = size(files);
    nK = s(1);
    for i=1:nK
      inputfile = strcat(audiopath, files(i).name);
      output_str = sprintf('%d/%d Processing %s', i, nK, inputfile);
      disp(output_str);
      rawData = readRawDataFromFile(inputfile, getParam('rawData:loadWithMatrix'));
      createFileObject(i, strcat(audiopath,files(i).name), rawData);
    end          
  elseif files == 0 % user canceled  - do nothing
    return;
  else % single file
    nK = 1;
    rawData = readRawDataFromFile(strcat(audiopath, files),getParam('rawData:loadWithMatrix'));
    createFileObject(1, strcat(audiopath,files), rawData);
  end
  K = 1:nK;
  time_passed = cputime - elapsed;
  fprintf('Adding files to batalef took %d seconds.\n', time_passed);
    % Trim
  trimBuffer = getParam('background:trimStart')/1000;
  if trimBuffer > 0
      elapsed = cputime;
      disp('Trimming Files');
      for k = 1:nK
        removeStartTS(k,trimBuffer,false);
      end
      time_passed = cputime - elapsed;
      fprintf('Trimmed files in %d seconds\n', time_passed);
  else
      disp('Not trimming files');
  end
  % Process
  disp('Running pdBasic');
  elapsed = cputime;
  pdBasic(K,false); % Call Detection
  time_passed = cputime - elapsed;
  output_str = sprintf('pdBasic took %d seconds, starting feature extraction.', time_passed);
  disp(output_str);
  elapsed = cputime;
  fExtraction(K); % Feature Extraction
  time_passed = cputime - elapsed;
  output_str = sprintf('fExtraction took %d seconds.', time_passed);
  disp(output_str);
  
  % secondary files
  %if logical(getParam('background:createSecondaryFiles'))
  if createSecondaryFiles
      disp('---Secondary Files---');
      secParFile = dir(secondaryConfigfile);
      if isempty(secParFile)
        throw(MException('bats:backgroundRun:noParametersFileInFolder','There is no secondary parameters file in working directory'));
      end
      control.params.currentFile = secondaryConfigfile;
      output_str = sprintf('The parameter file name is: %s', secondaryConfigfile);
      disp(output_str);
      loadParametersFile(secondaryConfigfile);     
      envmAdminMethodSelectedInternal(control.envelope.method, true, false);
      somAdminMethodSelectedInternal(control.spectrogram.method, true, false);
      sumAdminMethodSelectedInternal(control.spectrum.method, true, false);      
      
      elapsed = cputime;
      createSecondaryFile( K, true, false, false );
      sK = nK+1 : 2*nK;
      time_passed = cputime - elapsed;
      output_str = sprintf('created secondary files in %d seconds.', time_passed);
      disp(output_str);
      
      trimBuffer = getParam('background:trimStart')/1000;
      if trimBuffer > 0
          elapsed = cputime;
          disp('Trimming Files');
          for k = nK+1:2*nK
            removeStartTS(k,trimBuffer,false);
          end
          time_passed = cputime - elapsed;
          fprintf('Trimmed files in %d seconds\n', time_passed);
      else
          disp('Not trimming files');
      end      
      
      elapsed = cputime;
      disp('Running pdBasic on secondary files')
      pdBasic(sK,false);
      time_passed = cputime - elapsed;
      output_str = sprintf('pdBasic took %d seconds, starting feature extraction.', time_passed);
      disp(output_str);
      fExtraction(K); % Feature Extraction
      time_passed = cputime - elapsed;
      output_str = sprintf('fExtraction took %d seconds.', time_passed);
      disp(output_str);     
      disp('---Ended secondary files processing---');
      nK = 2*nK;
      
      % restore main parameter environment
      control.params.currentFile = parFile.name;
      output_str = sprintf('The parameter file name is: %s', parFile.name);
      disp(output_str);
      loadParametersFile(parFile.name);
      envmAdminMethodSelectedInternal(control.envelope.method, true, false);
      somAdminMethodSelectedInternal(control.spectrogram.method, true, false);
      sumAdminMethodSelectedInternal(control.spectrum.method, true, false);      
  end
  
  % Output
  %{
  switch getParam('background:outputType')
      case 1 % the whole file structure
          disp('Output Type: whole data structure')
          disp('Putting TS in export structures')
          C = cell(nK,1);
          for k = 1:nK
            elapsed = cputime;	
            refreshRawData( k, 1 );
            time_passed = cputime - elapsed;
            output_str = sprintf('%d/%d, %d.', k, nK, time_passed);
            disp(output_str);
            C{k} = filesObject(k);
          end
   
      case 2
          disp('Output Type: channel calls matrices')
          C = cell(nK,2);
          for k=1:nK
             elapsed = cputime;
             C{k,1} = fileData(k,'Name'); 
             C{k,2} = fileData(k,'Channels','Calls','Matrix');
             time_passed = cputime - elapsed;
             output_str = sprintf('%d/%d, %d.', k, nK, time_passed);
             disp(output_str);
          end
  end
  %}
  
  if matrixOutputOnly
          disp('Output Type: channel calls matrices')
          C = cell(nK,2);
          for k=1:nK
             elapsed = cputime;
             C{k,1} = fileData(k,'Name'); 
             C{k,2} = fileData(k,'Channels','Calls','Matrix');
             time_passed = cputime - elapsed;
             output_str = sprintf('%d/%d, %d.', k, nK, time_passed);
             disp(output_str);
          end      
  else
          disp('Output Type: whole data structure')
          disp('Putting TS in export structures')
          C = cell(nK,1);
          for k = 1:nK
            elapsed = cputime;	
            if isempty(filesObject(k).rawData.data)
                refreshRawData( k, 1 );
            end
            time_passed = cputime - elapsed;
            output_str = sprintf('%d/%d, %d.', k, nK, time_passed);
            disp(output_str);
            C{k} = filesObject(k);
          end      
  end
  
  % Save to disk
  output_file = strcat(audiopath, bat, '.mat');
  output_str = sprintf('Writing output to: %s', output_file);
  disp(output_str);
  save(output_file, 'C','-v7.3');
  
  % end script
  total_time = (cputime - starttime) / 60.0;
  output_str = sprintf('Job has completed in %f minutes.', total_time);
  disp(output_str);
end
