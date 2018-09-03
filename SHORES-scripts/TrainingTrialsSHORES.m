%% SHORES: Increasing the number of training trials
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

function [P] = TrainingTrialsSHORES(P,params,ScriptsFolder,c)

% FOR-LOOP #1 (for each participant)
for NrParticipant = 1:params.NrParticipants
    Participant = NrParticipant;
    display(['=====SHORES: Performing TrainingTrials analysis on participant ',num2str(Participant),'...']);
    
    % First put the 3 different time windows (original, optimal and
    % sub-optimal in convenient variables):
    TrialsL = length(P(Participant).LabelsLocalizer); % Trial length
    Voxels = size(P(Participant).PreOn(1).Timewindow(11).LocalizerData,2); % Nr of voxels
    TrialsE = length(P(Participant).LabelsEncodingRuns);
    Localizer = zeros(TrialsL,Voxels,3); % Create empty matrices with the correct trial and voxel length per timewindow.
    EncodingRuns = zeros(TrialsE,Voxels,3);
    
    % 1) Original time window features
    Localizer(:,:,1) = [P(Participant).PreOn(1).Timewindow(11).LocalizerData]; % Localizer(trials,voxels,timewindowNr)
    EncodingRuns(:,:,1) = [P(Participant).PreOn(1).Timewindow(11).EncodingRunsData];% Encodingruns(trials,voxels,timewindowNr)
    
    % 2) Optimal time window features
    Localizer(:,:,2) = [P(Participant).PreOn(1).Timewindow(8).LocalizerData];
    EncodingRuns(:,:,2) = [P(Participant).PreOn(1).Timewindow(8).EncodingRunsData];
    
    % 3) Sub-optimal time window features
    Localizer(:,:,3) = [P(Participant).PreOn(2).Timewindow(13).LocalizerData];
    EncodingRuns(:,:,3) = [P(Participant).PreOn(2).Timewindow(13).EncodingRunsData];
    
    % FOR-LOOP #2 (for each of the 3 time windows)
    for TimeW = 1:3 % For all the three different timewindows, increase the training trials for classifcation:
        % FOR-LOOP #3 (for each of the 2 folds)
        for fold = 1:2
            display(['Fold ',num2str(fold),'/2.']);
            display(['Timewindow ',num2str(TimeW),'/3.']);
            NrPermutations = params.NrPermutations; % Nr of permutations can be changed in main script.
            
            % Permuting the localizer trials
            FakeTrials1 = repmat(1:17,1,1)'; % 5 trials of encoding added to the localizer trials per mental activity
            FakeTrials2 = repmat(18:34,1,1)';
            EncodingRunsAveragePermuted = zeros(17,NrPermutations);
            
            if fold == 1
                % Add 2 encoding runs to the training data (gives us 34 training examples total)
                if Participant == 1
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(11:15,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(16:20,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(11:15);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(16:20)];
                end
                
                if Participant == 2 % Adding 10 extra trials for training (because P02 has extra trials, hurray)
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(21:25,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(11:15,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(21:25);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(11:15)];
                end
                
                if Participant == 3
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(16:20,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(11:15,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(16:20);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(11:15)];
                end
            end
            
            if fold == 2 % <----- change switch the encoding runs!
                % Add 2 encoding runs to the training data (gives us 34 training examples total)
                if Participant == 1
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(6:10,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(1:5,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(6:10);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(1:5)];
                end
                
                if Participant == 2 % Adding 10 extra trials for training (because P02 has extra trials, hurray)
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(21:25,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(1:6,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(21:25);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(1:5)];
                end
                
                if Participant == 3
                    dataP = [Localizer(1:12,:,TimeW);EncodingRuns(1:5,:,TimeW);Localizer(13:24,:,TimeW);EncodingRuns(6:10,:,TimeW)];
                    labelsP = [P(Participant).LabelsLocalizer(1:12);P(Participant).LabelsEncodingRuns(1:5);P(Participant).LabelsLocalizer(13:24);P(Participant).LabelsEncodingRuns(6:10)];
                end
            end
            
            % FOR-LOOP #4 (for each permutation)
            for permutation = 1:NrPermutations
                PermutedTrials1 = FakeTrials1(randperm(length(FakeTrials1))); % Permute the localizer trials.
                PermutedTrials2 = FakeTrials2(randperm(length(FakeTrials2))); % Permute the localizer trials.
                PermutedTrials = [PermutedTrials1;PermutedTrials2];
                
                j = 1;
                % FOR-LOOP #5 (for each nr of training trials)
                for trial = 1:(size(dataP,1)/2)% Increase the number of training examples and its labels by 2 in each looP(Participant).
                    data = dataP(PermutedTrials,:);
                    data = [data(1:trial,:);data(18:trial+17,:)];
                    labels = [labelsP(1:trial);labelsP(18:trial+17)];
                    
                    svm = fitcsvm(data,labels);                   % Train svm on localizer data.
                    
                    % Perform within-run 2-fold cross-validation
                    if j ~= 1 % But don't do cross-validation when I have only 1 example of each label.
                        Filename = ['CV_partition_',num2str(j)];
                        load ([ScriptsFolder,'CvPartitions/',Filename]);
                        CVsvm = crossval(svm,'cvpartition',c);        % Perform cross-validation with partition c.
                        %                          c = cvpartition(labels,'KFold',2);
                        %                         CVsvm = crossval(svm,'cvpartition',c);        % Perform cross-validation with partition c.
                        %                          Filename = ['CV_partition_',num2str(i)];    % Uncomment this when you want to create and save cv partitions.
                        %                         save(Filename, 'c');
                        
                    end
                    
                    if fold == 1
                        % Test trained classifier on encoding data
                        if Participant == 1
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,EncodingRuns(1:10,:,TimeW),P(Participant).LabelsEncodingRuns(1:10));
                        end
                        
                        if Participant == 2 % Here I test on 15 instead 10 trials.
                            testdata = [EncodingRuns(1:10,:,TimeW);EncodingRuns(16:20,:,TimeW)];
                            testlabels = [P(Participant).LabelsEncodingRuns(1:10);P(Participant).LabelsEncodingRuns(16:20)];
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,testdata,testlabels);
                            cd(ScriptsFolder);
                            accuracy = ComputeAccuracy(15,svm,testdata,testlabels);
                            EncodingRunsAveragePermuted(j,permutation) = accuracy;
                        end
                        
                        if Participant == 3 % Change this ------>
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,EncodingRuns(1:10,:,TimeW),P(Participant).LabelsEncodingRuns(1:10));
                        end
                    end
                    
                    if fold == 2 
                        % Test trained classifier on encoding data
                        if Participant == 1
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,EncodingRuns(11:20,:,TimeW),P(Participant).LabelsEncodingRuns(11:20));
                        end
                        
                        if Participant == 2 % Here I test on 15 instead 10 trials.
                            testdata = [EncodingRuns(6:20,:,TimeW)];
                            testlabels = [P(Participant).LabelsEncodingRuns(6:20)];
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,testdata,testlabels);
                            cd(ScriptsFolder);
                            accuracy = ComputeAccuracy(15,svm,testdata,testlabels);
                            EncodingRunsAveragePermuted(j,permutation) = accuracy;
                        end
                        
                        if Participant == 3 % Change this ------>
                            EncodingRunsAveragePermuted(j,permutation) = 1-loss(svm,EncodingRuns(11:20,:,TimeW),P(Participant).LabelsEncodingRuns(11:20));
                        end
                    end
                    
                    j = j+1;
                end % End of for-loop # 5 (each training trial nr)
                display(['Permutation ',num2str(permutation)]);
            end % End of for-loop # 4 (each permutation)
            
            % Store results in structure (and add labels for clarity)
            P(Participant).ResultsTrainingTrials(1).Timewindow = 'Original, pre-onset =5s, post-onset = 17s)';
            P(Participant).ResultsTrainingTrials(2).Timewindow = 'Optimal, pre-onset =3s, post-onset = 10s)';
            P(Participant).ResultsTrainingTrials(3).Timewindow = 'Sub-optimal, pre-onset =0s, post-onset = 5s)';
            
            P(Participant).ResultsTrainingTrials(TimeW).Fold(fold).Accuracy_34trials = EncodingRunsAveragePermuted;
            P(Participant).ResultsTrainingTrials(TimeW).Fold(fold).StandardDeviation_34trials = std(EncodingRunsAveragePermuted')';
            P(Participant).ResultsTrainingTrials(TimeW).Fold(fold).Mean_Accuracy_34trials = mean(EncodingRunsAveragePermuted,2);
            
        end % End for-loop #3 (each fold)
    end % End for-loop #2 (each time window)
end % % End for-loop #1 (each participant)

%% Now average the accuracies of the 2 folds and display in graphs

% I want to display the average (of the 1000 permutations and 2 folds) accuracy of 1) each participant, and 2) for
% each time window:

