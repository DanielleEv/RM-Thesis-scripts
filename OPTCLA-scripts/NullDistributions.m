%% Null distributions OPTCLA
% Looks at the taskpair classifcation accuracies of permutations tests (1000 permutations)
% across participants and compares the taskpairs that were performed within the same run,
% (WithinPermutations) and taskpairs performed in separate runs (BetweenPermutations).

% Note: Since I've already done the permutation tests, this script just
% loads the variables where I've already sorted the within-permutation accuracies
% and the between-permutations accuracies

function [BetweenPermutations,WithinPermutations] = NullDistributions(SaveResultsFolder,ScriptsFolder)

%% Code that loads all permutations results from 8 participants
% display('====Retrieving all permutation data...')
% 
% WithinPermutations = zeros(30,1000); 
% BetweenPermutations = zeros(30,1000);
% AllPermutations = zeros((28*8),1000); % We're occluding participtant 4 (due to it's different/unusable run structure).
% cd([SaveResultsFolder,'PermutationResults']);
% 
% % First, load all permutation results from the mental activity pairs that
% % were performed within the same run.
% % Also load permutation results from an equal number number of mental
% % ativity pairs that were performed accross runs.
% 
% % P01
% load('Results_P01.mat');
% AllPermutations(1:28,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(1,:) = P(1).Results.Fourfold_permutations_1000(5,:);
% WithinPermutations(2,:) = P(1).Results.Fourfold_permutations_1000(10,:);
% WithinPermutations(3,:) = P(1).Results.Fourfold_permutations_1000(17,:);
% WithinPermutations(4,:) = P(1).Results.Fourfold_permutations_1000(22,:);
% 
% BetweenPermutations(1,:) = P(1).Results.Fourfold_permutations_1000(6,:);
% BetweenPermutations(2,:) = P(1).Results.Fourfold_permutations_1000(11,:);
% BetweenPermutations(3,:) = P(1).Results.Fourfold_permutations_1000(18,:);
% BetweenPermutations(4,:) = P(1).Results.Fourfold_permutations_1000(23,:);
% 
% 
% % P02
% load('Results_P02.mat');
% AllPermutations(29:56,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(5,:) = P(1).Results.Fourfold_permutations_1000(7,:);
% WithinPermutations(6,:) = P(1).Results.Fourfold_permutations_1000(12,:);
% WithinPermutations(7,:) = P(1).Results.Fourfold_permutations_1000(16,:);
% WithinPermutations(8,:) = P(1).Results.Fourfold_permutations_1000(19,:);
% 
% BetweenPermutations(5,:) = P(1).Results.Fourfold_permutations_1000(6,:);
% BetweenPermutations(6,:) = P(1).Results.Fourfold_permutations_1000(13,:);
% BetweenPermutations(7,:) = P(1).Results.Fourfold_permutations_1000(17,:);
% BetweenPermutations(8,:) = P(1).Results.Fourfold_permutations_1000(20,:);
% 
% % P03
% load('Results_P03.mat');
% AllPermutations(57:84,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(9,:) = P(1).Results.Fourfold_permutations_1000(1,:);
% WithinPermutations(10,:) = P(1).Results.Fourfold_permutations_1000(14,:);
% WithinPermutations(11,:) = P(1).Results.Fourfold_permutations_1000(23,:);
% 
% BetweenPermutations(9,:) = P(1).Results.Fourfold_permutations_1000(2,:);
% BetweenPermutations(10,:) = P(1).Results.Fourfold_permutations_1000(16,:);
% BetweenPermutations(11,:) = P(1).Results.Fourfold_permutations_1000(19,:);
% 
% % P05
% load('Results_P05.mat');
% AllPermutations(85:112,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(12,:) = P(1).Results.Fourfold_permutations_1000(6,:);
% WithinPermutations(13,:) = P(1).Results.Fourfold_permutations_1000(13,:);
% WithinPermutations(14,:) = P(1).Results.Fourfold_permutations_1000(15,:);
% WithinPermutations(15,:) = P(1).Results.Fourfold_permutations_1000(10,:);
% 
% BetweenPermutations(12,:) = P(1).Results.Fourfold_permutations_1000(4,:);
% BetweenPermutations(13,:) = P(1).Results.Fourfold_permutations_1000(9,:);
% BetweenPermutations(14,:) = P(1).Results.Fourfold_permutations_1000(16,:);
% BetweenPermutations(15,:) = P(1).Results.Fourfold_permutations_1000(11,:);
% 
% % P06
% load('Results_P06.mat');
% AllPermutations(113:140,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(16,:) = P(1).Results.Fourfold_permutations_1000(4,:);
% WithinPermutations(17,:) = P(1).Results.Fourfold_permutations_1000(11,:);
% WithinPermutations(18,:) = P(1).Results.Fourfold_permutations_1000(18,:);
% WithinPermutations(19,:) = P(1).Results.Fourfold_permutations_1000(21,:);
% 
% BetweenPermutations(16,:) = P(1).Results.Fourfold_permutations_1000(3,:);
% BetweenPermutations(17,:) = P(1).Results.Fourfold_permutations_1000(8,:);
% BetweenPermutations(18,:) = P(1).Results.Fourfold_permutations_1000(17,:);
% BetweenPermutations(19,:) = P(1).Results.Fourfold_permutations_1000(28,:);
% 
% % P08
% load('Results_P08.mat');
% AllPermutations(141:168,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(20,:) = P(1).Results.Fourfold_permutations_1000(3,:);
% WithinPermutations(21,:) = P(1).Results.Fourfold_permutations_1000(8,:);
% WithinPermutations(22,:) = P(1).Results.Fourfold_permutations_1000(25,:);
% WithinPermutations(23,:) = P(1).Results.Fourfold_permutations_1000(26,:);
% 
% BetweenPermutations(20,:) = P(1).Results.Fourfold_permutations_1000(2,:);
% BetweenPermutations(21,:) = P(1).Results.Fourfold_permutations_1000(6,:);
% BetweenPermutations(22,:) = P(1).Results.Fourfold_permutations_1000(23,:);
% BetweenPermutations(23,:) = P(1).Results.Fourfold_permutations_1000(27,:);
% 
% % P09
% load('Results_P09.mat');
% 
% AllPermutations(169:196,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(24,:) = P(1).Results.Fourfold_permutations_1000(1,:);
% WithinPermutations(25,:) = P(1).Results.Fourfold_permutations_1000(14,:);
% WithinPermutations(26,:) = P(1).Results.Fourfold_permutations_1000(23,:);
% WithinPermutations(27,:) = P(1).Results.Fourfold_permutations_1000(28,:);
% 
% BetweenPermutations(24,:) = P(1).Results.Fourfold_permutations_1000(2,:);
% BetweenPermutations(25,:) = P(1).Results.Fourfold_permutations_1000(12,:);
% BetweenPermutations(26,:) = P(1).Results.Fourfold_permutations_1000(21,:);
% BetweenPermutations(27,:) = P(1).Results.Fourfold_permutations_1000(27,:);
% 
% % P07
% load('Results_P07.mat');
% 
% AllPermutations(197:224,:) = P(1).Results.Fourfold_permutations_1000;
% 
% WithinPermutations(28,:) = P(1).Results.Fourfold_permutations_1000(1,:);
% WithinPermutations(29,:) = P(1).Results.Fourfold_permutations_1000(14,:);
% WithinPermutations(30,:) = P(1).Results.Fourfold_permutations_1000(23,:);
% 
% BetweenPermutations(28,:) = P(1).Results.Fourfold_permutations_1000(3,:);
% BetweenPermutations(29,:) = P(1).Results.Fourfold_permutations_1000(22,:);
% BetweenPermutations(30,:) = P(1).Results.Fourfold_permutations_1000(18,:);
% 
% save('BetweenPermutations','BetweenPermutations')
% save('WithinPermutations','WithinPermutations')

%% 

cd(ScriptsFolder); %
load('WithinPermutations.mat')
load('BetweenPermutations.mat')

% Plot within-permutation results
display('====Plotting graphs...')
figure(1);
boxplot(WithinPermutations','Whisker',1)
data = WithinPermutations';
PrettierGraphs(figure(1),data,1) % Add standard layout to figure.
title('Within-run null-distribution');
ylim([0 1.0])
xlabel('Within-run pairs')

% Now compare this with permutation testing done taskpairs from separate runs ('between runs')
figure(2)
boxplot(BetweenPermutations');
title('Between-run null-distribution');
PrettierGraphs(figure(2),BetweenPermutations',1) % Add standard layout to figure.
ylim([0 1.0])
xlabel('Between-run pairs')

% Plot within- and between permutation results (as one big boxplot)
figure(3);
label2{1} = 'Within-run null distribution';
label2{2} = 'Between-run null distribution';
data = [WithinPermutations(:),BetweenPermutations(:)];
boxplot(data,label2,'Whisker',3)
PrettierGraphs(figure(3),data,0) % Add standard layout to figure.
title('Null-distribution of within-run and between-run mental activity pairs');
ylim([0 1.0])

% Overlay the mean as green diamonds
hold on
plot([mean(WithinPermutations(:)),mean(BetweenPermutations(:))], 'dg');
hold off

display('====Done.')

%% Load observed between and within run accuracies
load('WithinAccuracy')
load('BetweenAccuracy')
data = [WithinAccuracy(:),BetweenAccuracy(:)];
label2{1} = 'Observed within-run pairs';
label2{2} = 'Observed between-run pairs';
figure(4)
boxplot(data,label2,'Whisker',3)
PrettierGraphs(figure(4),data,1)
ylim([0 1.0])
end