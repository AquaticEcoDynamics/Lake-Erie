clear all; close all;

load erie.mat;

sites = fieldnames(erie);

avars = [];

for i = 1:length(sites)
    vars = fieldnames(erie.(sites{i}));
    avars = [avars;vars];
    
end

uvars = unique(avars);