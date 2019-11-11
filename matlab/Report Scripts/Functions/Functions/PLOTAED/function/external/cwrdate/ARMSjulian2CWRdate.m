function [CWRDate] = ARMSjulian2CWRdate(armsJulian);

% Converts an ARMS Julian object to a CWR date format
%
% USAGE
% 	[CWRDate] = ARMSjulian2CWRdate(armsJulian);
%
% Uses:
%		arms.jar and java.lang.String these should be in class path already
%
% Chris Dallimore 5 March 05;

CWR_FORMAT = 1122;
dateStr = armsJulian.getDateString(CWR_FORMAT);
CWRDate = str2num(dateStr);

