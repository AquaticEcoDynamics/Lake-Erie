clear all; close all;

addpath(genpath('Functions'));


grid = 'Erie_V6.2dm';
outfile = 'Erie_V6_Substrates.2dm';

shp = shaperead('Substrate_v2utm.shp');

[XX,YY,nodeID,faces,X,Y,Z,ID] = tfv_get_node_from_2dm(grid);

mat_zones(1:length(X)) = 1;

for i = 1:length(X)
    for j = 1:length(shp)
        if inpolygon(X(i),Y(i),shp(j).X,shp(j).Y)
            mat_zones(i) = shp(j).MatZone;
        end
    end
end

mat_zones(mat_zones ==0) = 1;

% for i = 1:length(shp)
%     sZ(i,1) = shp(i).Density;
%     sX(i,1) = shp(i).X;
%     sY(i,1) = shp(i).Y;
% end
% 
% F = scatteredInterpolant(sX,sY,sZ,'linear','nearest');
% 
% mat_zones = F(X,Y);
% 
% mat_zones(mat_zones <= 10) = 1;
% 
% ss = find(mat_zones >10 & mat_zones <= 100);
% 
% mat_zones(ss) = 2;
% 
% ss = find(mat_zones >100 & mat_zones <= 1000);
% 
% mat_zones(ss) = 3;
% 
% ss = find(mat_zones >1000 & mat_zones <= 10000);
% 
% mat_zones(ss) = 4;
% 
% ss = find(mat_zones >10000);
% 
% if ~isempty(ss)
%     mat_zones(ss) = 5;
% end

%_________________________________________________________________________


%______________________________________

fid = fopen(grid,'rt');
fid1 = fopen(outfile,'wt');

for i = 1:3 %headers
    fline = fgetl(fid);
    fprintf(fid1,'%s\n',fline);
end
fline = fgetl(fid);

str = strsplit(fline);

inc = 1;
while strcmpi(str{1},'ND') == 0
    for i = 1:length(str)-1
        fprintf(fid1,'%s ',str{i});
    end
    fprintf(fid1,'%s\n',num2str(mat_zones(inc)));
    inc = inc + 1;
    
    fline = fgetl(fid);
    
    str = strsplit(fline);
end
fprintf(fid1,'%s\n',fline);
while ~feof(fid)
    fline = fgetl(fid);
    fprintf(fid1,'%s\n',fline);
end
fclose(fid);
fclose(fid1);


convert_2dm_to_shp(outfile)



