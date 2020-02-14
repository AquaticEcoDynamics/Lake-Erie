clear all; close all;

addpath(genpath('Functions'));

ncfile = 'D:\Studysites\Erie\Simulations\2013_tfv_erie_v1_WS_NC_Interp_Met\Output\erie.nc';

data = tfv_readnetcdf(ncfile,'names',{'W10_x';'W10_y';'cell_X';'cell_Y'});

ts = 1;

quiver(data.cell_X,data.cell_Y,data.W10_x(:,ts),data.W10_y(:,ts));