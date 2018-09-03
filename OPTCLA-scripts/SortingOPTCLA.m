%% SortingOPTCLA
% Extracts the features from the .vmp files according to mental
% activity/task and trial. Due to the randomizations of the mental activities/tasks
% accross participants, I need to sort everything into the same order.

% Mental activities/tasks:
% 1. ‘IS'		Mental Talking (“Inner Speech”)
% 2. ’SN'		Spatial Navigation
% 3. ‘MI'		Motor Imagery
% 4. ’MS’		Mental Singing
% 5. ’MC'		Mental Calculation
% 6. ’MR'		Mental Rotation
% 7. ’TI'		Tennis Imagery
% 8. ’OP'		Own Paradigm

function [P] = SortingOPTCLA(P,params,Participant,DataFolder)

% Go the correct folder containing the vmp.files depending on the
% participant number.
cd([DataFolder,'/ScriptsRMThesis/OPTCLA/Brainvoyager files/P0',num2str(Participant)]);

% P01
if Participant ==1
    Runs(1).NameVmp_t25 = 'P01_LISCOMcontr_I_01_IS-MR_12-12_3DMCTS_THPGLMF8c_TAL_IS-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P01_LISCOMcontr_I_02_SN-MC_12-12_3DMCTS_THPGLMF8c_TAL_SN-MC_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P01_LISCOMcontr_I_03_MI-TI_12-12_3DMCTS_THPGLMF8c_TAL_MI-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P01_LISCOMcontr_I_04_MS-OP_12-12_3DMCTS_THPGLMF8c_TAL_MS-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    end

% P02
if Participant == 2
    Runs(1).NameVmp_t25 = 'P02_LISCOMcontr_I_01_IS-OP_12-12_3DMCTS_THPGLMF8c_TAL_IS-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P02_LISCOMcontr_I_02_SN-TI_12-12_3DMCTS_THPGLMF8c_TAL_SN-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P02_LISCOMcontr_I_03_MI-MR_12-12_3DMCTS_THPGLMF8c_TAL_MI-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P02_LISCOMcontr_I_04_MS-MC_12-12_3DMCTS_THPGLMF8c_TAL_MS-MC_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

%P03
if Participant == 3
    params.NrRuns = 5; % This participant has 5 runs (not the default 4).
    Runs(1).NameVmp_t25 = 'P03_LISCOMcontr_II_01_IS-SN_12-12_3DMCTS_THPGLMF8c_TAL_IS-SN_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P03_LISCOMcontr_II_02_MI-MS_12-12_3DMCTS_THPGLMF8c_TAL_MI-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P03_LISCOMcontr_II_03_MC-MR_12-12_3DMCTS_THPGLMF8c_TAL_MC-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P03_LISCOMcontr_II_05_TI-OP_6-6_3DMCTS_THPGLMF4c_TAL_TI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(5).NameVmp_t25 = 'P03_LISCOMcontr_II_06_TI-OP_6-6_3DMCTS_THPGLMF4c_TAL_TI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

if Participant == 4
    params.NrRuns = 8;
    Runs(1).NameVmp_t25 = 'P04_LISCOMcontr_I_01_IS-MI_6-6_3DMCTS_THPGLMF4c_TAL_IS-MI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P04_LISCOMcontr_I_02_SN-MS_6-6_3DMCTS_THPGLMF4c_TAL_SN-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P04_LISCOMcontr_I_03_MC-TI_6-6_3DMCTS_THPGLMF4c_TAL_MC-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P04_LISCOMcontr_I_04_MR-OP_6-6_3DMCTS_THPGLMF4c_TAL_MR-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(5).NameVmp_t25 = 'P04_LISCOMcontr_II_03_IS-MI_6-6_3DMCTS_THPGLMF4c_TAL_IS-MI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(6).NameVmp_t25 = 'P04_LISCOMcontr_II_02_SN-MS_6-6_3DMCTS_THPGLMF4c_TAL_SN-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(7).NameVmp_t25 = 'P04_LISCOMcontr_II_01_MC-TI_6-6_3DMCTS_THPGLMF4c_TAL_MC-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(8).NameVmp_t25 = 'P04_LISCOMcontr_I_05_MR-OP_6-6_3DMCTS_THPGLMF4c_TAL_MR-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

%P05
if Participant == 5
    Runs(1).NameVmp_t25 = 'P05_LISCOMcontr_I_01_IS-TI_12-12_3DMCTS_THPGLMF8c_TAL_IS-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P05_LISCOMcontr_I_02_SN-OP_12-12_3DMCTS_THPGLMF8c_TAL_SN-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P05_LISCOMcontr_I_03_MI-MC_12-12_3DMCTS_THPGLMF8c_TAL_MI-MC_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P05_LISCOMcontr_I_04_MS-MR_12-12_3DMCTS_THPGLMF8c_TAL_MS-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    end

