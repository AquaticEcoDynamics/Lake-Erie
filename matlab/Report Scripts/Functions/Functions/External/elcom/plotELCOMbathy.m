function [H,bathStruct] = plotELCOMbathy(filename)
% function [H, bathStruct] = plotELCOMbathy(filename)
%
% Inputs:
%		filename   : filename of bathymetry file
% Outputs
%       H          : Handle to graphic object
%		bathStruct : a matlab structure that contains all the data in the file
%
% Uses:
%		readELCOMbathy.m
%		pcolor_CD.m
%
% Written by C. Dallimore 1 Sept 04
%

% Get Bathymetry from file
bathStruct = readELCOMbathy(filename);
data = (bathStruct.bathData);

% Sort out x and y
if ~isempty(bathStruct.dx)
	dx1 = bathStruct.dx(1);
	x(1) = bathStruct.dx(1)/2.0;
	for i =2:bathStruct.x_rows
		x(i) = x(i-1)+bathStruct.dx(i-1)/2.0+bathStruct.dx(i)/2.0;
	end
else
	dx1 = bathStruct.x_grid;
	x(1) = bathStruct.x_grid/2.0;
	for i =2:bathStruct.x_rows
		x(i) = x(i-1)+bathStruct.x_grid;
	end
end
bathStruct.x = x;
if ~isempty(bathStruct.dy)
	dy1 = bathStruct.dy(1);
	y(1) = bathStruct.dy(1)/2.0;
	for i =2:bathStruct.y_columns
		y(i) = y(i-1)+bathStruct.dy(i-1)/2.0+bathStruct.dy(i)/2.0;
	end
else
	dy1 = bathStruct.y_grid;
	y(1) = bathStruct.y_grid/2.0;
	for i =2:bathStruct.y_columns
		y(i) = y(i-1)+bathStruct.y_grid;
	end
end
bathStruct.y = y;

% Remove land and open bc cells
pts = find(data == bathStruct.land_value | ...
			 data == bathStruct.open_value);
data(pts) = NaN;

H = pcolor_CD(y/1000,x/1000,data,dy1/1000,dx1/1000);
%H = pcolor(data);
set (gca,'ydir','reverse')
axis equal


function [H,c]= plotELCOMbathymetry(varargin);

