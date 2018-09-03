%% Feature selection using the same # of voxels
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

% This function sorts the features according to their hightest t-values for
% each mental activity. NOIs were then created from 100 features up to the
% maximum number of features for each participant rounded off (2400, 5000
% and 8400 for participant 1,2 and 3 respectively) in steps of 100.
% Then linear SVM was trained on the localizer run, and tested on the encoding runs.

% This is done for ALL the available time windows I computed previously.

function [P,VoxelAnalysis] = NOIsizeSHORES(P,params,ScriptsFolder,c)

for TimeConf = 1:2 % Perform whole script for 2 different time window analyses (see below).
    
    % Define parameters depending on TimeConfiguration 1 or 2:
    if TimeConf == 1 % Pre-onset = 9, Post-onset = 51 to 28 DATAPOINTS (not seconds)
        PostMin = 24;
        PreOn = 9;
        params.NrTimewindows = (51-PostMin)/3+2;
    end
    
    if TimeConf == 2 % Pre-onset = 0, Post-onset = 51 to 15 datapoints
        PostMin = 15;
        PreOn = 0;
        params.NrTimewindows = (51-PostMin)/3+2;
        
    end
    
    
    %% NOI size analysis
    
    for NrParticipant = 1:params.NrParticipants % For each participant
        Participant = NrParticipant;
        display(['Participant ',num2str(Participant)]);
        
        NOISize = 1; % Staring from 100 voxels and increase in steps of 100 to the max. number of voxels of each participant:
        for NrVoxels = 100:100:length(P(Participant).PreOn(TimeConf).Timewindow(1).LocalizerData)
            NrSelectedVoxels = NrVoxels;
            
            for MapNr = 1:params.NrTimewindows % For each timewindow.
                
                meanClass1 = mean(P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerData(1:12,:));
                meanClass2 = mean(P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerData(13:24,:)); % Take per voxel the average t-value of all trials of mental activity 2.
                [sortedValues,sortIndex] = sort(meanClass1(:),'descend'); % Sort voxels and their index from highest to lowest values.
                maxIndex1 = sortIndex(1:(NrSelectedVoxels/2));
                [sortedValues,sortIndex] = sort(meanClass2(:),'descend'); % Sort voxels and their index from highest to lowest values.
                maxIndex2 = sortIndex(1:(NrSelectedVoxels/2));
                
                MergedIndex = [maxIndex1;maxIndex2]; % Add the sorted index of mental activity 1 and 2 together.
                C = unique(MergedIndex); %Removes repititions from the index.
                
                % Save the new data (with the changed NOI-size, e.g nr of
                % features) in a structure.
                P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerChangedNOIsize = P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerData(:,C);
                P(Participant).PreOn(TimeConf).Timewindow(MapNr).EncodingRunsChangedNOIsize = P(Participant).PreOn(TimeConf).Timewindow(MapNr).EncodingRunsData(:,C);
            end
            
            % Classification
            display(['===== SHORES Classification: TimeConf ',num2str(TimeConf),', ',num2str(size(P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerChangedNOIsize,2)),' features, participant ',num2str(Participant),'.']);
            cd(ScriptsFolder);
            
            for MapNr = 1:params.NrTimewindows % 11 or 13 maps
                traindata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerChangedNOIsize;
                testdata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).EncodingRunsChangedNOIsize;
                trainlabels = P(Participant).LabelsLocalizer;
                testlabels = P(Participant).LabelsEncodingRuns;
                
                % Perform 4-fold cross-validation on the localizer data (FourfoldLocalizer)
                % and train on localizer and test on encoding runs(accuracy).
                [FourfoldLocalizer,EncodingRuns,EncodingRuns_Average,accuracy] = TimewindowClassification(params,NrParticipant,traindata,testdata,trainlabels,testlabels,c);
                
                VoxelAnalysis(NOISize,1,MapNr,NrParticipant,TimeConf) = accuracy; % Compare my own accuracy computation with...
                VoxelAnalysis(NOISize,2,MapNr,NrParticipant,TimeConf) = EncodingRuns_Average; % ...Matlab's loss() function.
                % Also keep track of how many features were actually used for
                % classification (since both mental activites had overlapping
                % features).
                NumberofAcualUsedFeatures(NOISize,MapNr,NrParticipant) = size(P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerChangedNOIsize,2);
                
            end
            
            NOISize = NOISize+1; % Go to the next NOI-size (e.g. nr of features).
        end
        
        % Also do classifications with the maximum nr of voxels for each
        % participant.
        for MapNr = 1:params.NrTimewindows % 10 or 13 maps
            traindata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerData;
            testdata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).EncodingRunsData;
            trainlabels = P(Participant).LabelsLocalizer;
            testlabels = P(Participant).LabelsEncodingRuns;
            
            % Perform 4-fold cross-validation on the localizer data (FourfoldLocalizer)
            % and train on localizer and test on encoding runs(accuracy).
            [FourfoldLocalizer,EncodingRuns,EncodingRuns_Average,accuracy] = TimewindowClassification(params,Participant,traindata, testdata,trainlabels,testlabels,c);
            
            VoxelAnalysis(NOISize,1,MapNr,NrParticipant,TimeConf) = accuracy; % Compare my own accuracy computation with...
            VoxelAnalysis(NOISize,2,MapNr,NrParticipant,TimeConf) = EncodingRuns_Average; % ...Matlab's loss() function.
            
        end
        
        P(Participant).PreOn(TimeConf).VoxelAnalysis = VoxelAnalysis; % This is all NOI-size data for all 3 participants in one variable
        P(Participant).PreOn(TimeConf).NumberofUsedFeatures = NumberofAcualUsedFeatures;
        P(Participant).PreOn(TimeConf).NumberofUsedFeatures_average = squeeze(mean(NumberofAcualUsedFeatures,2));
        display('===== Finished NOI-size analysis.');
    end
