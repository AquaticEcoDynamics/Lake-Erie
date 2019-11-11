function [minVal maxVal] = getNetCDFMinMaxAttributes(fileName,varName)
% function [data] = getNetCDFMinMaxAttributes(fileName,varName)
%
% Get the minValue and maxValue of a vaariable in an ELCOM netcdf file
% These are attribute to the variables caclulated by dbconv
%
% Inputs:
%		fileName : a netcdf file
%   varName  : variable name to get min max for eg: 'TEMPERATURE'
% Outputs
%		[minVal maxVal]    : minimum and maximum of the data
%
% Uses:
%
% Written by C. Dallimore 19 Jan 06
%

ncobj = netcdf(fileName, 'nowrite');

% Get variable object
variables = var(ncobj);

for ii = 1:length(variables)
	if strcmp(varName,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end

if isempty(ncVariable)
	data = [];
	disp ('Variable not found.  Valid variables are')
	for i = 1:length(variables)
		self = variables{i};
		theNCid = ncid(self);
		theVarid = varid(self);
		[dimName, dimSize] = ncmex('varinq', theNCid, theVarid);
		disp(['  ',dimName])
	end
	return
end

if strcmp('BATHY',varName)
% Check for Bathym
	data = ncVariable (:,:);
	pts = find(data < -9.9e+16);
	data(pts) = NaN;
	minVal = min(min(data));
	maxVal = max(max(data));
else
	minVal = ncVariable.MinValue(1);
	maxVal = ncVariable.MaxValue(1);
end

clear ncobj
