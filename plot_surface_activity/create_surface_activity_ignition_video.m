function create_surface_activity_ignition_video(activity_surface_map,recorded_trial_stage_names,recording_times,dt,anatomical_surface,outname)
% create_surface_activity_ignition_video(activity_surface_map,recorded_trial_stage_names,recording_times,dt,anatomical_surface,outname)
%
% visualise videos of activity on the surface
%
% Depends on Guillaume Flandin's GIFTI toolbox https://www.artefact.tk/software/matlab/gifti/
%
% activity_surface_map - gifti surface containing activity 
% recorded_trial_stage_names - names of trial stages in time
% recording_times - timesteps with associated maps
% dt - timestep
% anatomical_surface - surface to plot on e.g. l_inflated, l_pial etc.
% outname - basename for the video output
% e.g. 
% create_surface_activity_ignition_video(catch_trial_pop_1_gifti,recorded_trial_stage_names,recording_times,dt,l_inflated,'videos/catch_trial')


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

%%%%% Target cue populations %%%%%%%%%%%
close all;
myfig = figure('units','normalized','outerposition',[0.5 0.4 0.5 0.6]);
set(gcf,'color','w');
colormap(customcmap);
mysurf = plot(anatomical_surface,activity_surface_map,1);
direction1 = [0 1 0];
direction2 = [0 0 1];
direction3 = [1 0 0];
rotate(mysurf,direction1,60);
rotate(mysurf,direction2,90);
rotate(mysurf,direction3,15);
h = colorbar;
set(h,'location','southoutside')
h.FontSize = 20;
caxis([0,60]);
h.Label.String = 'firing rate (Hz)';
material([0.5,0.5,0.15]);

%% Initialize video

sprintf('saving %s.mp4',outname)

myVideo = VideoWriter(outname,'MPEG-4'); %open video file
myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
open(myVideo)

for current_recording_time=1:size(activity_surface_map.cdata,2);
  title(sprintf('%s , time = %s s',  recorded_trial_stage_names{current_recording_time},num2str(recording_times(current_recording_time).*dt)),'FontSize', 20);     
  set(get(gca,'title'),'Position',[-14.2790   20.0167    0.6315])

  set(mysurf,'FaceVertexCData',activity_surface_map.cdata(:,current_recording_time));
  drawnow;
  % decide how long to wait between drawing each new timepoint
  pause(0.1)
  
  frame = getframe(gcf); %get frame
  writeVideo(myVideo, frame);
end
close(myVideo)
end
