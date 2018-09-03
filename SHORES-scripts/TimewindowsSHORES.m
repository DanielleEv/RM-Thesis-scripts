function [P] = TimewindowsSHORES(P,params,c,ScriptsFolder,DataFolder)
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

% Retrieves whole-brain features of SHORES data for varying timewindows.
% You can choose between 2 configurations:

% FOR-LOOP #1: For each TimeWindowConf
for TimeConf = 1:2 % Perform whole script for 2 different time window analyses (see below).
    
    if TimeConf == 1 % 1#) Pre-onset = 9, Post-onset = 51-28 DATAPOINTS (not seconds)
        display('Using Pre-onset = 9, Post-onset = 51-28 datapoints.');
        PostMin = 24;
        PreOn = 9;
        params.NrTimewindows = (51-PostMin)/3+2; %% 11 timewindows (including the original time window of pre-onst =15, post-onset = 51)
    end
    
    if TimeConf == 2 % 2#) Pre-onset = 0, Post-onset = 51-15
        display('Using Pre-onset = 0, Post-onset = 51-15 datapoints.');
        PostMin = 15;
        PreOn = 0;
        params.NrTimewindows = (51-PostMin)/3+2; % 14 time windows (including the original time window of pre-onst =15, post-onset = 51).
    end
    
    
    %% Extract data from the .mvp files
    
    % FOR-LOOP #2 (for each participant)
    for NrParticipant = 1:params.NrParticipants
        Participant = NrParticipant;
        display(['Participant ',num2str(Participant)]);
        
        display('======SHORES Timewindow: Retrieving the (individualized NOI) features...');
        
        % First get the localizer and encoding run labels
        cd([DataFolder,'/ScriptsRMThesis/SHORES/Brainvoyager files/SHORES/P0',num2str(Participant),'/P0',num2str(Participant),'_SHORES_I_MVPA']);
        
        if Participant == 1
            mvp1 = xff('Learn_P01-SHORES-I-02-CCCRvs.NNN_NNN-CCCR_12-12.mvp');
            mvp2 = xff('Test_P01-SHORES-I-02-CCCRvs.NNN_NNN-CCCR_10-10.mvp');
        end
        
        if Participant == 2
            mvp1 = xff('Learn_P02-SHORES-I-01-CCCRvs.NNN_NNN-CCCR_12-12.mvp');
            mvp2 = xff('Test_P02-SHORES-I-01-CCCRvs.NNN_NNN-CCCR_20-5.mvp');
        end
        
        if Participant == 3
            mvp1 = xff('Learn_P03-SHORES-I-01-CCCLvs.NNN_CCCL-NNN_12-12.mvp');
            mvp2 = xff('Test_P03-SHORES-I-01-CCCLvs.NNN_CCCL-NNN_10-10.mvp');
        end
        
        % Store labels for localizer and encoding runs in structure.
        P(Participant).LabelsLocalizer = mvp1.ClassValues;      % 24x1
        P(Participant).LabelsEncodingRuns = mvp2.ClassValues;    % 20-5x1
        
        
        % Retrieving individualized NOI features from the .mvp files
        if Participant == 1 % All the filenames differ per participant... sigh.
            nameLearn = ['Learn_P01-SHORES-I-02-CCCRvs.NNN_CCCR-NNN_12-12.mvp'];
            nameTest = ['Test_P01-SHORES-I-02-CCCRvs.NNN_CCCR-NNN_10-10.mvp'];
        else if Participant == 2
                nameLearn = ['Learn_P02-SHORES-I-01-CCCRvs.NNN_CCCR-NNN_12-12.mvp'];
                nameTest = ['Test_P02-SHORES-I-01-CCCRvs.NNN_CCCR-NNN_5-20.mvp'];
            else if Participant == 3
                    nameLearn = ['Learn_P03-SHORES-I-01-CCCLvs.NNN_CCCL-NNN_12-12.mvp'];
                    nameTest = ['Test_P03-SHORES-I-01-CCCLvs.NNN_CCCL-NNN_10-10.mvp'];
                end
            end
        end
        
        % Open the correct folder depending on which participant and on which TimewindowConf.
        j = 1;
        for post = 51:-3:PostMin % I use the post-onset datapoints to open the correct IndNOI folder
            
            if TimeConf == 1 % Store features in the PreOn3s structure
                IndNOIFolder =[DataFolder,'/ScriptsRMThesis/SHORES/Brainvoyager files/TIme window trial estimation/P0',num2str(Participant),'/P0',num2str(Participant),'_Pre9Post',num2str(post)];
            end
            if TimeConf == 2 % Store features in the PreOn0s structure
                IndNOIFolder =[DataFolder,'/ScriptsRMThesis/SHORES/Brainvoyager files/Timewindow Postonset0/P0',num2str(Participant),'/P0',num2str(Participant),'_Pre0Post',num2str(post)];
            end
            
            cd(IndNOIFolder);
            mvp = xff(nameLearn); % Open localizer .mvp file
            P(Participant).PreOn(TimeConf).Timewindow(j).LocalizerData = mvp.FeatureValues; % Extract features from localizer
            mvp = xff(nameTest); % Open encoding runs .mvp file
            P(Participant).PreOn(TimeConf).Timewindow(j).EncodingRunsData = mvp.FeatureValues; % Extract features from encoding runs
            P(Participant).PreOn(TimeConf).Timewindow(j).PostonsetTR = post;
            
            j = j + 1; % Go to the next timewindow(j).
        end
        
        % Also open pre = 15 post = 51 (which was used for the original
        % analysis).
        cd([DataFolder,'/ScriptsRMThesis/SHORES/Brainvoyager files/TIme window trial estimation/P0',num2str(Participant),'/P0',num2str(Participant),'_Pre15Post51']);
        mvp = xff(nameLearn); % Localizer
        P(Participant).PreOn(TimeConf).Timewindow(j).LocalizerData = mvp.FeatureValues;
        mvp = xff(nameTest); % Encoding runs
        P(Participant).PreOn(TimeConf).Timewindow(j).EncodingRunsData = mvp.FeatureValues;
        P(Participant).PreOn(TimeConf).Timewindow(j).PostonsetTR = 'Pre = 15, post = 51';
        
        display('===== Done.');
        
        
        %% Classification (with individualized NOI features)
        params.NrTimewindows = length(P(Participant).PreOn(TimeConf).Timewindow);
        
        % Classifying Individualized ROIs
        display('===== SHORES: Performing classification...')
        
        for MapNr = 1:params.NrTimewindows % For all the 11 or 13 timewindows:
            traindata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).LocalizerData;
            testdata = P(Participant).PreOn(TimeConf).Timewindow(MapNr).EncodingRunsData;
            trainlabels = P(Participant).LabelsLocalizer;
            testlabels = P(Participant).LabelsEncodingRuns;
            
            cd(ScriptsFolder); % Train a linear SVM on localizer and test on the encoding runs.
            [FourfoldLocalizer,EncodingRuns_accuracy,EncodingRuns_Average,accuracy] = TimewindowClassification(params,Participant,traindata,testdata,trainlabels,testlabels,c);
            
            P(Participant).PreOn(TimeConf).Timewindow(MapNr).ResultsFourfold_localizerI = FourfoldLocalizer; % 4-fold cross-validation accuracies of localizer
            P(Participant).PreOn(TimeConf).Timewindow(MapNr).ResultsOther.EncodingRunsI = EncodingRuns_accuracy; % Testing accuracy of all encoding runs
            P(Participant).PreOn(TimeConf).Timewindow(MapNr).ResultsEncodingRunsI_Average = EncodingRuns_Average;
            P(Participant).PreOn(TimeConf).Timewindow(MapNr).ResultsAccuracyI = accuracy;
        end
        
        % Add some labels to the structures (for clarity)
        P(Participant).PreOn(1).Onset = ['PreOnset = 3s']; % Where the result of pre-onset =3s (TimeConf =1) is stored.
        P(Participant).PreOn(2).Onset = ['PreOnset = 0s'];% Where the result of pre-onset =3s (TimeConf =2) is stored.
        
        display('===== Done. ');
        
    end
    
    %% Make graphs
    
    % Main results of original analysis (Original time window: Pre-onset =
    % 15 data points, post-onset = 51 datapoints.
    figure(1)
    AllParticipants = [P(1).PreOn(1).Timewindow(11).ResultsAccuracyI;P(2).PreOn(1).Timewindow(11).ResultsAccuracyI;P(3).PreOn(1).Timewindow(11).ResultsAccuracyI];
    plot(AllParticipants,'b-o');
    title('Main results: Classification accuracies of original analysis');
    ylim([0.3 1]);
    xticks([1 2 3]);
    xlabel('Participant');
    ylabel('Classification accuracy');
    
    % Time window analysis graph
    % I reversed the post-onset order, so that the graph is better interpretable
    % (and I attached the original accuracies at the end). -> as shown in
    % thesis.
    
    P01 = [flip([P(1).PreOn(TimeConf).Timewindow(1:params.NrTimewindows-1).ResultsAccuracyI]');AllParticipants(1)];
    P02 = [flip([P(2).PreOn(TimeConf).Timewindow(1:params.NrTimewindows-1).ResultsAccuracyI]');AllParticipants(2)];
    P03 = [flip([P(3).PreOn(TimeConf).Timewindow(1:params.NrTimewindows-1).ResultsAccuracyI]');AllParticipants(3)];
    
    figure(TimeConf+1)
    plot(P01)
    hold on
    plot(P02)
    plot(P03)
    hold off
    legend('P01','P02','P03');
    title(['Classification accuracies using different time windows (with pre-onset = ',num2str(PreOn),')']);
    ylim([0.3 1]);
    xlabel('Timewindow');
    ylabel('Classification accuracy');
    
    % Note: the x-axes labels aren't correct (it should show the post-onsets in seconds),
    % but for my thesis I'm creating my end graph in excel - so it doesn't matter.
    
end

display('===== Finished analysis.');

%% Sanity check
%
% for i = 1:params.NrTimewindows
%     P(Participant).Timewindow(i).TrialNames'
%     display('Press any key to continue');
%     pause;
% end
end