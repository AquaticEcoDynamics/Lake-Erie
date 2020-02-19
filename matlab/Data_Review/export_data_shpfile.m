clear all; close all;

load erie.mat;

sites = fieldnames(erie);

for i = 1:length(sites)
    S(i).Site = sites{i};
    
    vars = fieldnames(erie.(sites{i}));
    S(i).X = erie.(sites{i}).(vars{1}).X;
    S(i).Y = erie.(sites{i}).(vars{1}).Y;
    S(i).Agency = erie.(sites{i}).(vars{1}).source;
    S(i).Geometry = 'Point';
end
    
shapewrite(S,'Erie_Stations.shp');