%P06
if Participant == 6
    Runs(1).NameVmp_t25 = 'P06_LISCOMcontr_I_01_IS-MC_12-12_3DMCTS_THPGLMF8c_TAL_IS-MC_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P06_LISCOMcontr_I_02_SN-MR_12-12_3DMCTS_THPGLMF8c_TAL_SN-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P06_LISCOMcontr_I_03_MI-OP_12-12_3DMCTS_THPGLMF8c_TAL_MI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P06_LISCOMcontr_I_04_MS-TI_12-12_3DMCTS_THPGLMF8c_TAL_MS-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

%P07
if Participant == 7
    params.NrRuns = 5; % This participant has 5 runs (not the default 4).
    Runs(1).NameVmp_t25 = 'P07_LISCOMcontr_II_01_IS-SN_12-12_3DMCTS_THPGLMF9c_TAL_IS-SN_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P07_LISCOMcontr_II_02_MI-MS_12-12_3DMCTS_THPGLMF9c_TAL_MI-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P07_LISCOMcontr_II_03_MC-MR_12-12_3DMCTS_THPGLMF9c_TAL_MC-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P07_LISCOMcontr_II_04_TI-OP_6-6_3DMCTS_THPGLMF4c_TAL_TI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(5).NameVmp_t25 = 'P07_LISCOMcontr_II_05_TI-OP_6-6_3DMCTS_THPGLMF4c_TAL_TI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

%P08
if Participant == 8
    Runs(1).NameVmp_t25 = 'P08_LISCOMcontr_I_01_IS-MS_12-12_3DMCTS_THPGLMF8c_TAL_IS-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P08_LISCOMcontr_I_02_SN-MI_12-12_3DMCTS_THPGLMF8c_TAL_SN-MI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P08_LISCOMcontr_I_03_MC-OP_12-12_3DMCTS_THPGLMF8c_TAL_MC-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P08_LISCOMcontr_I_04_MR-TI_12-12_3DMCTS_THPGLMF8c_TAL_MR-TI_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
end

%P09
if Participant == 9
    Runs(1).NameVmp_t25 = 'P09_LISCOMcontr_I_01_IS-SN_12-12_3DMCTS_THPGLMF8c_TAL_IS-SN_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(2).NameVmp_t25 = 'P09_LISCOMcontr_I_02_MI-MS_12-12_3DMCTS_THPGLMF8c_TAL_MI-MS_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(3).NameVmp_t25 = 'P09_LISCOMcontr_I_03_MC-MR_12-12_3DMCTS_THPGLMF8c_TAL_MC-MR_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    Runs(4).NameVmp_t25 = 'P09_LISCOMcontr_I_04_TI-OP_12-12_3DMCTS_THPGLMF8c_TAL_TI-OP_GLM-2G_PreOn-2-PostOn-22_LT_z-t_Trials.vmp';
    
else if Participant < 1 | Participant > 9
        display('===== Error: You did not choose a valid participant number.')
    end
   
%% Extracting task data from vmp files
display('===== Extracting task data from vmp files...');

for i = 1:params.NrRuns
    Runs(i).vmp = xff(Runs(i).NameVmp_t25); % Gives a map with 24 trials (12 for each task)
end

if Participant == 3 | Participant == 7 % For P03 and P07 task extraction needs to be done differently since they have 5 runs instead of 4.
    Task1 = zeros(3,12,params.NrVoxels);
    Task2 = Task1;
    Task3 = zeros(2,12,params.NrVoxels);
    
    for i = 1:3 % For all the 3 normal runs, put half of the tasks in Task1 and the other half in Task2.
        for ind = 1:params.NrRepeats % For 12 trials
            Task1(i,ind,:) = Runs(i).vmp.Map(ind).VMPData(:); %  Retrieve task a
            Task2(i,ind,:) = Runs(i).vmp.Map(ind+12).VMPData(:); % Retrieve task b
        end
    end
    
    % Now organize the 2 'abnormal' runs (who both have only 6 trials) and
    % put them in Task3 (then 12 trials total)
    for ind = 1:6 
        Task3(1,ind,:) = Runs(4).vmp.Map(ind).VMPData(:);
        Task3(1,ind+6,:) = Runs(5).vmp.Map(ind).VMPData(:);
        Task3(2,ind,:) = Runs(4).vmp.Map(ind+6).VMPData(:);
        Task3(2,ind+6,:) = Runs(5).vmp.Map(ind+6).VMPData(:);
    end
    
    % For P03 and P07, originally the run order was: IS-SN, MI-MS, MC-MR = 1-2, 3-4, 5-6, 7-8, 7-8
    Tasks = [Task1;Task2;Task3]; % Order now becomes: 1,3,5,2,4,6,7,8
    clear Task1 Task2 Task3;
