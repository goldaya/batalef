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

function [  ] = backgroundFolder(audiopath, bat, configfile)
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
  parFile = dir(configfile);
  if isempty(parFile)
    throw(MException('bats:backgroundRun:noParametersFileInFolder','There is no parameters file in working directory'));
  end
  control.params.currentFile = parFile.name;
  output_str = sprintf('The parameter file name is: %s', parFile.name);
  disp(output_str);
  loadParametersFile(parFile.name);
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
  output_str = sprintf('Processing input files took %d seconds.', time_passed);
  disp(output_str);
  elapsed = cputime;
  % Process
  disp('Running pdBasic');
  pdBasic(K,false); % Call Detection
  time_passed = cputime - elapsed;
  output_str = sprintf('pdBasic took %d seconds, starting feature extraction.', time_passed);
  disp(output_str);
  elapsed = cputime;
  fExtraction(K); % Feature Extraction
  time_passed = cputime - elapsed;
  output_str = sprintf('fExtraction took %d seconds, writing out the call matrix.', time_passed);
  disp(output_str);
  % Output - Calls Matrix only
  C = cell(nK,1);
  for i = 1:nK
    %elapsed = cputime;	
    refreshRawData( i, 1 );
    %{
    C{i} = fileData(K(i),'Channels','Calls','Matrix');
    time_passed = cputime - elapsed;
    output_str = sprintf('%d/%d Extracting data %d.', i, nK, time_passed);
    disp(output_str);
    %}
  end
  output_file = strcat(audiopath, bat, '.mat');
  output_str = sprintf('Writing output to: %s', output_file);
  disp(output_str);
  global filesObject;
  save(output_file, 'filesObject','-v7.3');
  total_time = (cputime - starttime) / 60.0;
  output_str = sprintf('Job has completed in %f minutes.', total_time);
  disp(output_str);
end
