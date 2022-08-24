clear all; close all;


data = tfv_readnetcdf('Radiation_utm_20130507_20150930_2.nc');

data.X = double(data.X);
data.Y = double(data.Y);
int = 1;
S.X(int) = min(data.X);
S.Y(int) = min(data.Y);

int = int + 1;
S.X(int) = max(data.X);
S.Y(int) = min(data.Y);

int = int + 1;
S.X(int) = max(data.X);
S.Y(int) = max(data.Y);

int = int + 1;
S.X(int) = min(data.X);
S.Y(int) = max(data.Y);

S.Geometry = 'Polygon';
S.Name = 'Met';


shapewrite(S,'Met_rad.shp');

% %%
% 
% data.X = double(data.X);
% data.Y = double(data.Y) + 8000;
% int = 1;
% S.X(int) = min(data.X);
% S.Y(int) = min(data.Y);
% 
% int = int + 1;
% S.X(int) = max(data.X);
% S.Y(int) = min(data.Y);
% 
% int = int + 1;
% S.X(int) = max(data.X);
% S.Y(int) = max(data.Y);
% 
% int = int + 1;
% S.X(int) = min(data.X);
% S.Y(int) = max(data.Y);
% 
% S.Geometry = 'Polygon';
% S.Name = 'Met';
% 
% 
% shapewrite(S,'Met2.shp');