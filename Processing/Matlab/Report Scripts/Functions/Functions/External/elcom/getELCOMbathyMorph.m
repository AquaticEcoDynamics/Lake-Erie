function [elev, areas, volumes] = getELCOMbathyMorph(bathFilename, nElev)

% function [] = getELCOMbathyMorph(bathFilename, nElev)
%
% Function to get the height vs area and height vs volume curves of an
% ELCOM bathmyetry file
%
% Inputs:
%		bathFilename  : filename of bathymetry file
%   nElev         : number of evenly space elevations
% Outputs:
%		elev    : heights of area and volume.  Elev is calulated from dz in file
%		areas   : total surface area as a function of elev
%		volume  : total volume as a function of elev
%
% Uses:
%		readELCOMbathy.m
%
% Written by C. Dallimore 16 June 06
%

if nargin ~= 2
	error('Incorrect number of arguments to getELCOMbathyMorph')
end

% Get Bathymetry from file
bathStruct = readELCOMbathy(bathFilename);

bath = (bathStruct.bathData);

% Remove land and open bc cells
pts = find(bath == bathStruct.land_value | ...
			 bath == bathStruct.open_value);
bath(pts) = NaN;

minHeight = min(min(bath))
maxHeight = max(max(bath));

% get Area of columns
cellArea = zeros(size(bath));
for i =1:bathStruct.x_rows
	for j =1:bathStruct.y_columns
		if ~isempty(bathStruct.dx)
			dx = bathStruct.dx(i);
		else
			dx = bathStruct.x_grid;
		end
		if ~isempty(bathStruct.dy)
			dy = bathStruct.dy(j);
		else
			dy = bathStruct.y_grid;
		end
		cellArea(i,j) = dx*dy;
	end
end

% get elevation, surface areas and volumes
elev    = zeros (nElev+1,1);
areas   = zeros (nElev+1,1);
volumes = zeros (nElev+1,1);

elev(1) = minHeight;
layerHeight = minHeight;
dz = (maxHeight-minHeight)/nElev;

for k = 1:nElev
	elev(k+1) = elev(k) + dz;
	pts = find(bath < elev(k+1));
	areas(k+1) = sum(cellArea(pts));
	volumes(k+1) = sum(cellArea(pts).*(elev(k+1)-bath(pts)));
end



