function [] = convertXYZtoELCOMbathy(bathFile,xyzFile,outlineFile,dx,dy,dz,land_value,open_value)

% function [] = convertXYZtoELCOMbathy(bathFile,,outlineFile,dx,dy,dz,land_value,open_value)
%
% Generate an ELCOM bathymetry file form xyz data
% Two input files are required.  One containg xyz data of bathymetry and one
% with xyz data of the lake outline.
%
% Inputs:
%		bathFile    : filename of output bathymetry file
%		xyzFile     : file containing three colums of xyz bathymetry data
%		outlineFile : file containing three colums of xyz data for perimiter of lake
%   dx          : dx value to use
%   dy          : dy value to use
%   dz          : dz value to use
%   land_value  : (optional) land_value for bath file (default is 999.9)
%   open_value  : (optional) land_value for bath file (default is 888.8)
%
% Uses:
%		writeELCOMbathy.m
%
% Written by C. Dallimore 20 July 06
%

if nargin == 6
  land_value = 999.9;
  open_value = 888.8;
elseif nargin ==7
  open_value = 888.8;
elseif nargin ==8
else
  error('Incorrect number of arguments to convertXYZtoELCOMbathy')
end

% Load files and store data
xyz = load (xyzFile);
x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

plot3(x,y,z,'+')
stop

outline_xyz = load (outlineFile);
outline_x = outline_xyz(:,1);
outline_y = outline_xyz(:,2);
outline_z = outline_xyz(:,3);

x=[x; outline_x];
y=[y; outline_y];
z=[z; outline_z];

% Caclulate regularly spaced x and y data
newx = [min(x)-dy:dy:max(x)+dy];
newy = [min(y)-dx:dx:max(y)+dx];

% Use grid data to generate bathy grid
[newX,newY] = meshgrid(newx,newy);
newZ = griddata(x,y,z,newX,newY,'linear');
zlayers = ceil((max(max(newZ))-min(min(newZ)))/dz)+1

% Remove pts outside the polygon defined by the xyz outline file
inlake = inpolygon(newX,newY,outline_x,outline_y);
pts = find (inlake ~=1);
newZ(pts)=land_value;

% Generate bathstruct for writeELCOMbathy
bathStruct.dx = [];
bathStruct.dy = [];

bathStruct.file = bathFile;
bathStruct.title = '''TITLE''';
bathStruct.analyst = '''ANALYST''';
bathStruct.organization = '''ORGANIZATION''';
bathStruct.comment = ['''Created with convertXYZtoELCOMbathy.m using ',xyzFile,' and ',outlineFile,''''];
bathStruct.overwrite = 'yes';

bathStruct.x_rows = length(newy);
bathStruct.y_columns = length(newx);
bathStruct.z_layers = zlayers;
bathStruct.n_max = 0;
bathStruct.land_value = land_value;
bathStruct.open_value = open_value;
bathStruct.north_x = -1;
bathStruct.north_y = 0;
bathStruct.x_grid = dx;
bathStruct.y_grid = dy;
bathStruct.dz(1:bathStruct.z_layers ) = dz;
bathStruct.latitude0 = 0;
bathStruct.longitude0= 0;
bathStruct.altitude = 0;

bathStruct.bathData = flipud(newZ);

% Write bath file
writeELCOMbathy(bathFile,bathStruct);
