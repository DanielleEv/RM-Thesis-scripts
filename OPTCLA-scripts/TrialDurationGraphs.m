%% Trial duration OPTCLA graph
load('TrialDuration5');
load('TrialDuration10');
load('TrialDuration15');
%save('TrialDuration10','TrialDuration10')
%meandurations = [mean(TrialDuration5);mean(TrialDuration10);mean(TrialDuration15)]';
%standard_dev = [std(TrialDuration5);std(TrialDuration10);std(TrialDuration15)]
%%
close all

% Create means and standard deviations
val1 = mean(TrialDuration5)
val2 = mean(TrialDuration10)
val3 = mean(TrialDuration15)
val1std = std(TrialDuration5)
val2std = std(TrialDuration10)
val3std = std(TrialDuration15)

figure(1)
delta = .03; % Adjust manually to jitter the axis (makes the error bars better visible)

% Main line
p1 = plot((1:numel(val1))-delta,val1,'h','linewidth',5,'MarkerSize',14') %FF66CC
hold on
p2 = plot((1:numel(val2))+delta,val2,'h','linewidth',5,'MarkerSize',14') %FF3399
p3 = plot((1:numel(val3))+4*delta,val3,'h','linewidth',5,'MarkerSize',14')%660033

%p1.Color = [0 0.60 0.60] % #00cc99
%p2.Color = [0 0.4 0.8]
%p3.Color = [0.0 0.6 1] % #0099ff

% Error bars
errorbar((1:numel(val1))-delta,val1,val1std,'ok','linewidth',1)
errorbar((1:numel(val2))+delta,val2,val2std,'ok','linewidth',1)
errorbar((1:numel(val3))+4*delta,val3,val3std,'ok','linewidth',1')

legend('5s','10s','15s')
xticks([1 2 3 4 5 6 7 8 9 10])
xlabel('Participant')
%title(['Trial durations accuracies of all OPTCLA participants']);
PrettierGraphs(figure(1),0,0)
ax = gca
ax.FontSize = 14
ax.XTickLabel = {'P01','P02','P03','P04','P05','P06','P07','P08','P09','Average'}


%% Training trials SHORES
% original_sd = zeros(17,3)
% subopt_sd = zeros(17,3)
% opt_sd = zeros(17,3)
% save('original_sd','original_sd')

load('original')
load('opt')
load('subopt')
load('original_sd')
load('opt_sd')
load('subopt_sd')


%%
alldata = zeros(17,3,3);
alldata(:,:,1) = original;
alldata(:,:,2) = opt;
alldata(:,:,3) = subopt;
sd = zeros(17,3,3)
sd(:,:,1) = original_sd;
sd(:,:,2) = opt_sd;
sd(:,:,3) = subopt_sd;

delta = .06; % Adjust manually to jitter the axis (makes the error bars better visible)

close all

for timewindow = 1:3
    % ORIGINAL TIMEWINDOW
    % Create means and standard deviations for P01, P02 and P03
    val1 = alldata(:,1,timewindow);
    val2 = alldata(:,2,timewindow);
    val3 = alldata(:,3,timewindow);
    val1std = sd(:,1,timewindow);
    val2std = sd(:,2,timewindow);
    val3std = sd(:,3,timewindow);
    
    figure(timewindow)
    
    % Main line
    p1 = plot((1:numel(val1))-delta,val1,'-o','linewidth',5,'MarkerSize',10') %FF66CC
    hold on
    p2 = plot((1:numel(val2))+delta,val2,'-o','linewidth',5,'MarkerSize',10') %FF3399
    p3 = plot((1:numel(val3))+4*delta,val3,'-o','linewidth',5,'MarkerSize',10')%660033
    
   p1.Color = [0.25 0.60 1] % #3399ff
    p2.Color = [0.4 1 0.2] %#33cc33
    p3.Color = [1 0.8 0] % #cc9900
    
    % Error bars
    errorbar((1:numel(val1))-delta,val1,val1std,'ok','linewidth',1)
    errorbar((1:numel(val2))+delta,val2,val2std,'ok','linewidth',1)
    errorbar((1:numel(val3))+4*delta,val3,val3std,'ok','linewidth',1')
    
    legend('P01','P02','P03')
    xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17])
    xlim([1 18])
    xlabel('Number of trials used for training')
    ylim([0.3 1])
    %title(['Trial durations accuracies of all OPTCLA participants']);
    PrettierGraphs(figure(timewindow),0,0)
    ax = gca
    ax.FontSize = 14
    %ax.XTickLabel = {'P01','P02','P03','P04','P05','P06','P07','P08','P09','Average'}
    hold off
    
    if timewindow == 1
        title('Original time window (pre-onset = 5s, post-onset = 17s)  ');
    end
    if timewindow == 2
        title('Optimal time window (pre-onset = 3s, post-onset = 10s)  ');
    end
    
    if timewindow == 3
        title('Sub-optimal time window (pre-onset = 0s, post-onset = 5s)  ');
    end
end

%% Statistical test run classification
%realruns = zeros(6,6)
fakeruns2 = zeros(6,6)
%save('realruns','realruns')
%save('fakeruns2','fakeruns2')
load('fakeruns')
load('fakeruns2')
load('realruns')

boxplot(fakeruns2(:))
boxplot(realruns(:))

% Wilcoxon rank sum test (non-parametric paired t-test)
[p,h,stats] = ranksum(realruns(:),fakeruns(:))
