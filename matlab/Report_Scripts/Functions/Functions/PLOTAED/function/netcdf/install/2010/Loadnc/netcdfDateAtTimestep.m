function [dateAtTimestep] = netcdfDateAtTimestep(filename, t, dateFormat)
% function [dateAtTimestep] = netcdfDateAtTimestep(filename, t, dateFormat)
%
% Get the time of a ELCOM netcdf file at a give timestep
%
% Inputs:
%		filename   : a ELCOM netcdf file
%   t          : timestep to load date of
%   dateFormat : Optional argument for specifing output format
%                Valid values are:
%                  'matlab'  - for matlab date  (Default)
%                  'CWR'  - for CWR Ordinal Date
% Outputs
%		dateAtTimestep : timestep to load
%
% Uses:
%
% Written by C. Dallimore 19 Jan 06

if nargin > 3 | nargin < 2
  error('netcdfDateAtTimestep require at 2 or 3 arguments')
elseif nargin == 2
  dateFormat = 'matlab';
end

ncobj = netcdf(filename, 'nowrite');
variables = var(ncobj);

dimName = 'Ordinal_Dates';
for ii = 1:length(variables)
  if strcmp(dimName,cellstr(name(variables{ii})))
    Ordinal_Date_Var = variables{ii};
  end
end

Ordinal_Date = Ordinal_Date_Var (t);

if strcmp(dateFormat,'matlab')
  dateAtTimestep = CWRdate2matlab(Ordinal_Date);
elseif strcmp(dateFormat,'CWR')
  dateAtTimestep = Ordinal_Date;
else
  error('netcdfDateLimits require at 1 or 2 arguments')
end