% Original time window
for Participant = 1:params.NrParticipants
    TW_original = mean([P(Participant).ResultsTrainingTrials(1).Fold(1).Mean_Accuracy_34trials,P(Participant).ResultsTrainingTrials(1).Fold(2).Mean_Accuracy_34trials],2);
    figure(1);plot(TW_original,'LineWidth', 2);
    hold on
end

hold off
title('Original timewindow');
xlabel('Number of training trials (per mental activity)')
PrettierGraphs(figure(1),TW_original,0);

for Participant = 1:params.NrParticipants
    TW_optimal = mean([P(Participant).ResultsTrainingTrials(2).Fold(1).Mean_Accuracy_34trials,P(Participant).ResultsTrainingTrials(2).Fold(2).Mean_Accuracy_34trials],2);
    figure(2);plot(TW_optimal,'LineWidth', 2);
    hold on
end

hold off
title('Optimal timewindow');
xlabel('Number of training trials (per mental activity)')
PrettierGraphs(figure(2),TW_optimal,0);

for Participant = 1:params.NrParticipants
    TW_suboptimal = mean([P(Participant).ResultsTrainingTrials(3).Fold(1).Mean_Accuracy_34trials,P(Participant).ResultsTrainingTrials(3).Fold(2).Mean_Accuracy_34trials],2);
    figure(3);plot(TW_suboptimal,'LineWidth', 2);
    hold on
end

hold off
title('Sub-optimal timewindow');
xlabel('Number of training trials (per mental activity)')
PrettierGraphs(figure(3),TW_suboptimal,0);


display('===== Finished TrainingTrials analysis.');
end % End of function