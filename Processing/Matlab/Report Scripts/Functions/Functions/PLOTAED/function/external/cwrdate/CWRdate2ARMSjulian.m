function [armsJulian] = CWRdate2ARMSjulian(CWRDate);

% Converts CWR date format to an ARMS Julian object
%
% USAGE
% 	[armsJulian] = CWRdate2ARMSjulian(CWRDate);
%
% Uses:
%		arms.jar and java.lang.String these should be in class path already
%
% Chris Dallimore 5 March 05;

CWR_FORMAT = 1122;
dateStrObj = javaObject('java.lang.String', num2str(CWRDate));
armsJulian = cwr.arms.datatypes.Julian(dateStrObj,CWR_FORMAT);
