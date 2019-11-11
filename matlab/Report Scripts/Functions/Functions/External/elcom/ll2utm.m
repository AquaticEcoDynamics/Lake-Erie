function [utm_x, utm_y, grid_zone] = ll2utm (longitude, latitude, datum)

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
%
% function [utm_x, utm_y, grid_zone] = ll2utm (longitude, latitude , datum)
%
% Given the lat/lon get UTM
%
% Inputs:
%   longitude, latitude : coordinates
%   datum(optional) :   CLARKE_1866_DATUM = 1;
%                       GRS_80_DATUM = 2;
%                       WGS_84_DATUM = 3 (Default);
%
% Outputs
%		utm_x, utm_y    : UTM coordinates (Eastings and Northings)
%		grid_zone       : The UTM zone (Array of length 2)
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
% * RCS ID: $Id: ll2utm.m,v 1.1.1.1 2006/12/07 03:26:02 dallimor Exp $
% */
%
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*

  CLARKE_1866_DATUM = 1;
  GRS_80_DATUM = 2;
  WGS_84_DATUM = 3;

  if nargin < 4
    datum = WGS_84_DATUM;
  end

  %/* Converts lat/long to UTM, using the specified datum */

  if (datum == CLARKE_1866_DATUM)       ! CLARKE_1866_DATUM:
    a = 6378206.4;
    b = 6356583.8;
  elseif (datum == GRS_80_DATUM)       ! GRS_80_DATUM:
    a = 6378137;
    b = 6356752.3;
  elseif (datum == WGS_84_DATUM)       ! WGS_84_DATUM:
    a = 6378137.0;           %/* semimajor axis of ellipsoid (meters) */
    b = 6356752.31425;       %/* semiminor axis of ellipsoid (meters) */
  else
    error (['Unknown datum: ', num2str(datum)])
    return
  end

  %/* Calculate flatness and eccentricity */

  f = 1 - (b / a);
  e2 = 2 * f - f * f;
  e = sqrt (e2);
  e4 = e2 * e2;
  e6 = e4 * e2;

  %/* Convert latitude/longitude to radians */

  phi = latitude * pi / 180.0;
  lambda = longitude * pi / 180.0;

  %/* Figure out the UTM zone, as well as lambda0 */

  [grid_zone, lambda0] =  get_grid_zone (longitude, latitude);
  phi0 = 0.0;

  %/* See if this will use UTM or UPS */

  if (latitude > 84.0)

    %/* use Universal Polar Stereographic Projection (north polar aspect) */

    k0 = 0.994;

    t = sqrt ( ((1 - sin (phi)) / (1 + sin (phi))) * ...
         (((1 + e * sin (phi)) / (1 - e * sin (phi))) ^ e) );
    rho = 2.0 * a * k0 * t / sqrt ( ((1.0 + e) ^ (1.0 + e)) * ((1.0 - e) ^ (1.0 - e)) );

    x = rho * sin (lambda - lambda0);
    y = -rho * cos (lambda - lambda0);

    %/* Apply false easting/northing */

    x = x + 2000000.0;
    y = y + 2000000.0;

  elseif (latitude < -80.0)

    %/* use Universal Polar Stereographic Projection (south polar aspect) */

    phi = -phi;
    lambda = -lambda;
    lambda0 = -lambda0;

    k0 = 0.994;

    t = sqrt (((1.0 - sin (phi)) / (1.0 + sin (phi))) * ...
       ( ( (1.0 + e * sin (phi)) / (1.0 - e * sin (phi)) ^ e) ) );
    rho = 2.0 * a * k0 * t / sqrt ( ((1+e) ^ (1+e)) * ((1-e) ^ (1-e)) );

    x = rho * sin (lambda - lambda0);
    y = -rho * cos (lambda - lambda0);

    x = -x;
    y = -y;

    %/* Apply false easting/northing */

    x = x + 2000000.0;
    y = y + 2000000.0;

  else

    %/* Use UTM */

    %/* set scale on central median (0.9996 for UTM) */

    k0 = 0.9996;

    mm = a * ((1.0-e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0) * phi - ...
        (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0) * sin (2.0*phi) + ...
        (15.0*e4/256.0 + 45.0*e6/1024.0) * sin (4.0*phi) - ...
        (35.0*e6/3072.0) * sin (6.0*phi));

    mm0 = a * ((1.0-e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0) * phi0 - ...
         (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0) * sin (2.0*phi0) + ...
         (15.0*e4/256.0 + 45.0*e6/1024.0) * sin (4.0*phi0) - ...
         (35.0*e6/3072.0) * sin (6.0*phi0));

    aa = (lambda - lambda0) * cos(phi);
    aa2 = aa * aa;
    aa3 = aa2 * aa;
    aa4 = aa2 * aa2;
    aa5 = aa4 * aa;
    aa6 = aa3 * aa3;

    ep2 = e2 / (1.0 - e2);
    nn = a / sqrt (1.0 - e2 * sin (phi) * sin (phi));
    tt = tan (phi) * tan (phi);
    cc = ep2 * cos (phi) * cos (phi);

    x = k0 * nn * (aa + (1-tt+cc) * aa3 / 6 + ...
            (5-18*tt+tt*tt+72*cc-58*ep2) * aa5 / 120.0);
    y = k0 * (mm - mm0 + nn * tan (phi) * ...
             (aa2 / 2 + (5-tt+9*cc+4*cc*cc) * aa4 / 24.0 + ...
       (61 - 58*tt + tt*tt + 600*cc - 330*ep2) * aa6 / 720));

    %/* Apply false easting and northing */

    x = x + 500000.0;
    if (y < 0.0)
       y = y + 10000000.0;
    end
  end

  %/* Set entries in UTM structure */

  utm_x = x;
  utm_y = y;

  %/* done */

  return

