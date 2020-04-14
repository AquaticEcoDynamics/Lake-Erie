function [u, v] = bearing2cart(r,th);

% USAGE:
%	[u, v] = bearing2cart(r,th)
%
% Converts something in a 'bearing' system
% to being in a Cartesian system, for want 
% of a better description
%
% Jason Antenucci 15/4/99

th=450-th;

% convert th to radians
th = th * pi/180;

[u,v] = pol2cart(th,r);

return