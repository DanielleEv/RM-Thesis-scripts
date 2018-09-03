%% Main script SHORES analysis
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

% Performs several analysis on the SHORES data, a 3T fMRI dataset
% containing 3 participants. LOCALIZER (24 trials total): participants perform
% two different mental activities (mental drawing and mental talking) with
% a trial duration of 2s, resting period 20s. ENCODING RUNS (4-5 runs of 5 trials each):
% In each run the participants answers a yes/no question using the two different
% mental activities. A linear SVM is trained on the LOCALIZER and tested on
% the ENCODING RUNS.

%% Paramaters SHORES
clear all

% Change the DataFolder to where you stored the 'ScriptsRMThesis' file!
DataFolder = '/Users/danielle/Documents/MATLAB/fMRI_dataanalysis/OPTCLA classification'; % Only change the DataFolder path to where you stored 'FILENAME HERE'.

SaveResultsFolder = [DataFolder,'/ScriptsRMThesis/SHORES/Results/'];
ScriptsFolder = [DataFolder,'/ScriptsRMThesis/SHORES/Scripts/'];
    
params.NrTasks = 2;         % Nr of mental activities
params.NrPairs = 1;         % There is only 1 mental activity pair (mental drawing and mental talking)
params.NrRepeats = 12;      % Nr of times a task is repeated
params.NrRuns = 2;          % E.g. 1) localizer and 2) encoding
params.Xsize = 58;
params.Ysize = 40;
params.Zsize = 46;
params.NrVoxels = params.Xsize*params.Ysize*params.Zsize; % Nr of voxels (whole-brain)
params.TR_sec = 3; % TR in seconds
params.NrParticipants = 3; % 3 participants in total

% Script configurations
conf.UseExistingPartition = 1;

% Load stratified 4-fold cross-validation partition.(should be the same paratition for every task-pair).
if conf.UseExistingPartition == 1;
cd(ScriptsFolder)
load('cv_partition.mat'); % Is the variable 'c' that is given to almost every function.

else
    display('Warning: No partition has been defined. Either load an existing one, or create one by');
    display('using c = cvpartition(''[# of observations]'',''kfold'', [# of folds])');
end

%% Original analysis and MVPA #1: time window analyis
% Original analysis: Replicates the original analyis (pre-onset=5s, post-onset=17s)
% that was done in real-time with Turbo-Brainvoyager during the actual fMRI session.

% MVPA #1, Time window analysis: Investigates whether there is an optimal time window
% that can be used for feature extraction. A linear SVM is trained on data based on using
% various time windows and tested on separate encoding runs.

% Time window analysis is done for 2 different TimewindowConfigurations:
% #1 = Pre-onset = 9, Post-onset ranging from 51-28 datapoints (e.g. pre-onset = 3s, post-onset = 17-8s),
% #2 = Pre-onset = 0, Post-onset ranging from 51-15 datapoints (e.g. pre-onset = 0s, post-onset = 17-5s),

clear figures
P(1).ParticipantNo = 1;   % Store participant number in structure P.
P(2).ParticipantNo = 2;
P(3).ParticipantNo = 3;

% Create and classify SHORES timewindow data
cd(ScriptsFolder)
[P] = TimewindowsSHORES(P,params,c,ScriptsFolder,DataFolder)

% Note about Structure P:
% P.PreOn is where the features and results of pre-onset =3s (TimeConf =1) is stored and
% the features andresults pre-onset =0s (TimeConf =2) is stored.


%% MVPA #2: NOI-size (e.g. number of features) analysis
% Investigates whether decreasing NOI (Network-of-Interest) size (e.g. the
% number of features) affects classifaction accuracies. The analysis is
% performed using all available possible time windows (so TimeConf 1 and 2).

clear figures
cd(ScriptsFolder)
[P,VoxelAnalysis] = NOIsizeSHORES(P,params,ScriptsFolder,c);

display('Note about Structure P:');
display('P.PreOn.VoxelAnalysis VoxelAnalysis is where all NOI-size data for');
display('all 3 participants stored in one variable.');


%% MVPA #3: Increasing the number of training trials
% Investigates how many training trials are needed to for the
% classification accuracies to saturate in SHORES. The script trains on
% training sets with size ranging from 1 to 17 trials per mental activity
% and tests them on seperate encoding runs.

% Nr of permutations: the script randomly selects trials from a training set for training.
% You decide here how often you want to do this. For thesis, 1000 permutations was used.
params.NrPermutations = 10;

clear figures
cd(ScriptsFolder)
[P] = TrainingTrialsSHORES(P,params,ScriptsFolder,c);

%% Permutation testing

params.NrPermutations = 10; % Change the number of permutations here.

display(['===== Performing permutation tests with ',num2str(params.NrPermutations),' permutations...']);
clear figures

for Participant = 1:3
    display(['Participant ',num2str(Participant)]);
    traindata = P(Participant).PreOn(1).Timewindow(11).LocalizerData;
    testdata = P(Participant).PreOn(1).Timewindow(11).EncodingRunsData;
    trainlabels = P(Participant).LabelsLocalizer;
    testlabels = P(Participant).LabelsEncodingRuns;
    observedResults = P(Participant).PreOn(1).Timewindow(11).ResultsAccuracyI;
    triallength = length(P(Participant).LabelsEncodingRuns);
    
    cd(ScriptsFolder);
    [perm_accuracy,p] = permutationTestSHORES(params,traindata,testdata,trainlabels,testlabels,observedResults,triallength);
    
    % Store results
    P(Participant).PermutationTesting = perm_accuracy;
    P(Participant).PermutationTestin_pvalues = p;
    
end

% Save results
cd(SaveResultsFolder);
Filename = ['Data_SHORES_',num2str(params.NrPermutations),'permutations',datestr(now, '_dd-mm-yy'),'.mat'];
save(Filename,'P');
display(['===== Results saved in ',SaveResultsFolder,'.']);

%% Save results
sprintf('Save all results?')
promt = '1 = yes, 2 = no. ';
Answer = input(promt)

if Answer == 1
    cd(SaveResultsFolder);
    Filename = ['Data_SHORES_allparticipants',datestr(now, '_dd-mm-yy'),'.mat'];
    save(Filename,'P');
    display(['Results saved in ',SaveResultsFolder,'.']);
    
else
    display('Results not saved.');
end

