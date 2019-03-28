function [decday] = hour2decjd(hour);

% USAGE:
% 	[decday] = hour2decjd(hour);
%
% Converts a four digit number (24h time)
% to a decimal day.
%
% Jason Antenucci 18/7/99

hr=floor(hour./100);

decday=hr./24 + (hour-100*hr)./1440;

return
