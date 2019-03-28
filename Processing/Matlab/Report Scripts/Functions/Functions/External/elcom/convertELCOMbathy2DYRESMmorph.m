function [] = convertELCOMbathy2DYRESMmorph(bathFilename,morphFilename, nElev)

% function [] = convertELCOMbathy2DYRESMmorph(bathFilename,morphFilename)
%
% Inputs:
%		bathFilename  : filename of bathymetry file to convert
%		morphFilename : output file name (optional)
%                       if absent set to bathFilename.stg
%		nElev 				: number of elevation levels (optional)
%                       if absent set to 100
%
% Uses:
%		readELCOMbathy.m
%   getELCOMbathyMorph.m
%
% Written by C. Dallimore 9 August 05
%

% Get Bathymetry from file
bathStruct = readELCOMbathy(bathFilename);

bath = (bathStruct.bathData);

% Remove land and open bc cells
pts = find(bath == bathStruct.land_value | ...
       bath == bathStruct.open_value);
bath(pts) = NaN;

minHeight = min(min(bath));
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
zeroHtElevation = 0;
dz1 = zeroHtElevation;
layerHeight = minHeight;
elev= zeros (size(bathStruct.dz));
surfArea= zeros (size(bathStruct.dz));
volume= zeros (size(bathStruct.dz));

% set default filename
if nargin < 3
  nElev = 100;
end
[elev,surfArea,volume] = getELCOMbathyMorph(bathFilename, nElev);

% set default filename
if nargin < 2
  morphFilename= [bathFilename,'.stg'];
end

fid = fopen(morphFilename,'w');

fprintf(fid,'<#3>\n');
fprintf(fid,['Converted morphometry\n']);
fprintf(fid,[num2str(bathStruct.latitude0),'   # latitude\n']);
fprintf(fid,[num2str(bathStruct.altitude),'   # height above MSL\n']);
fprintf(fid,['0						# number of inflowing streams\n']);
fprintf(fid,[num2str(zeroHtElevation),'   #zero-ht elevation\n']);
fprintf(fid,[num2str(elev(nElev)),'   #crest elevation [m]\n']);
fprintf(fid,['0						#number of outlets\n']);
fprintf(fid,[num2str(nElev),'  #number of stg survey points after headerline\n']);
fprintf(fid,['Elev [m] A [m^2]	V [m^3]\n']);
for k = 1:nElev
  fprintf(fid,[num2str(elev(k)),'  ',num2str(surfArea(k)),'  ',num2str(volume(k)),'\n']);
end

fclose(fid);


