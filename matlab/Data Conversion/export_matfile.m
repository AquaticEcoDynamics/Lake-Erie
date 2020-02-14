clear all; close all;

outdir = 'Images/';

load Lake_Erie_2013_20191126.mat;

%data = LAKE_ERIE_2013.ECCC_WATER_QUALITY;

fd = fieldnames(LAKE_ERIE_2013);

for i = [1 2 3 5]%1:length(fd)
    sites = fieldnames(LAKE_ERIE_2013.(fd{i}));
    for j = 1:length(sites)
        data.(sites{j}) = LAKE_ERIE_2013.(fd{i}).(sites{j});
    end
    
    
end




sites = fieldnames(data);
for i = 1:length(sites)
    vars = fieldnames(data.(sites{i}));
    for j = 1:length(vars)
        data.(sites{i}).(vars{j}).Date = datenum(data.(sites{i}).(vars{j}).DATE,'yyyy-mm-dd');
        data.(sites{i}).(vars{j}).Data = data.(sites{i}).(vars{j}).DATA;
        data.(sites{i}).(vars{j}).Depth = data.(sites{i}).(vars{j}).DEPTH;
    end
end

summerise_data(data,outdir,'erie.shp');

