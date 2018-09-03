%% Main script OPTCLA
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

% This scripts analyzes only one participant at a time. OPTCLA is a 3T fMRI
% dataset with 8 participants, who perform 8 different mental activities
% (tasks) over various numbers of runs. Trial duration is 5, 10 or 15s,
% with a resting period of 10s. A linear SVM is trained and tested using a
% a cross-validation scheme and a hold-out scheme. 

% After that, various extra analyses are performed on the data.

clear all

%% Configurations and parameters

% Change the DataFolder to where you stored the 'ScriptsRMThesis' file!
DataFolder = ['/Users/danielle/Documents/MATLAB/fMRI_dataanalysis/OPTCLA classification/'];

SaveResultsFolder = [DataFolder,'/ScriptsRMThesis/OPTCLA/Results/']; % Don't change this.
ScriptsFolder = [DataFolder,'/ScriptsRMThesis/OPTCLA/Scripts/']; % Don't change this.

% Script configurations
Participant = 4;                     % Select participant data: 1,2,3,4,5,6,7,8, or 9.'

conf.ExtractVMPs = 1;                % Select if you want to create data based on VMP files.
%conf.ExtractVTCs = 0;                % Select if you want to create data based on VTC files
conf.ClassifyRuns = 1;               % Select if you want to perform run classification.
conf.UseDifferentTrialDurations = 1; % Select if you want to compare classification accuracies using different trial durations.
conf.PermutationTesting = 1;         % Select if you want to perform permutation tests.
conf.UseExistingPartition = 1;
conf.FourfoldAndLeaveoutClassification = 1;
conf.P04Analysis = 1;

params.NrTasks = 8;         % nr of mental tasks
params.NrRepeats = 12;      % nr of times a task is repeated (e.g. trials)
params.NrPairs = 28;        % 8 mental tasks in pairs of 2 yields 28 unique combinatios.
params.NrRuns = 4;          % Standard is 4 runs, although participant 3,4 and 7 differ.
params.NrTrainingTrials = 8; % For standard holdout-classifiction, use 8 trials per mental activity for training.
params.NrTestingTrials = 4; % For standard holdout-classifiction, use 4 trials per mental activity for testing.
params.Xsize = 58;
params.Ysize = 40;
params.Zsize = 46;
params.NrVoxels = params.Xsize*params.Ysize*params.Zsize;
params.crossvalidation = 1; % Choose to perform 4-fold cross-validation.
params.holdout = 1;         % Choose to perform hold-out classification.
params.graphs = 1;          % Choose to show standard graphs.
      
% Load stratified 4-fold cross-validation partition with 24 observations.(should be the same partition for every task-pair).
if conf.UseExistingPartition == 1;
    cd(ScriptsFolder);
    load('cv_partition.mat'); % Is the variable 'c' that is given to almost every function.
else
    display('Warning: No partition has been defined. Either load an existing one, or create one by');
    display('using c = cvpartition(''[# of observations]'',''kfold'', [# of folds])');
end

%% Extract task data from vmp files or select data file.
P(1).ParticipantNo = Participant;   % Store participant number in structure P.
P(1).Configurations = conf;         % Store configurations in P.
P(1).InitialParameters = params;    % Store (initial) parameters in P.

% Extract mental activity data from vmp-files and sort them according to
% randomization order.
if conf.ExtractVMPs == 1
    cd(ScriptsFolder)
    [P] = SortingOPTCLA(P,params,Participant,DataFolder); % Outputs a structure with the names of the
    
% If you already have the extracted data sorted somewhere, you can just load it.    
else if conf.ExtractVMPs == 0
        load(uigetfile()) % Select e.g. P01_data.mat file. Data usable for classification can be found in structure P.Tasks.
    end
end

