function gis = readconfGIS(fullpath)
% This function proceses the csv file and output the GIS data in a
% structured type called gis.
warning off

datafile =[fullpath.confpth, '/gis/reference.xls'];
[num,str] = xlsread(datafile);

grids = str(2:end,1);
X = num(:,1);
Y = num(:,2);
Zone = num(:,3);
for ii = 1:length(grids)
    eval(['gis.',grids{ii},'.X = X(ii);']);
    eval(['gis.',grids{ii},'.Y = Y(ii);']);
    eval(['gis.',grids{ii},'.Zone = Zone(ii);']);
end

warning on