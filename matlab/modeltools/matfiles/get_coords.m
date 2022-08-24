clear all; close all;

load erie.mat;

stn_id = 'STN_1274';

vars = fieldnames(erie.(stn_id));

X = erie.(stn_id).(vars{1}).X;
Y = erie.(stn_id).(vars{1}).Y;

ncfile = 'X:\Erie\v11\Output.d\erie_11_d_TFV.nc';

ncX = ncread(ncfile,'cell_X');
ncY = ncread(ncfile,'cell_Y');
idx2 = ncread(ncfile,'idx2');
idx3 = ncread(ncfile,'idx3');


pnt(1,1) = X;
pnt(1,2) = Y;

geo_x = double(ncX);
geo_y = double(ncY);
dtri = DelaunayTri(geo_x,geo_y);

pt_id = nearestNeighbor(dtri,pnt);


Cell_3D_IDs = find(idx2==pt_id);

surfIndex = min(Cell_3D_IDs);
botIndex = max(Cell_3D_IDs);
Index_2D = pt_id;

