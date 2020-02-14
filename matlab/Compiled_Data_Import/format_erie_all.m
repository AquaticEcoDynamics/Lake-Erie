clear all; close all;

load erie_all.mat;


stn = [];

sites = fieldnames(erie_all);

for i = 1:length(sites)
    vars = fieldnames(erie_all.(sites{i}));
    for j = 1:length(vars)
        stn = [stn;{erie_all.(sites{i}).(vars{j}).station}];
    end
end

ustn = unique(stn);

erie_stn = [];


for i = 1:length(sites)
    vars = fieldnames(erie_all.(sites{i}));
    for j = 1:length(vars)
        
        sss = find(strcmpi(ustn,erie_all.(sites{i}).(vars{j}).station) == 1);
        
        if ~isfield(erie_stn,ustn{sss})
            erie_stn.(ustn{sss}).(vars{j}) = erie_all.(sites{i}).(vars{j});
        else
            if ~isfield(erie_stn.(ustn{sss}),vars{j})
                erie_stn.(ustn{sss}).(vars{j}) = erie_all.(sites{i}).(vars{j});
            else
                erie_stn.(ustn{sss}).(vars{j}).Date = [erie_stn.(ustn{sss}).(vars{j}).Date;erie_all.(sites{i}).(vars{j}).Date];
                erie_stn.(ustn{sss}).(vars{j}).Data = [erie_stn.(ustn{sss}).(vars{j}).Data;erie_all.(sites{i}).(vars{j}).Data];
                erie_stn.(ustn{sss}).(vars{j}).Depth = [erie_stn.(ustn{sss}).(vars{j}).Depth;erie_all.(sites{i}).(vars{j}).Depth];
            end
        end
    end
end

save erie_stn.mat erie_stn -mat
  

plot_data_polygon_regions;
        