% function [H,c]= plotELCOMbathymetry(file)
%
% funcion to plot ELCOM elcom sheet output
%
% Standard call
%   plotELCOMbathymetry(file)
%
% Specify line properties for contour plots
%   plotELCOMbathymetry(file,linespec)
%
% Specify line optional properties
%   plotELCOMbathymetry(file,linespec, ..)
%
%
% Inputs:
%		file      : bathymetry file to plot
%
% Optional Plot Properties: must be specified as name value pairs at end of call
%   plotType   : Type of plot can be
%                  pcolor
%                  pcolor_CD
%                  contour
%                  contourf
%                (defaults to pcolor_CD)
%   shadeType  : Type of shading for pcolor plots (defaults to flat)
%   contLevels : Contour levels  eg: [10:2:20]
%   xLabel     : text for xlabel axis (defaults to Distance(km))
%   yLabel     : text for ylabel axis (defaults to Z(m))
%   axisProps  : a cell array of name:value axis properties (ie passed to set(gca ...)
%                   eg: {'box','on','DataAspectRatio',[1 1 10]}
%   clim       : color limits
%
% Outputs
%   H         : figure handle
%   c         : contour matrix as described in CONTOURC
%
% Uses:
%		nldnc_timestep.m
%
% Written by C. Dallimore 9 June 06
%
%
c = [];

if (length(varargin) < 1);
	error('plotELCOMbathymetry require at least 1 argument')
end;

file = varargin{1};

if (length(varargin) > 3);
	args = {varargin{4:end}};
else
	args =[];
end

[plotType,shadeType,contLevels,   ...
	clim,xLabel,yLabel,lineStyle,         ...
	axisProps] = parseargs(args);

% Setup units of various input types
warning off

% Get Bathymetry from file
bathStruct = readELCOMbathy(filename);
plotData = (bathStruct.bathData);

% Sort out x and y
if ~isempty(bathStruct.dx)
	dx1 = bathStruct.dx(1);
	x(1) = bathStruct.dx(1)/2.0;
	for i =2:bathStruct.x_rows
		x(i) = x(i-1)+bathStruct.dx(i-1)/2.0+bathStruct.dx(i)/2.0;
	end
else
	dx1 = bathStruct.x_grid;
	x(1) = bathStruct.x_grid/2.0;
	for i =2:bathStruct.x_rows
		x(i) = x(i-1)+bathStruct.x_grid;
	end
end
bathStruct.x = x;
if ~isempty(bathStruct.dy)
	dy1 = bathStruct.dy(1);
	y(1) = bathStruct.dy(1)/2.0;
	for i =2:bathStruct.y_columns
		y(i) = y(i-1)+bathStruct.dy(i-1)/2.0+bathStruct.dy(i)/2.0;
	end
else
	dy1 = bathStruct.y_grid;
	y(1) = bathStruct.y_grid/2.0;
	for i =2:bathStruct.y_columns
		y(i) = y(i-1)+bathStruct.y_grid;
	end
end
bathStruct.y = y;

% Remove land and open bc cells
pts = find(plotData == bathStruct.land_value | ...
			 plotData == bathStruct.open_value);
plotData(pts) = NaN;


% plot data
if strcmp(plotType,'pcolor_CD')
	% due to hack for colormap we need to actually limit data to within clim
	if ~isempty(clim)
		pts = find(plotData < clim(1));
		plotData(pts) = clim(1);
		pts = find(plotData > clim(2));
		plotData(pts) = clim(2);
	end
	[H] = pcolor_CD(y/1000,x/1000,plotData,dy1/1000,dx1/1000);
	shading (shadeType)
elseif strcmp(plotType,'pcolor')
	% due to hack for colormap we need to actually limit data to within clim
	if ~isempty(clim)
		pts = find(plotData < clim(1));
		plotData(pts) = clim(1);
		pts = find(plotData > clim(2));
		plotData(pts) = clim(2);
	end
	[H] = pcolor(y/1000,x/1000,plotData);
	shading (shadeType)
elseif strcmp(plotType,'contourf')
	cmd = ['[c,H] = contourf(y/1000,x/1000,plotData,plotData'];
	if ~isempty(contLevels)
		cmd = [cmd,',contLevels'];
	end
	if ~isempty(lineStyle)
		cmd = [cmd,',lineStyle'];
	end
	cmd = [cmd,');'];
	eval(cmd)
	%H = H2(1);
elseif strcmp(plotType,'contour')
	cmd = ['[c,H] = contour(y/1000,x/1000,plotData,plotData'];
	if ~isempty(contLevels)
		cmd = [cmd,',contLevels'];
	end
	if ~isempty(lineStyle)
		cmd = [cmd,',lineStyle'];
	end
	cmd = [cmd,');'];
	eval(cmd)
	%H = H2(1);
else
	error(['invalid plotType in plotELCOMbathymetry', plotType])
end

set(gca,'ydir','reverse','layer','top')
axis equal

box on
set(gca,'layer','top')
if ~isempty (axisProps)
	set(gca,axisProps{1:end})
end

% x and y labels
xlabel(xLabel);
ylabel(yLabel);


function [plotType,shadeType,contLevels,   ...
					clim,xLabel,yLabel,lineStyle,         ...
					axisProps] = parseargs(argsIn)

% parse the arguments

% Set defaults
plotType = 'pcolor_CD';
shadeType = 'flat';
contLevels = [];
clim = [];
xLabel = 'Y (km)';
yLabel = 'X (km)';
lineStyle = '';
axisProps ={};

nargs = length(argsIn);
if nargs == 0
	return
end

% check for special string arguments trailing data arguments

[l,c,m,tmsg]=colstyle(argsIn{1});
if isempty(tmsg)
	lineStyle = argsIn{1};
	argsIn = argsIn(2:end);
end

for i = 1:nargs/2
	ii = i*2;
	propString = argsIn{ii-1};
	propVal = argsIn{ii};

	if isempty (propVal)
		continue
	end

	if strcmp(propString,'xlabel')
		xLabel = propVal;
	elseif strcmp(propString,'ylabel')
		yLabel = propVal;
	elseif strcmp(propString,'plotType')
		plotType = propVal;
	elseif strcmp(propString,'clim')
		clim = propVal;
	elseif strcmp(propString,'shadeType')
		shadeType = propVal;
	elseif strcmp(propString,'contLevels')
		contLevels = propVal;
	elseif strcmp(propString,'axisProps')
		axisProps = propVal;
	else
	end
end

