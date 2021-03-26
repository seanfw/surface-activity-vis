function create_surface_activity_ignition_map(rates_file,recording_times,output_file_basename)


% create_surface_activity_ignition_map(rates_file,recording_times,output_file_basename)
%
% A function to create a surface image corresponding to simulated activity
% data
%
% Depends on Guillaume Flandin's GIFTI toolbox https://www.artefact.tk/software/matlab/gifti/
%
% usage: create_surface_activity_map(rates_file,recording_times)
% rates_file: a 3d array, with dims (n_timepoints,n_areas,n_populations)
% recording_times: and array corresponding to the timepoints to plot
% output_file_basename: the base name of the output files
% e.g. create_surface_activity_ignition_map(hit_trial.mat,[2000:20:2300,2400:100:4000],'hit_rates')


%%
num_areas = size(rates_file,2);

num_recording_times = length(recording_times);
% load in left hemisphere inflated surface
l_inflated = gifti('surface_files/MacaqueYerkes19.L.inflated.32k_fs_LR.surf.gii');
% load in LH kennedy atlas (91 regions)
kennedy_atlas_91 = gifti('surface_files/kennedy_atlas_91.label.gii');

%%
% load in a gifti file of the right type in order to get a
% template to write over
example = gifti('surface_files/cortical_thickness.func.gii');
num_vertices = length(example.cdata);
example.cdata = zeros(num_vertices,num_recording_times);
%%
% get area List in Donahue order
% areaList_Donahue = kennedy_atlas_91.labels.name(2:end)';
% Note 18-Jan-2021 - for some reason the labels.name method has stopped
% correctly reading the label file.
load surface_files/areaList_Donahue.mat
load surface_files/jorge_m_areas.mat
% [~, Sean_areas_in_Donahue_idx] = ismember(subgraph_hierarchical_order,areaList_Donahue);
% Use the 30 areas from Mejias & Wang, 2021 instead of the 40 areas in
% Froudist-Walsh et al., 2021
[~, Jorge_areas_in_Donahue_idx] = ismember(jorge_m_areas,areaList_Donahue);

%%


population = 1:2; % which population within an area to record from
for current_population = 1:length(population)
rate_map = example;

for current_time = 1:num_recording_times
    
for current_parcel = 1:num_areas
    
    vertices_in_parcel = find(kennedy_atlas_91.cdata==Jorge_areas_in_Donahue_idx(current_parcel)); % note kennedy_atlas_91.cdata ranges from 0-91, not 1-92

    rate_map.cdata(vertices_in_parcel,current_time) = rates_file(recording_times(current_time),current_parcel,current_population);
    
end

end
rates_fileout = strcat('maps/', output_file_basename,'_pop',num2str(current_population),'.func.gifti');
sprintf('saving %s', rates_fileout)
save(rate_map,rates_fileout,'Base64Binary');

end


