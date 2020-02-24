clear all; close all;

load erie_mat.mat;
load erie_stn.mat;

erie = erie_stn;

sites = fieldnames(erie_mat);

for i = 1:length(sites)
    if ~isfield(erie,sites{i})
        erie.(sites{i}) = erie_mat.(sites{i});
    else
        erie.([sites{i},'a']) = erie_mat.(sites{i});
    end
end

sites = fieldnames(erie);
for i = 1:length(sites)
    vars = fieldnames(erie.(sites{i}));
    for j = 1:length(vars)
        erie.(sites{i}).(vars{j}).Agency = erie.(sites{i}).(vars{j}).source;
    end
end

sites = fieldnames(erie);
for i = 1:length(sites)
    vars = fieldnames(erie.(sites{i}));
    for j = 1:length(vars)
        
        sss = find(erie.(sites{i}).(vars{j}).Data < 0);
        erie.(sites{i}).(vars{j}).Data(sss) = NaN;
    end
end


save erie.mat erie -mat
save ../Data_Review/erie.mat erie -mat
save('E:\Github 2018\aed_matlab_modeltools\TUFLOWFV\polygon_timeseries_plotting\matfiles\erie.mat','erie','-mat');
%plot_data_polygon_regions_final;

% agency =  [];
% 
% sites = fieldnames(erie);
% for i = 1:length(sites)
%     vars = fieldnames(erie.(sites{i}));
%     for j = 1:length(vars)
%         agency = [agency;{erie.(sites{i}).(vars{j}).Agency}];
%         %erie.(sites{i}).(vars{j}).Agency = erie.(sites{i}).(vars{j}).source;
%     end
% end