%% Classifcation OPTCLA (4-fold cross-validation and hold-out (8-4) classification
% Note that the hold-out (8-4) classification is only to check for mistakes (e.g. whether I can
% replicate the same hold-out (8-4) classification results from when using Brain Voyager).

if conf.FourfoldAndLeaveoutClassification == 1;
   display('===== Performing 4-fold cross-validation and hold-out (12-12) classification...');
    
   clear figures
    
% These parameters should be selected (if they weren't already):
params.NrTasks = 8;         % nr of mental tasks
params.NrRepeats = 12;      % nr of times a task is repeated
params.NrPairs = 28;        % 8 mental tasks in pairs of 2 yields 28 unique combinatios.
params.NrRuns = 4;
params.NrTrainingTrials = 8; % For standard holdout-classifiction, use 8 trials per mental activity for training.
params.NrTestingTrials = 4; % For standard holdout-classifiction, use 4 trials per mental activity for testing.
params.crossvalidation = 1; % Choose to perform 4-fold cross-validation.
params.graphs = 1;          % Choose to show graphs.
data = P(1).Tasks;          % Contains the features used for classifcation.

cd(ScriptsFolder);
[accuracy_cv,accuracy_holdout] = OPTCLAClassification(Participant,params,data,c);
    
% Store results in structure P.
P(1).Results.Fourfoldcv = accuracy_cv;
P(1).Results.Fourfoldcv_mean = mean(accuracy_cv);
P(1).Results.Holdout8_4_training_testing = accuracy_holdout;
P(1).Results.Holdout8_4_testing_mean = mean(accuracy_holdout(:,2));

end

%% Permutation testing
% Outputs the classifcation accuracies after shuffling the task labels of
% each task pair, and computes the p-values based on the actual,observed
% accuracies.

params.NrPermutations = 1; % Change the number of permutations here. 1000x used for thesis.

if conf.PermutationTesting == 1
    display(['===== Performing permutation tests with ',num2str(params.NrPermutations),' permutations...']);
    clear figures
    cd(ScriptsFolder);
    data = P(1).Tasks;
    labels = [repmat(1,params.NrRepeats,1);repmat(2,params.NrRepeats,1)];  % Create labels.
    
    [perm_accuracy,p] = permutationTest(P,params,data,labels,c);
    
    % % Store results in structure P.
    P(1).Results.Fourfold_permutations = perm_accuracy;
    P(1).Results.Fourfold_pvalues= p;
end

% Save results
cd(SaveResultsFolder);
Filename = ['Data_OPTCLA_',num2str(params.NrPermutations),'permutations_P0', num2str(Participant),datestr(now, '_dd-mm-yy'),'.mat'];
save(Filename,'P');
display(['===== Results saved in ',SaveResultsFolder,'.']);

%% Run classification
% To further investigate the possible within-vs- between run influences, a classifier
% can be trained to classify runs. For each run, a classifier is trained on the 12 trials of
% the 1st task, and tested on the 12 trials of the 2nd task within that run using hold-out classification.

if conf.ClassifyRuns == 1
    clear figures
    cd(ScriptsFolder)
    P = RunClassification(P,Participant,params,ScriptsFolder);
end

%% Trial-duration classification
% Compares classification accuracies using different trial durations (5,10 or 15s) for
% each task.

if conf.UseDifferentTrialDurations == 1
    clear figures
    cd(ScriptsFolder);
    load('cvpartition_trial.mat'); % Loads stratified 4-fold cross-validation partition with 8 observations.
    P = TrialDuration(Participant,params,P,cTrial,ScriptsFolder,DataFolder);
    
end

%% P04 analysis
% Only participant 4 has the trials of each task divided over 2 runs (6 trials in one, 6 trials in the other).
% We can thus compare training and testing a within a run with training and
% testing between 2 separate runs for this participant.

params.NrPermutations = 10; % Default is 10 (used for thesis).

if conf.P04Analysis == 1
    close all
    cd(ScriptsFolder);
    [P] = P04_analysis(Participant,params,P,ScriptsFolder);
end

%% Null distributions 
% Looks at the taskpair classifcation accuracies of permutations tests (1000 permutations)
% across participants and compares the taskpairs that were performed within the same run,
% (WithinPermutations) and taskpairs performed in separate runs (BetweenPermutations).

clear figures

cd(ScriptsFolder)
[BetweenPermutations,WithinPermutations] = NullDistributions(SaveResultsFolder,ScriptsFolder);

% Store results in structure.
P(1).BetweenPermutations_AllParticipants = BetweenPermutations;
P(1).WithinPermutations_AllParticipants = WithinPermutations;

%% Save results
sprintf('Save all results?')
promt = '1 = yes, 2 = no. ';
Answer = input(promt)

if Answer == 1
    cd(SaveResultsFolder); % Change Filename accordingly
    Filename = ['Data_OPTCLA_P04_analysis', num2str(Participant),datestr(now, '_dd-mm-yy'),'.mat'];
    save(Filename,'P');
    display(['Results saved in ',SaveResultsFolder,'.']);
    
else
    display('Results not saved.');
end
