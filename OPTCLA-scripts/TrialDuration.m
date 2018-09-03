%% Classification: 4-fold cross-validation based on trial duration

function P = TrialDuration(Participant,params,P,cTrial,ScriptsFolder,DataFolder)


%% Finding the trial durations
% Always use the protocol file for P01, because the trial duration order is
% exactly the same for all participants.
cd([DataFolder,'/ScriptsRMThesis/OPTCLA/Brainvoyager files/P01']);

    Runs(1).prt = xff('LISCOMcontr_IS-MR_12-12.prt');
    Runs(2).prt = xff('LISCOMcontr_SN-MC_12-12.prt');
    Runs(3).prt = xff('LISCOMcontr_MI-TI_12-12.prt');
    Runs(4).prt = xff('LISCOMcontr_MS-OP_12-12.prt');

protocol = zeros(params.NrRepeats,2,params.NrTasks);
for run = 1:params.NrRuns
    for task = 1:params.NrTasks
        if Runs(run).prt.Cond(task+1).NrOfOnOffsets ~= 0
            protocol(:,:,task) = Runs(run).prt.Cond(task+1).OnOffsets;
        end
    end
end

TrialDurationOrder = protocol(:,2,:) - (protocol(:,1,:)-1);
P(1).TrialOrder = TrialDurationOrder;

%% Sort trials based on trial duration
P(1).TrialTime = zeros(params.NrTasks,4,params.NrVoxels,3);

j = 1;
for task = 1:params.NrTasks % For 5s
    for trial = 1:params.NrRepeats
        if P(1).TrialOrder(trial,:,task) == 5
            P(1).TrialTime(task,j,:,1) = P(1).Tasks(task,trial,:);
            j = j+1;
        end
    end
    j =1;
end

j = 1;
for task = 1:params.NrTasks % For 10s
    for trial = 1:params.NrRepeats
        if P(1).TrialOrder(trial,:,task) == 10
            P(1).TrialTime(task,j,:,2) = P(1).Tasks(task,trial,:);
            j = j+1;
        end
    end
    j =1;
end

j = 1;
for task = 1:params.NrTasks % For 15s
    for trial = 1:params.NrRepeats
        if P(1).TrialOrder(trial,:,task) == 15
            P(1).TrialTime(task,j,:,3) = P(1).Tasks(task,trial,:);
            j = j+1;
        end
    end
    j =1;
end

%% 4-fold cross-validation
display('===== 4-fold crossvalidation training based on trial duration...');
params.NrRepeats = 4;
params.crossvalidation = 1; % Perform 4-fold cross-validation
params.holdout = 0; % Do not perform holdout classification.
params.graph = 0;
cd(ScriptsFolder)

for TrialTimeNr = 1:3
    
    data = P(1).TrialTime(:,:,:,TrialTimeNr);
    [accuracy_cv,] = OPTCLAClassification(Participant,params,data,cTrial);
    
    % Store results and plot results
    if TrialTimeNr == 1
        P(1).Results.Fourfoldcv_5s = accuracy_cv;
        P(1).Results.Fourfoldcv_5s_mean = mean(accuracy_cv);
        display('Results stored in 5s field.')
    end
    
    if TrialTimeNr == 2
        P(1).Results.Fourfoldcv_10s = accuracy_cv;
        P(1).Results.Fourfoldcv_10s_mean = mean(accuracy_cv);
        display('Results stored in 10s field.')
    end
    
    if TrialTimeNr == 3
        P(1).Results.Fourfoldcv_15s = accuracy_cv;
        P(1).Results.Fourfoldcv_15s_mean = mean(accuracy_cv);
        display('Results stored in 15s field.')
    end
end

% Plot data for a single participant
data = [P(1).Results.Fourfoldcv_5s P(1).Results.Fourfoldcv_10s P(1).Results.Fourfoldcv_15s];
figure(1)
plot(P(1).Results.Fourfoldcv_5s)
hold on
plot(P(1).Results.Fourfoldcv_10s)
plot(P(1).Results.Fourfoldcv_15s)
legend('5s','10s','15s')
title(['Trial durations accuracies - participant ',num2str(Participant)]);
PrettierGraphs(figure(1),data,0)
hold off


display('===== Finished with 5, 10 and 15s trial 4-fold cross-validation.');

end