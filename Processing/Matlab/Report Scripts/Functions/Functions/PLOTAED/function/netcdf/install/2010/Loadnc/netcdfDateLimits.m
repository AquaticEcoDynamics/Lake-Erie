function [dateLim, nt] = netcdfDateLimits(filename, dateFormat)
% function [dateLim] = netcdfDateLimits(filename, dateFormat)
%
% Get the closest timestep of a ELCOM netcdf file to a given time
%
% Inputs:
%		filename   : a ELCOM netcdf file
%   dateFormat : Optional argument for specifing output format
%                Valid values are:
%                  'matlab'  - for matlab date  (Default)
%                  'CWR'  - for CWR Ordinal Date
% Outputs
%		dateLim    : [minDateValue maxDateValue]
%   nt         : number of timesteps
%
% Uses:
%
% Written by C. Dallimore 19 Jan 06

if nargin > 2 | nargin < 1
  error('netcdfDateLimits require at 1 or 2 arguments')
elseif nargin == 1
  dateFormat = 'matlab';
end

ncobj = netcdf(filename, 'nowrite');

dimName = 'Ordinal_Dates';
dimVar = ncobj{dimName};
Ordinal_Dates = dimVar (:);
nt = length(Ordinal_Dates);

if strcmp(dateFormat,'matlab')
  dateLim = CWRdate2matlab([min(Ordinal_Dates) max(Ordinal_Dates)]);
elseif strcmp(dateFormat,'CWR')
  dateLim = [min(Ordinal_Dates) max(Ordinal_Dates)];
else
  error('netcdfDateLimits require at 1 or 2 arguments')
end

