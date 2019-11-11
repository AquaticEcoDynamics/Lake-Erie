function [matlabdate] = julian2matlab(julianDate);

% Converts a julian date (as used by DYRESM) to matlab date format
%
% USAGE
% 	[matlabdate] = CWRdate2matlab(julianDate);
%
% Uses:
%		CWRdate2date.m
%
% Chris Dallimore 9 Jan 07;

matlabdate=julianDate+datenum(-4713,1,1)+327.5000;

return;
