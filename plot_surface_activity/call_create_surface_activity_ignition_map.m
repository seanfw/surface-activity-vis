% Visualise activity on the cortical surface

%% load in the anatomical surface data
l_inflated = gifti('surface_files/MacaqueYerkes19.L.inflated.32k_fs_LR.surf.gii');

%% load simulation data
miss_data_struct = load('miss_data.mat');
miss_data = miss_data_struct.R;

catch_data_struct = load('catch_data.mat');
catch_data = catch_data_struct.R;

%% Decide timesteps to create maps for and visualise
% Decide the timesteps you want to view maps for
step = 20; % in timesteps
num_iterations = size(miss_data,1);
recording_times = [1:step:num_iterations];

%% Define trial stages (to show stimulus time on video)
% Ulysse, please fill in the real values here, I'm guessing from looking at
% your outputs, cheers, SFW.

stim_on = 0.002; % sec
stim_off = 0.9; % sec
dt = 0.001; % sec
trial_stage = zeros(num_iterations,1);
trial_stage_names = {'stimulus','stimulus','post-stimulus'};
trial_stage(1:round((stim_on/dt)-1)) = 1;
trial_stage(round(stim_on/dt):round(stim_off/dt)) = 2;
trial_stage(round(stim_off/dt):end) = 3;
recorded_trial_stage_names = trial_stage_names(trial_stage(recording_times));


%% Subset of maps to create png files for
cue_map = 500/step;
propagation_map = 1000/step;
end_map = 2000/step;

%% map miss trial data to surface

% map activity onto surface
disp('mapping miss trial data to surface')
create_surface_activity_ignition_map(miss_data,recording_times,'miss_trial')

miss_trial_pop_1_gifti = gifti('maps/miss_trial_pop1.func.gii');

%% Create surface images for selected timepoints on the miss trial

disp('creating snapshots of miss trial activity on surface')

% plot initial cue-related activity in population 1
create_surface_activity_ignition_snapshot(miss_trial_pop_1_gifti,cue_map,l_inflated,'yes','images/miss_trial_cue.png')

% plot activity in population 1 during propagation
create_surface_activity_ignition_snapshot(miss_trial_pop_1_gifti,propagation_map,l_inflated,'yes','images/miss_trial_propagation.png')

% plot activity in population 1 near the end of the trial
create_surface_activity_ignition_snapshot(miss_trial_pop_1_gifti,end_map,l_inflated,'yes','images/miss_trial_end.png')

%% Create video of miss trial activity
disp('creating video of miss trial activity on surface')

create_surface_activity_ignition_video(miss_trial_pop_1_gifti,recorded_trial_stage_names,recording_times,dt,l_inflated,'videos/miss_trial')

%% map catch (hit) trial data to surface

% map activity onto surface
disp('mapping catch trial data to surface')
create_surface_activity_ignition_map(catch_data,recording_times,'catch_trial')
catch_trial_pop_1_gifti = gifti('maps/catch_trial_pop1.func.gii');

%% Create surface images for selected timepoints on the catch/hit trial

disp('creating snapshots of miss trial activity on surface')


% plot initial cue-related activity in population 1
create_surface_activity_ignition_snapshot(catch_trial_pop_1_gifti,cue_map,l_inflated,'yes','images/catch_trial_cue.png')

% plot activity in population 1 during propagation
create_surface_activity_ignition_snapshot(catch_trial_pop_1_gifti,propagation_map,l_inflated,'yes','images/catch_trial_propagation.png')

% plot activity in population 1 near the end of the trial
create_surface_activity_ignition_snapshot(catch_trial_pop_1_gifti,end_map,l_inflated,'yes','images/catch_trial_end.png')

%% Create video of catch/hit trial activity
disp('creating video of catch trial activity on surface')

create_surface_activity_ignition_video(catch_trial_pop_1_gifti,recorded_trial_stage_names,recording_times,dt,l_inflated,'videos/catch_trial')

disp('finished')
