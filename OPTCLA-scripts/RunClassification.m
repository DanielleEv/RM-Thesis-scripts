function [P] = RunClassification(P,Participant,params,ScriptsFolder)
% To investigate the possible within-vs- between run influences, is to classify
% runs, instead of mental activities. If there is a strong-enough temporal
% auto-correlation within an fMRI run, then we would expect that a classifier would be
% better able to recognize whether trials are from run A versus run B - regardless of
% mental activity.

% For both two runs, a classifier was trained on the 12 trials of the first task,
% and tested on the 12 trials of the second task within that run. It is then the
% task of the classifier to tell whether a trial come from run A or run B. We can
% then compare this against so-called ‘fake runs’: these also consist of 12 trials
% from a first task for training, and 12 trials from a second task for testing, but
% the two mental activities are not actually from the same run, but randomly selected
% from two different runs. Thus, any effect of run is destroyed in the fake-run condition.

% If the classifier then outputs higher classification accuracies for the real runs
% compared to the fake runs, we could conclude that the classifier wrongly uses extra
% information for classification, based on which runs a mental activity pair is in.


%% Parameters
params.NrPermutations = 10; % Specify the number of permutations for creating the fake runs.
params.NrRepeats = 24;
params.NrTrainingTrials = 12; % For run hold-out classification, use 12 trials per mental activity for training.
params.NrTestingTrials = 12; % For run hold-out classification, use 12 trials per mental activity for testing.
params.NrTasks = 4; % 4 'tasks', e.g. 4 runs.
params.NrPairs = 6; % % Only 6 pairs when classifying 4 runs.

% Stratified 4-fold cross-validation (for replication, should be the same partition for every run-pair).
load([ScriptsFolder,'/cvpartition_runs.mat']);

%% Create run data
% Creating within run-tasks that can be classified with other within-run tasks.
% 1.IS, 2.SN, 3.MI, 4.MS, 5.MC, 6.MR, 7.TI, 8.OP

if Participant == 3 || Participant == 4 || Participant == 7
    display('This participant is not suited for within-between run classification.');
