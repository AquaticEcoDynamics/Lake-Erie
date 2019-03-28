function [grid_zone, lambda0] = get_grid_zone (longitude, latitude);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
%
% function [grid_zone, lambda0] = get_grid_zone (longitude, latitude);
%
% Given the lat/lon get UTM grid zone and baseline lambda0
%
% Inputs:
%   longitude, latitude : coordinates
%
% Outputs
%		grid_zone       : The UTM zone (Array of length 2)
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
  zone_lat = round ((latitude + 80.0) / 8.0);
  grid_zone(1) = zone_long;
  grid_zone(2) = zone_lat;

%  /* First, let's take care of the polar regions */

  if ((latitude < -80.0) | (latitude > 84.0))
     lambda0 = 0.0 * pi / 180.0;
     return
  end

%  /* Now the special "X" grid */

  if (latitude > 72.0 & ...
      longitude > 0.0 & longitude < 42.0)
     if (longitude < 9.0)
        lambda0 = 4.5 * pi / 180.0;
     elseif (longitude < 21.0)
        lambda0 = 15.0 * pi / 180.0;
     elseif (longitude < 33.0)
        lambda0 = 27.0 * pi / 180.0;
     elseif (longitude < 42.0)
        lambda0 = 37.5 * pi / 180.0;
     end
     return
  end

%  /* Handle the special "V" grid */

  if (latitude > 56.0 & latitude < 64.0 & ...
      longitude > 0.0 & longitude < 12.0)
     if (longitude < 3.0)
        lambda0 = 1.5 * pi / 180.0;
     elseif (longitude < 12.0)
        lambda0 = 7.5 * pi / 180.0;
     end
     return
  end

%  /* The remainder of the grids follow the standard rule */

  lambda0 = ((zone_long - 1) * 6.0 + (-180.0) + 3.0) * pi / 180.0;

  return


