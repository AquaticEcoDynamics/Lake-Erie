function [lambda0] = get_lambda0 (grid_zone)

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
%
% function [utm_x, utm_y] = ll2utm (longitude, latitude, grid_zone, datum)
%
% Given the UTM grid zone, generate a baseline lambda0
%
% Inputs:
%		grid_zone       : The UTM zone (Array of length 2)
%
% Outputs
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
% * RCS ID: $Id: get_lambda0.m,v 1.1.1.1 2006/12/07 03:26:02 dallimor Exp $
% */
%
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*

  %/* Given the grid zone,  set the central meridian, lambda0 */

  %/* Check the grid zone format */

  zone_long = grid_zone(1);
  zone_lat = grid_zone(2);
  if ((zone_long < 1) | (zone_long > 61))
    error (['Invalid grid zone format: ', num2str(zone_long), ' ',num2str(zone_lat)])
  end

  longitude =  ((zone_long - 1) * 6.0) - 180.0;
  latitude  =  ((zone_lat)      * 8.0) - 80.0;

  %/* Take care of special cases */

  if ((latitude < -80.0) | (latitude > 84.0))
    lambda0 = 0.0;
    return
  end

  if (latitude > 56.0 & latitude < 64.0 & ...
      longitude > 0.0 & longitude < 12.0)
     if (longitude < 3.0)
        lambda0 = 1.5 * pi / 180.0;
     elseif (longitude < 12)
        lambda0 = 7.5 * pi / 180.0;
     end
     return
  end

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

  %/* Now handle standard cases */

  lambda0 = ((zone_long - 1) * 6.0 + (-180.0) + 3.0) * pi / 180.0;

  %/* All done */

  return

