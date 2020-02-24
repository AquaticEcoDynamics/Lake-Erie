clear all;close all;

dirlist = dir(['LL/','*.nc']);

for i = 1:length(dirlist)
    
    filename = ['LL/',dirlist(i).name];
    
    X = ncread(filename,'X');
    Y = ncread(filename,'Y');
    
    lonX = ncread(filename,'lon');
    latY = ncread(filename,'lat');
    
    lat = [];
    lon = [];
    
    for i = 1:length(X)
    [~,lon(i)] = utm2ll(X(i),Y(1),17);
    end
    for i = 1:length(Y)
    [lat(i),~] = utm2ll(X(1),Y(i),17);
    end
    
    ncwrite(filename,'lon',lon);
    ncwrite(filename,'lat',lat);
     
    lonX1 = ncread(filename,'lon');
    latY1 = ncread(filename,'lat');   
    
    
    
end
    
    