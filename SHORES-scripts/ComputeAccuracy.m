%% Compute classification accuracy
% Updated 12-08-18 by Danielle Evenblij (thesis RM Cognitive Neuroscience)

% I made this function because I found out that Matlab's loss() function does
% not compute the % of incorrect classifications (which I turn into correct
% classification with 1-loss) with an odd number of testing trials (e.g.
% participant 2 who has 25 trials). So I made my own function for
% comparison.

function accuracy = ComputeAccuracy(TrialLength,svm,data,labels)

classacc = zeros(TrialLength,1); % Create empty variable.

for i = 1:TrialLength % For each trial, Check whether correclty classified
    classacc(i) = 1-loss(svm,data(i,:),labels(i)); % Outputs 0 or 1.
end

% Calculte the % of correct classifications (ones) of all trials.
accuracy = length(find(classacc))/TrialLength;
end