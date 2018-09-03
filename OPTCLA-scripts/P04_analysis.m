%% P04 analysis
function P = P04_analysis(Participant,params,P,ScriptsFolder)

%% Classification: 2-fold cross-validation
display('===== 2-fold crossvalidation and 6-6 holdout classification on participant 4.');
params.NrTasks = 8;         % nr of mental tasks
params.NrRepeats = 12;      % nr of times a task is repeated
params.NrPairs = 28;        % 28 mental activity pairs.
params.NrTrainingTrials = 6; % 6 trials per mental activity for training (run A)
params.NrTestingTrials = 6; % 6 trials per mental activity for testing (run B)
params.crossvalidation = 1; % Choose to perform cross-validation (2-fold).
params.holdout = 0;         % Choose to perform hold-out classifcation (6-6)
params.graphs = 1;          % Choose to show graphs.
data = P(1).Tasks;

cd(ScriptsFolder);
accuracy_cv_perm = zeros(28,10);
labels = [repmat(1,params.NrRepeats,1);repmat(2,params.NrRepeats,1)];  % Create binary labels (needed for creating the 2-fold partition).
    
% Do 2-fold cross-validation 10x (with a different 2-fold partition every
% permutation).
for permutations = 1:params.NrPermutations
     c_2fold = cvpartition(labels,'KFold',2);    % Stratified 2-fold cross-validation.
     [accuracy_cv] = OPTCLAClassification(Participant,params,data,c_2fold);
     accuracy_cv_perm(:,permutations) = accuracy_cv;
     display(['Permutation ',num2str(permutations)]);
end

% Now do only hold-out 6-6 classification
params.crossvalidation = 0;
params.holdout = 1; % I only need to do the hold-out classification once, so this saves computation time.
[accuracy_cv,accuracy_holdout] = OPTCLAClassification(Participant,params,data,c_2fold);

% Store results in structure
P(1).Results.Twofoldcv_perm10 = accuracy_cv_perm;
P(1).Results.Twofoldcv_perm10_mean = mean(accuracy_cv_perm,2);
P(1).Results.Holdout6_6_training_testing = accuracy_holdout;
P(1).Results.Holdout6_6_testing_mean = mean(accuracy_holdout(:,2));

% Put the hold-out 6-6 accuracies and the mean 10x2-fold cv accuracies in a
% 28x2 variable.
P4 = [P(1).Results.Holdout6_6_training_testing(:,2) mean(P(1).Results.Twofoldcv_perm10,2)];

% Create boxplot
close all % close any previous figures
label1{1} = 'Between runs: 6-6 hold-out classification';
label1{2} = 'Within runs: 10x2-fold cross-validation';
figure(1);
boxplot(P4,label1)
PrettierGraphs(figure(1),P4,1) % Add standard layout to figure.
%title('Training and testing between runs vs. within runs (participant 4)');

figure(2) % Create a line-graph
plot(P4(:,1))
hold on
plot(P4(:,2))
hold off
legend('Between-run (hold-out 6-6)','Within-run (10x2-fold cv')
title('Training and testing between runs vs. within runs (Participant 4)  ')
xlim([1 28])
PrettierGraphs(figure(2),P4,0)

% Wilcoxon rank sum test (non-parametric paired t-test)
[p,h] = ranksum(P4(:,1),P4(:,2));
P(1).WilcoxonRankSumtest_BetweenvsWithin = [p,h];

display('===== Done.');

end