end

if Participant == 4
    Task1 = zeros(params.NrRuns,params.NrRepeats,params.NrVoxels); % Task a
    Task2 = zeros(params.NrRuns,params.NrRepeats,params.NrVoxels); % Task b
    
    % P04 has 8 runs with each its own 1x12 structure (6 trials task a, 6 trials task b).
    for i = 1:4 % I want to put these into the 'Tasks' variable of size (8,12,NrofVoxels).
        for ind = 1:6 
            Task1(i,ind,:) = Runs(i).vmp.Map(ind).VMPData(:); %  Retrieve task a 1st half.
            Task1(i,ind+6,:) = Runs(i+4).vmp.Map(ind).VMPData(:); % Retrieve task a 2nd half.
            Task2(i,ind,:) = Runs(i).vmp.Map(ind+6).VMPData(:); % Retrieve task b, 1st half.
            Task2(i,ind+6,:) = Runs(i+4).vmp.Map(ind+6).VMPData(:); % Retrieve task b, 2nd half.
        end
    end
    
    Tasks = [Task1;Task2]; % Has 1,2, 5,6, 3,4, 7,8
    clear Task1 Task2;
end

% All other participants have only 4 runs (thankfully).
if Participant == 1 | Participant == 2 | Participant == 5 | Participant == 6 | Participant == 8 | Participant == 9  % If participant 1,2,5,6,8 or 9...
    
    Task1 = zeros(params.NrRuns,params.NrRepeats,params.NrVoxels); % Task a
    Task2 = zeros(params.NrRuns,params.NrRepeats,params.NrVoxels); % Task b
    
    for i = 1:4 % For all the 4 runs
        for ind = 1:params.NrRepeats % For 12 trials
            Task1(i,ind,:) = Runs(i).vmp.Map(ind).VMPData(:); % Retrieve task a.
            Task2(i,ind,:) = Runs(i).vmp.Map(ind+12).VMPData(:); % +12 to get task b.
        end
    end

    Tasks = [Task1;Task2]; % (8x12xNrVoxels)
    clear Task1 Task2;
end

display('===== Done.');

%% Now put the tasks in the right order

% Put all the tasks in the same order: IS,SN,MI,MS,MC,MR,TI,OP. Note that
% due to the way I do task-extraction from the vmp files, the order changes again (see below).

% For P01: IS-MR	SN-MC	MI-TI	MS-OP = 1-6, 2-5, 3-7, 4-8 -> 1,2,3,4,6,5,7,8
% For P02: IS-OP	SN-TI	MI-MR	MS-MC = 1-8, 2-7, 3-6, 4-5 -> 1,2,3,4,8,7,6,5
% For P03: IS-SN	MI-MS	MC-MR   TI-OP = 1-2, 3-4, 5-6, 7-8 -> 1,3,5,2,4,6,7,8
% For P04: IS MI    SN-MS   MC-TI   MR OP = 1-3, 2-4, 5-7, 6-8 -> 1,2,5,6,3,4,7,8
% For P05: IS-TI	SN-OP	MI-MC	MS-MR = 1-7, 2-8, 3-5, 4-6 -> 1,2,3,4,7,8,5,6
% For P06: IS-MC	SN-MR	MI-OP	MS-TI = 1-5, 2-6, 3-8, 4-7 -> 1,2,3,4,5,6,8,7
% For P07: IS-SN	MI-MS	MC-MR   TI-OP = 1-2, 3-4, 5-6, 7-8 -> 1,3,5,2,4,6,7,8
% For P08: IS-MS	SN-MI	MC-OP	MR-TI = 1-4, 2-3, 5-8, 6-7 -> 1,2,5,6,4,3,8,7
% For P09: IS-SN	MI-MS	MC-MR	TI-OP = 1-2, 3-4, 5-6, 7-8 -> 1,3,5,7,2,4,6,8

P(1).Tasks = zeros(8,12,params.NrVoxels);

