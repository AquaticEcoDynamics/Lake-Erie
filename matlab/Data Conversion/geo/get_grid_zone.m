function [grid_zone, lambda0] = get_grid_zoneJN (longitude, latitude);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
%
% vectorized by JN
%
% function [grid_zone, lambda0] = get_grid_zone (longitude, latitude);
%
% Given the lat/lon get UTM grid zone and baseline lambda0
%
% Inputs:
%   longitude, latitude : coordinates
%
% Outputs
%		grid_zone       : The UTM zone (2 dim vector)
%		lambda0         : baseline meridian
%
% pilfered from http://sbcx.mit.edu/saic_software.html and converted to matlab
%/*
% * Peter Daly
% * MIT Ocean Acoustics
% * pmd@mit.edu
% * 25-MAY-1998
% *
% Revisions:
%   Jan. 25, 1999 DHG  Port to Fortran 90
%   Mar. 23, 1999 DHG  To add Lewis Dozier's fix to "rr1" calculation
% *
% Description:
% *
% * These routines convert UTM to Lat/Longitude and vice-versa,
% * using the WGS-84 (GPS standard) or Clarke 1866 Datums.
% *
% * The formulae for these routines were originally taken from
% * Chapter 10 of "GPS: Theory and Practice," by B. Hofmann-Wellenhof,
% * H. Lictenegger, and J. Collins. (3rd ed) ISBN: 3-211-82591-6,
% * however, several errors were present in the text which
% * made their formulae incorrect.
% *
% * Instead, the formulae for these routines was taken from
% * "Map Projections: A Working Manual," by John P. Snyder
% * (US Geological Survey Professional Paper 1395)
% *
% * Copyright (C) 1998 Massachusetts Institute of Technology
% *               All Rights Reserved
% *
% * RCS ID: $Id: get_grid_zone.m,v 1.1.1.1 2006/12/07 03:26:02 dallimor Exp $
% */
%
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*



%  /* Solve for the grid zone, returns the central meridian */
  zone_long = fix((longitude + 180.0) / 6.0) + 1;
  zone_lat = round((latitude + 80.0) / 8.0);
  grid_zone(:,1) = zone_long;
  grid_zone(:,2) = zone_lat;


  
%  /* Handle the special "X" grid */
lambdaXX = 4.5 * pi / 180.0 * ones(length(longitude),1);
lambdaXXX = 15.0 * pi / 180.0* ones(length(longitude),1);
lambdaXXXX = 27.0 * pi / 180.0* ones(length(longitude),1);
lambdaXXXXX = 37.5 * pi / 180.0* ones(length(longitude),1);

xx = (latitude > 72.0 & latitude < 84.0 & longitude > 0.0 & longitude < 9);            % '& latitude < 84.0' is to avoid the polar regions
xxx = (latitude > 72.0 & latitude < 84.0 & longitude > 0.0 & longitude < 21)-xx;
xxxx = (latitude > 72.0 & latitude < 84.0 & longitude > 0.0 & longitude < 33) -xxx-xx;
xxxxx = (latitude > 72.0 & latitude < 84.0 & longitude > 0.0 & longitude < 42) -xxxx-xxx-xx;

lambdaX = xx.*lambdaXX + xxx.*lambdaXXX + xxxx.*lambdaXXXX + xxxxx.*lambdaXXXXX;



%  /* Handle the special "V" grid */
lambdaVV = 1.5 * pi / 180.0* ones(length(longitude),1);
lambdaVVV = 7.5 * pi / 180.0* ones(length(longitude),1);

vv = (latitude > 56.0 & latitude < 64.0 & longitude > 0.0 & longitude < 3);
vvv = (latitude > 56.0 & latitude < 64.0 & longitude > 0.0 & longitude < 12)-vv;

lambdaV = vv.*lambdaVV + vvv.*lambdaVVV;



 %  /* take care of the polar regions */
 lambdaPP = 1e-30 * pi / 180.0* ones(length(longitude),1);     % should be zero but for the sake of coding set to a very small number
 
 pp = (latitude <= -80.0) | (latitude >= 84.0);                % >= and <= have been used so in the very slight chance the values are exactly -80.0 and 84.0 they are treated as polar regions 
 
 lambdaP = pp.*lambdaPP;
 
 

 %  /* Create a vector of lambda0 when there are special conditions */
 lambda0 = lambdaX + lambdaV + lambdaP;
 
 
 
 %   /* Normally the grids follow the standard rule */  
 lambdaSS = (((zone_long - 1) * 6.0 + (-180.0) + 3.0)* pi / 180.0).* ones(length(longitude),1);
 
 ss = (lambda0 == 0);
 
 lambdaS = ss.*lambdaSS;
 
 
 %   /* So with everything considered */
 
 lambda0 = lambda0 + lambdaS;
 
 % QED :)

     