else
    
    display('===== Creating to-be-classified runs...');
    P(1).Runs = zeros(4,24,params.NrVoxels); % 4 runs each with 24 trials
    % For each participant, I store the tasks that were performed within
    % the same run... in the same run variable.
    
    % For P01: IS-MR	SN-MC	MI-TI	MS-OP = 1-6, 2-5, 3-7, 4-8
    if Participant == 1
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:); 
        P(1).Runs(1,13:24,:) = P(1).Tasks(6,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(2,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(5,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(3,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(7,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(4,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(8,:,:);
    end
    
    % For P02: IS-OP	SN-TI	MI-MR	MS-MC = 1-8, 2-7, 3-6, 4-5
    if Participant == 2
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:);
        P(1).Runs(1,13:24,:) = P(1).Tasks(8,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(2,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(7,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(3,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(6,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(4,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(5,:,:);
    end
    
    % For P05: IS-TI	SN-OP	MI-MC	MS-MR = 1-7, 2-8, 3-5, 4-6
    if Participant == 5
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:);
        P(1).Runs(1,13:24,:) = P(1).Tasks(7,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(2,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(8,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(3,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(5,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(4,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(6,:,:);
    end
    
    % For P06: IS-MC	SN-MR	MI-OP	MS-TI = 1-5, 2-6, 3-8, 4-7
    if Participant == 6
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:);
        P(1).Runs(1,13:24,:) = P(1).Tasks(5,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(2,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(6,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(3,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(8,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(4,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(7,:,:);
    end
    
    % For P08: IS-MS	SN-MI	MC-OP	MR-TI = 1-4, 2-3, 5-8, 6-7
    if Participant == 8
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:);
        P(1).Runs(1,13:24,:) = P(1).Tasks(4,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(2,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(3,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(5,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(8,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(6,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(7,:,:);
    end
    
    % For P09: IS-SN	MI-MS	MC-MR	TI-OP = 1-2, 3-4, 5-6, 7-8
    if Participant == 9
        P(1).Runs(1,1:12,:) = P(1).Tasks(1,:,:);
        P(1).Runs(1,13:24,:) = P(1).Tasks(2,:,:);
        
        P(1).Runs(2,1:12,:) = P(1).Tasks(3,:,:);
        P(1).Runs(2,13:24,:) = P(1).Tasks(4,:,:);
        
        P(1).Runs(3,1:12,:) = P(1).Tasks(5,:,:);
        P(1).Runs(3,13:24,:) = P(1).Tasks(6,:,:);
        
        P(1).Runs(4,1:12,:) = P(1).Tasks(7,:,:);
        P(1).Runs(4,13:24,:) = P(1).Tasks(8,:,:);
    end
    
    display('Done.');
    
    
    %% 'Run' classification: 4-fold cross-validation and hold-out (12-12) classification
    % Note: I don't really need the 4-fold cross-validation, but it is a
    % nice check to see whether my code is correct (e.g. it should give
    % high accuracies since I'm cross-validating a mix of 4 different mental activities).
    display('===== Performing 4-fold cross-validation on runs...');
    
    params.crossvalidation = 1; % Choose to perform 4-fold cross-validation.
    params.graphs = 1; % Choose to show graphs.
        
    data = P(1).Runs;
    cd(ScriptsFolder);
    [accuracy_cv,accuracy_holdout] = OPTCLAClassification(Participant,params,data,c_runs)
    
    % Store results in structure.
    P(1).Results.Run_Fourfoldcv = accuracy_cv;
    P(1).Results.Run_Fourfold_mean = mean(accuracy_cv);
    
    P(1).Results.Run_holdout_training_testing = accuracy_holdout;
    P(1).Results.Run_holdout_mean_testing = mean(accuracy_holdout(:,2));
    
    
    %% Fake run creation and classification
    % Creating 'fake' between run-tasks that can be classified with other
    % between run-tasks.
    
    % For P01: IS-MR	SN-MC	MI-TI	MS-OP = 1-6, 2-5, 3-7, 4-8
    % For P02:                                  1-8, 2-7, 3-6, 4-5
    % For P05: IS-TI	SN-OP	MI-MC	MS-MR = 1-7, 2-8, 3-5, 4-6
    % For P06: IS-MC	SN-MR	MI-OP	MS-TI = 1-5, 2-6, 3-8, 4-7
    % For P08: IS-MS	SN-MI	MC-OP	MR-TI = 1-4, 2-3, 5-8, 6-7
    % For P09: IS-SN	MI-MS	MC-MR	TI-OP = 1-2, 3-4, 5-6, 7-8
    
    % 1.IS, 2.SN, 3.MI, 4.MS, 5.MC, 6.MR, 7.TI, 8.OP
    
    sprintf('Also create and classify fake runs?')
    promt = '1 = yes, 2 = no. ';
    Answer = input(promt)
    
    if Answer == 1
        
        params.crossvalidation = 0; % Don't perform 4-fold cross-validation - we don't nee it.
        params.graphs = 0; % I don't want a graph after every permutation.
        
        display('Creating fake runs...');
        A = zeros(8,12,params.NrVoxels); % Use this set up to randomize fake runs for each participant.
        
        A(1,:,:) = P(1).Runs(1,1:12,:); % Put all the real runs (with the correct task order) in a new variable A.
        A(2,:,:)= P(1).Runs(1,13:24,:); % We can use A to shuffle the mental tasks.
        
        A(3,:,:)= P(1).Runs(2,1:12,:);
        A(4,:,:)= P(1).Runs(2,13:24,:);
        
        A(5,:,:)= P(1).Runs(3,1:12,:);
        A(6,:,:)= P(1).Runs(3,13:24,:);
        
        A(7,:,:)=  P(1).Runs(4,1:12,:);
        A(8,:,:)= P(1).Runs(4,13:24,:);
        
        vector = [1,2,3,4,5,6,7,8]; % This vector will be used to randomly permute the task order.
        
        display('Done.');
        
        for permutations = 1:params.NrPermutations
            perm = vector(randperm(length(vector))) % Permute the task order.
            display(['Permutation ',num2str(permutations)]);
            
            P(1).PseudoRuns_rand(1,1:12,:)  = A(perm(1),:,:); % Use this permuted task order to create fake runs.
            P(1).PseudoRuns_rand(1,13:24,:) = A(perm(2),:,:);
            P(1).PseudoRuns_rand(2,1:12,:)  = A(perm(3),:,:);
            P(1).PseudoRuns_rand(2,13:24,:) = A(perm(4),:,:);
            P(1).PseudoRuns_rand(3,1:12,:)  = A(perm(5),:,:);
            P(1).PseudoRuns_rand(3,13:24,:) = A(perm(6),:,:);
            P(1).PseudoRuns_rand(4,1:12,:)  = A(perm(7),:,:);
            P(1).PseudoRuns_rand(4,13:24,:) = A(perm(8),:,:);
            
            % Fake-run classification: 4-fold cross-validation and hold-out (12-12) SVM
            display('===== Performing 4-fold cross-validation on fake runs...');
            data = P(1).PseudoRuns_rand;
            cd(ScriptsFolder);
            
            [accuracy_cv,accuracy_holdout] = OPTCLAClassification(Participant,params,data,c_runs);
            fakerun_accuracy_training(:,permutations) = accuracy_holdout(:,1);
            fakerun_accuracy_testing(:,permutations) = accuracy_holdout(:,2);
        end
        
        % Store results
        P(1).Results.FakeRuns_Holdout_training = fakerun_accuracy_training;
        P(1).Results.FakeRuns_Holdout_testing = fakerun_accuracy_testing;
        
        display('===== Finished fake-run classification.');
        
    end
end
end