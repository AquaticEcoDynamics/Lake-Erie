function [date_str,time_str] = CWRdate2string(CWRDate);

% Converts CWR date format to strings
%
% USAGE
% 	[date_str,time_str] = CWRdate2string(CWRDate);
%
% Uses:
%		CWRdate2date.m
%
% Chris Dallimore 27 July 04;

matlabDate = CWRdate2matlab(CWRDate);
date_str = datestr(matlabDate,1);
time_str = datestr(matlabDate,15);

return;
