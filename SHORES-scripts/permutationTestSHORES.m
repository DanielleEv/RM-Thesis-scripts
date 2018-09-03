%% Permutation test SHORES

function [perm_accuracy,p] = permutationTestSHORES(params,traindata,testdata,trainlabels,testlabels,observedResults,triallength)
% Note: c is the 'cv partition' variable that divides the data in training
% and testing data in n-folds.

perm_accuracy = zeros(params.NrPairs,params.NrPermutations); % Create empty matrix, with 28 task pairs and each the NrPermutations.


for ind = 1:params.NrPermutations % Permute x times.
            perm_label = trainlabels(randperm(length(trainlabels))); % Permute the labels.
            
            % Classify with permutated labels
            svmset = traindata; % Create a task-pair
            svm = fitcsvm(svmset,perm_label);
            accuracy = ComputeAccuracy(triallength,svm,testdata,testlabels); % Compute classification accuracies.
            perm_accuracy(ind) = accuracy;
            Permutation = ind
end
 

% Count how many permutation outcomes are equal or bigger than the actual
% observed classification accuracy. For 100 permutations, with p = 0.05,
% only 5 instances or less can be equal or larger than the observed value.

temp = zeros(params.NrPairs,params.NrPermutations);
for i = 1:params.NrPairs % 1 pair
    temp(i,:) = perm_accuracy(i,:) >= observedResults;
end
p = sum(temp,2)/params.NrPermutations;
d = p(:,1)<=0.05;

if params.NrPermutations >= 1000
    e = p(:,1)<=0.01; % These results are only valid if you permute a 1000 times or more.
    f = p(:,1)<=0.001;
    p = [p d e f];
else
    p = [p d];
end

beep on; beep % Make a sound when done.


end