clear all; close all;


filename = 'Precipitation_utm_20130507_20150930_2.nc';

Y = ncread(filename,'Y');
Y = Y + 8000;

ncwrite(filename,'Y',Y);

filename = 'Radiation_utm_20130507_20150930_2.nc';

Y = ncread(filename,'Y');
Y = Y + 8000;

ncwrite(filename,'Y',Y);

filename = 'RelHum_utm_20130507_20151001_2.nc';

Y = ncread(filename,'Y');
Y = Y + 8000;

ncwrite(filename,'Y',Y);

filename = 'Temperature_utm_20130507_20151001_2.nc';

Y = ncread(filename,'Y');
Y = Y + 8000;

ncwrite(filename,'Y',Y);

filename = 'Wind_utm_20130507_20151001_2.nc';

Y = ncread(filename,'Y');
Y = Y + 8000;

ncwrite(filename,'Y',Y);
