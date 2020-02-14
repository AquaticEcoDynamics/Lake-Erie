clear all; close all;
load erie_stn.mat;

sites = fieldnames(erie_stn);

for i = 1:length(sites)
    vars = fieldnames(erie_stn.(sites{i}));
    
    S(i).X = erie_stn.(sites{i}).(vars{1}).X;
    S(i).Y = erie_stn.(sites{i}).(vars{1}).Y;
    S(i).Name = sites{i};
    S(i).Geometry = 'Point';
    S(i).Agency = erie_stn.(sites{i}).(vars{1}).source;
end
shapewrite(S,'erie_stn.shp');