function [FourfoldLocalizer,EncodingRuns_accuracy,EncodingRuns_Average,accuracy] = TimewindowClassification(params,Participant,traindata,testdata,trainlabels,testlabels,c)
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)   

% Script that classifies the SHORES data. It performs:
    % 1) 4-fold cross-validation on the localizer data
    % 2) Computes the testing accuracy of each individual encoding run + average
    % 3) Computes accuracy(=1-loss) based on all encoding run trials using Matlab's loss()
        % function
    % 4) Computes % of correctly classified encoding trials with own
    % ComputeAccuracy() function. 

    % Train linear SVM on the localizer trials
    svm = fitcsvm(traindata,trainlabels);
    
    % 1) 4-fold cross-validation on localizer data
    CVsvm = crossval(svm,'cvpartition',c);
    FourfoldLocalizer = 1-kfoldLoss(CVsvm);
    
    % 2) Test classifier on each encoding run seperately.
    EncodingRuns_accuracy(1) = 1-loss(svm,testdata(1:5,:),testlabels(1:5));
    EncodingRuns_accuracy(2) = 1-loss(svm,testdata(6:10,:),testlabels(6:10));
    EncodingRuns_accuracy(3) = 1-loss(svm,testdata(11:15,:),testlabels(11:15));
    EncodingRuns_accuracy(4) = 1-loss(svm,testdata(16:20,:),testlabels(16:20));
    
    if Participant == 2 % Participant 2 has an extra 5th encoding run.
        EncodingRuns_accuracy(5) = 1-loss(svm,testdata(21:25,:),testlabels(21:25));
    end
    
    % 3) Test classifier on all encoding runs simultaneously using Matlab's
    % loss() function.
    EncodingRuns_Average = 1-loss(svm,testdata,testlabels);
    
    % Compute encoding run accuracy based on % percentage of correctly
    % classified trials (slightly different from Matlab's loss() function)
    TrialLength = length(testlabels); % Calculate how much testing trials the participant has.
    accuracy = ComputeAccuracy(TrialLength,svm,testdata,testlabels); 
end