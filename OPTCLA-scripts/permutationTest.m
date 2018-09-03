%% Permutation testing

function [perm_accuracy,p] = permutationTest(P,params,data,labels,c)
% Note: c is the 'cv partition' variable that divides the data in training
% and testing data in n-folds.

tic; % Start timer
perm_accuracy = zeros(params.NrPairs,params.NrPermutations); % Create empty matrix, with 28 task pairs and each the NrPermutations.

j = 1;
for t1 = 1 : params.NrTasks-1 % Using t1 and t2 to get all 28 possible task-pair combination.
    for t2 = t1+1 : params.NrTasks
        
        for ind = 1:params.NrPermutations % Permute x times.
            perm_label = labels(randperm(length(labels))); % Permute the labels.
            
            % Classify with permutated labels
            svmset = squeeze([data(t1,:,:) data(t2,:,:)]); % Create a task-pair
            svm = fitcsvm(svmset,perm_label);
            CVsvm = crossval(svm,'cvpartition',c); % Perform stratifid 4-fold cross-validation with same partition c.
            perm_accuracy(j,ind) = 1-kfoldLoss(CVsvm); % Compute classification accuracies.
            display(['Taskpair: ',num2str(j),' Permutation: ',num2str(ind),'/',num2str(params.NrPermutations)]);
            
        end
        j = j+1;
 
    end
end

% Count how many permutation outcomes are equal or bigger than the actual
% observed classification accuracy. For 100 permutations, with p = 0.05,
% only 5 instances or less can be equal or larger than the observed value.

temp = zeros(params.NrPairs,params.NrPermutations);
for i = 1:params.NrPairs % 28 pairs
    temp(i,:) = perm_accuracy(i,:) >= P(1).Results.Fourfoldcv(i);
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
time_perm = toc/60; % Permutation test for 28x100x4 classifications = around 45 minutes.
display(['=====Finished permutation testing. Time of computation (in minutes): ',num2str(time_perm)]);

end