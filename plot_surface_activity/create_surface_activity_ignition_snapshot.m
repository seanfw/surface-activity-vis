function create_surface_activity_ignition_snapshot(activity_surface_map,timepoint_of_interest,anatomical_surface,savefile,outfilename)
% create_surface_activity_ignition_snapshot(activity_surface_map,timepoint_of_interest,anatomical_surface,savefile,outfilename)
%
% Create snapshots of activity on the surface
%
% Depends on Guillaume Flandin's GIFTI toolbox https://www.artefact.tk/software/matlab/gifti/
%
% activity_surface_map - gifti surface containing activity 
% timepoint_of_interest - the timepoint you want to view
% anatomical_surface - surface to plot on e.g. l_inflated, l_pial etc.
% savefile - 'yes' or 'no'
% outfilename - full output file name
% e.g. 
% create_surface_activity_ignition_snapshot(catch_trial_pop_1_gifti,cue_map,l_inflated,'yes','images/catch_trial_cue.png')



% Colours from Colorbrewer2 https://colorbrewer2.org/#type=sequential&scheme=Reds&n=9
nineclassReds = [255,245,240;
254,224,210;
252,187,161;
252,146,114;
251,106,74;
239,59,44;
203,24,29;
165,15,21;
103,0,13]./255;

customcmap = nineclassReds;

close all;
myfig = figure('units','normalized','outerposition',[0.5 0.4 0.5 0.6]);
set(gcf,'color','w');
colormap(customcmap)
mysurf = plot(anatomical_surface,activity_surface_map,timepoint_of_interest);
direction1 = [0 1 0];
direction2 = [0 0 1];
direction3 = [1 0 0];
rotate(mysurf,direction1,60);
rotate(mysurf,direction2,90);
rotate(mysurf,direction3,15);
h = colorbar;
set(h,'location','southoutside')
h.FontSize = 20;
caxis([0,60])
h.Label.String = 'firing rate (Hz)';
material([0.5,0.5,0.15])

if savefile == 'yes'
    sprintf('saving %s',outfilename)
    saveas(myfig,outfilename);

end

end