end
%     %% Graphs of the actual number of features that were used
%     for Participant = 1:params.NrParticipant
%         P(Participant).PreOn(1).Timewindow(11).
%
%     end
%     optimalTW = NumberofUsedFeatures(:,8,:);
%     originalTW = NumberofUsedFeatures(:,14,:);
%     suboptimalTW = NumberofUsedFeatures(:,13,:);
%
%     NrFeatures_allTWs = [originalTW,optimalTW,suboptimalTW];
%     mean_NrFeatures_allTWs = mean(NrFeatures_allTWs,2);
%
%     % Plot the actual number of features used for each participant (averaged
%     % over the 3 timewindows)
%     for i  = 1:3
%         plot(mean_NrFeatures_allTWs(:,:,i));
%         hold on
%     end
%     hold off
%     P.NrofUsedFeatures_ThreeTimewindows = NrFeatures_allTWs;
%     P.NrofUsedFeatures_ThreeTimewindows_mean = squeeze(mean_NrFeatures_allTWs);
%
%% For getting only relevant timewindows for thesis
original_voxelanalysis = squeeze(VoxelAnalysis(:,1,11,:,1)); % Pre-onset = 5s, Post-onset = 17s
optimal_voxelanalysis = squeeze(VoxelAnalysis(:,1,8,:,1)); % Post-onset = 10, pre-onset = 3
suboptimal_voxelanalysis = squeeze(VoxelAnalysis(:,1,13,:,2)); % Post-onset = 8, pre-onset =0

% Store the relevant timewindows in structure P.
P(1).Original_VoxelAnalysis = original_voxelanalysis; %(NOIsize,timewindow,Participant,TimeConf)
P(1).Optimal_voxelAnalysis = optimal_voxelanalysis;
P(1).Suboptimal_voxelAnalysis = suboptimal_voxelanalysis;

% Plot NOI-size accuracies for all the three timewindows
% Note that the x-axes are incorrect. They display the INDEX not the
% actual number of features.

% Original time window
for Participant = 1:params.NrParticipants
    figure(1);plot(original_voxelanalysis(:,Participant),'LineWidth', 2);
    hold on
end

hold off
title('Original timewindow');
xlabel('NOI-size / Number of features')
PrettierGraphs(figure(1),original_voxelanalysis,0);

for Participant = 1:params.NrParticipants
    figure(2);plot(optimal_voxelanalysis(:,Participant),'LineWidth', 2);
    hold on
end

hold off
title('Optimal timewindow');
xlabel('NOI-size / Number of features')
PrettierGraphs(figure(2),optimal_voxelanalysis,0);

for Participant = 1:params.NrParticipants
    figure(3);plot(suboptimal_voxelanalysis(:,Participant),'LineWidth', 2);
    hold on
end

hold off
title('Sub-optimal timewindow');
xlabel('NOI-size / Number of features')
PrettierGraphs(figure(3),suboptimal_voxelanalysis,0);



end
