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

save erie.mat erie -mat
save ../Data_Review/erie.mat erie -mat

%plot_data_polygon_regions_final;

