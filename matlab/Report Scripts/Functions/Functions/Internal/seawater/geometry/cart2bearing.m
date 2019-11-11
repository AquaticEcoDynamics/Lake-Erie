function [r, th] = cart2bearing(u,v);

% USAGE:
%	[r, bearing] = cart2bearing(u,v);
%
% Converts something in a Cartesian system
% to being in a 'bearing' system, for want
% of a better description
%
% Jason Antenucci 12/2/99

[th,r]=cart2pol(u,v);

% convert th to degrees
th = th * 180/pi;

% convert -ve th to +ve
th(find(th<0))=th(find(th<0))+360;

% convert to bearing
th=450-th;

% take care of values >= 360
th(find(th>=360))=th(find(th>=360))-360;

return