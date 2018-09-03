%% OPTCLA classification
% Performs cross-validation and holdout-classifcation. 

function [accuracy_cv,accuracy_holdout] = OPTCLAClassification(Participant,params,data,c)

% Cross-validation
%--------------------------------------------------------------------------
accuracy_cv = zeros(params.NrPairs,1);
if params.crossvalidation == 1; 
    
    display('===== Performing cross-validation...');
    
    labels = [repmat(1,params.NrRepeats,1);repmat(2,params.NrRepeats,1)];  % Create binary labels.
    
    j = 1;
    
    % The number of folds can be varied with variable 'c', the cvpartition.
    for t1 = 1 : params.NrTasks-1 % Using t1 and t2 to get all 28 possible task-pair combinations.
        for t2 = t1+1 : params.NrTasks
            svmset = squeeze([data(t1,:,:) data(t2,:,:)]); % Create a task-pair (28x106720)
            svm = fitcsvm(svmset,labels);
            CVsvm = crossval(svm,'cvpartition',c);        % Perform cross-validation with partition c.
            accuracy_cv(j) = 1-kfoldLoss(CVsvm);             % Compute classification accuracy.
            j=j+1;
        end
    end
    
    display('===== Done.');
end

% Hold-out classification
%--------------------------------------------------------------------------
if params.holdout == 1;
    display('===== Performing hold-out classification...');
    
    labels_train = [repmat(1,params.NrTrainingTrials,1);repmat(2,params.NrTrainingTrials,1)]; % Create labels
    labels_test = [repmat(1,params.NrTestingTrials,1);repmat(2,params.NrTestingTrials,1)];
    
    j = 1;
    for t1 = 1 : params.NrTasks-1 % Using t1 and t2 to get all 6 possible task-pair combination.
        for t2 = t1+1 : params.NrTasks
            
            % The hold-out partition can be varied depending on the number
            % of training trials and testing trials (can be specified).
            traindata = squeeze([data(t1,1:params.NrTrainingTrials,:) data(t2,1:params.NrTrainingTrials,:)]);  % Create a task-pair with first 8 trials of both tasks.
            testdata = squeeze([data(t1,params.NrTrainingTrials+1:params.NrRepeats,:) data(t2,params.NrTrainingTrials+1:params.NrRepeats,:)]); % Create a task-pair with last 4 trials of both tasks.
            
            svm = fitcsvm(traindata,labels_train); % Train SVM on training data.
            accuracy_holdout(j,1) = 1-loss(svm,traindata,labels_train); % Accuracies for training data.
            accuracy_holdout(j,2) = 1-loss(svm,testdata,labels_test); % Accuracies for testing data.
            j=j+1;
        end
    end
    
    display('===== Done.');
    
    if params.graphs == 1;
        
        % Create histrogram with classification accuracies
        subplot(1,3,1);
        if params.crossvalidation == 1
            hist(accuracy_cv)
            title('Cross-validation');
            xlim([0 1.00])
            xticks([0 0.5 1]);
            ylim([0 params.NrPairs])
            xlabel('Classification accuracy');
            ylabel('Frequency'); % E.g. how many task pairs had that classification accuracy.
        end
        
        subplot(1,3,2);hist(accuracy_holdout(:,1))
        title('Hold-out training')
        xlim([0 1.00])
        xticks([0 0.5 1]);
        ylim([0 params.NrPairs]);
        xlabel('Classification accuracy');
        ylabel('Frequency'); % E.g. how many task pairs had that classification accuracy.
        
        subplot(1,3,3); hist(accuracy_holdout(:,2))
        title('Hold-out testing')
        xlim([0 1.00])
        xticks([0 0.5 1]);
        ylim([0 params.NrPairs]);
        xlabel('Classification accuracy');
        ylabel('Frequency'); % E.g. how many task pairs had that classification accuracy.
        
    end
end

% Display summary results
display(['===== Finished classifications on participant ',num2str(Participant),'.']);
if params.crossvalidation == 1
    display(['Mean cross-validation accuracy: ',num2str(mean(accuracy_cv))]);
end
if params.holdout == 1;
    display(['Mean hold-out training accuracy: ',num2str(mean(accuracy_holdout(:,1)))]);
    display(['Mean hold-out testing accuracy: ',num2str(mean(accuracy_holdout(:,2)))]);
end
display('Results stored in structure: P.Results.');
end