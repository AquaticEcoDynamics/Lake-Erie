function [timeStep] = netcdfClosestTimestepToDate(filename, CWRDate)
% function [dateLim] = netcdfClosestTimestepToDate(filename, CWRDate)
%
% Get closest timestep of an ELCOM netcdf file to a given date in CWR format
%
% Inputs:
%		filename   : a ELCOM netcdf file
%   CWRDate    : CWR Ordinal Date
% Outputs
%		timeStep   : closest timestep
%
% Uses:
%
% Written by C. Dallimore 19 Jan 06

if nargin ~= 2
  error('netcdfClosestTimestepToDate requires 2 arguments')
end

if isjava(filename)
  Ordinal_Dates = filename.getCWRDateArray();
elseif isstruct(filename)
  Ordinal_Dates = filename.Ordinal_Dates;
else
  ncobj = netcdf(filename, 'nowrite');
  dimName = 'Ordinal_Dates';
  dimVar = ncobj{dimName};
  Ordinal_Dates = dimVar (:);
end
[dummy, timeStep] = min(abs(Ordinal_Dates-CWRDate));