% P01: 1,2,3,4,6,5,7,8
if Participant == 1
    display('===== Sorting according to participant 1...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(3,:,:);
    P(1).Tasks(4,:,:) = Tasks(4,:,:);
    P(1).Tasks(5,:,:) = Tasks(6,:,:);
    P(1).Tasks(6,:,:) = Tasks(5,:,:);
    P(1).Tasks(7,:,:) = Tasks(7,:,:);
    P(1).Tasks(8,:,:) = Tasks(8,:,:);
end

if Participant == 2
    display('===== Sorting according to participant 2...')
    % P02:1,2,3,4,8,7,6,5
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(3,:,:);
    P(1).Tasks(4,:,:) = Tasks(4,:,:);
    P(1).Tasks(5,:,:) = Tasks(8,:,:);
    P(1).Tasks(6,:,:) = Tasks(7,:,:);
    P(1).Tasks(7,:,:) = Tasks(6,:,:);
    P(1).Tasks(8,:,:) = Tasks(5,:,:);
end

% For P03 and P07: IS-SN, MI-MS, MC-MR, TI-OP = 1-2, 3-4, 5-6, 7-8 ->1,3,5,2,4,6,7,8
if Participant == 3 | Participant == 7
    display('===== Sorting according to participant 3 or 7...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(4,:,:);
    P(1).Tasks(3,:,:) = Tasks(2,:,:);
    P(1).Tasks(4,:,:) = Tasks(5,:,:);
    P(1).Tasks(5,:,:) = Tasks(3,:,:);
    P(1).Tasks(6,:,:) = Tasks(6,:,:);
    P(1).Tasks(7,:,:) = Tasks(7,:,:);
    P(1).Tasks(8,:,:) = Tasks(8,:,:);
end

% P04: 1,2, 5,6, 3,4, 7,8
if Participant == 4
    display('===== Sorting according to participant 4...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(5,:,:);
    P(1).Tasks(4,:,:) = Tasks(6,:,:);
    P(1).Tasks(5,:,:) = Tasks(3,:,:);
    P(1).Tasks(6,:,:) = Tasks(4,:,:);
    P(1).Tasks(7,:,:) = Tasks(7,:,:);
    P(1).Tasks(8,:,:) = Tasks(8,:,:);
end

% P05:1,2,3,4,7,8,5,6
if Participant == 5
    display('===== Sorting according to participant 5...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(3,:,:);
    P(1).Tasks(4,:,:) = Tasks(4,:,:);
    P(1).Tasks(5,:,:) = Tasks(7,:,:);
    P(1).Tasks(6,:,:) = Tasks(8,:,:);
    P(1).Tasks(7,:,:) = Tasks(5,:,:);
    P(1).Tasks(8,:,:) = Tasks(6,:,:);
end

% P06:1,2,3,4,5,6,8,7
if Participant == 6
    display('===== Sorting according to participant 6...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(3,:,:);
    P(1).Tasks(4,:,:) = Tasks(4,:,:);
    P(1).Tasks(5,:,:) = Tasks(5,:,:);
    P(1).Tasks(6,:,:) = Tasks(6,:,:);
    P(1).Tasks(7,:,:) = Tasks(8,:,:);
    P(1).Tasks(8,:,:) = Tasks(7,:,:);
end

% P08: 1,2,5,6,4,3,8,7
if Participant == 8
    display('===== Sorting according to participant 8...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(2,:,:);
    P(1).Tasks(3,:,:) = Tasks(6,:,:);
    P(1).Tasks(4,:,:) = Tasks(5,:,:);
    P(1).Tasks(5,:,:) = Tasks(3,:,:);
    P(1).Tasks(6,:,:) = Tasks(4,:,:);
    P(1).Tasks(7,:,:) = Tasks(8,:,:);
    P(1).Tasks(8,:,:) = Tasks(7,:,:);
    P(1).Tasks = P(FeatureChoice).Tasks;
end

% For P09: IS-SN	MI-MS	MC-MR	TI-OP = 1-2, 3-4, 5-6, 7-8 ->
% 1,3, 5,7, 2,4, 6,8
if Participant == 9
    display('===== Sorting according to participant 9...')
    P(1).Tasks(1,:,:) = Tasks(1,:,:);
    P(1).Tasks(2,:,:) = Tasks(5,:,:);
    P(1).Tasks(3,:,:) = Tasks(2,:,:);
    P(1).Tasks(4,:,:) = Tasks(6,:,:);
    P(1).Tasks(5,:,:) = Tasks(3,:,:);
    P(1).Tasks(6,:,:) = Tasks(7,:,:);
    P(1).Tasks(7,:,:) = Tasks(4,:,:);
    P(1).Tasks(8,:,:) = Tasks(8,:,:);
end

clear Tasks
display('===== Done.');
    
end