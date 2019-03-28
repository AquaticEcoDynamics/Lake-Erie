function [longitude, latitude] = utm2ll (utm_x, utm_y, grid_zone, datum)

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
%
% function [longitude, latitude] = utm2ll (utm_x, utm_y, grid_zone, datum)
%
% Inputs:
%		utm_x, utm_y    : UTM coordinates (Eastings and Northings)
%		grid_zone       : The UTM zone (Array of length 2)
%   datum(optional) :   CLARKE_1866_DATUM = 1;
%                       GRS_80_DATUM = 2;
%                       WGS_84_DATUM = 3 (Default);
%
%
% Outputs
%   longitude, latitude  : Handle to graphic object
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
% * RCS ID: $Id: utm2ll.m,v 1.2 2007/01/10 05:55:34 dallimor Exp $
% */
%
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*

  CLARKE_1866_DATUM = 1;
  GRS_80_DATUM = 2;
  WGS_84_DATUM = 3;
  LOWER_EPS_LIMIT = 1.0e-14;

  if nargin < 4
    datum = WGS_84_DATUM;
  end

  %/* Converts UTM to lat/long, using the specified datum */

  if (datum == CLARKE_1866_DATUM)
    a = 6378206.4;
    b = 6356583.8;
  elseif (datum == GRS_80_DATUM)
    a = 6378137;
    b = 6356752.3;
  elseif (datum == WGS_84_DATUM)
    a = 6378137.0;             %/* semimajor axis of ellipsoid (meters) */
    b = 6356752.31425;         %/* semiminor axis of ellipsoid (meters) */
  else
    error (['Unknown datum: ', num2str(datum)])
    return
  end

  %/* Calculate flatness and eccentricity */

  f = 1.0 - (b / a);
  e2 = (2.0 * f) - (f * f);
  e = sqrt (e2);
  e4 = e2 * e2;
  e6 = e4 * e2;
  e8 = e4 * e4;

  %/* Given the UTM grid zone, generate a baseline lambda0 */

  lambda0 =  get_lambda0 (grid_zone);

  latitude = ((grid_zone(2)) * 8.0) - 80.0;

  %/* Take care of the polar regions first. */

  if (latitude > 84.0)  %/* north polar aspect */

    %/* Subtract the false easting/northing */

    x = utm_x - 2000000.0;
    y = utm_y - 2000000.0;

    %/* Solve for inverse equations */

    k0 = 0.994;
    rho = sqrt (x*x + y*y);
    t = rho * sqrt ( ((1+e) ^ (1+e)) * ((1-e) ^ (1-e)) ) / (2*a*k0);

    %/* Solve for latitude and longitude */

    chi = pi*2 - 2 * atan (t);
    phit = chi + (e2/2 + 5*e4/24 + e6/12 + 13*e8/360) * sin(2*chi) + ...
                 (7*e4/48 + 29*e6/240 + 811*e8/11520) * sin(4*chi) + ...
                 (7*e6/120 + 81*e8/1120) * sin(6*chi) + ...
                 (4279*e8/161280) * sin(8*chi);

    phi = phit+10*LOWER_EPS_LIMIT;
    while (abs (phi-phit) > LOWER_EPS_LIMIT)
      phi = phit;
      phit = 2*pi - 2 * atan ( t * (((1 - e * sin (phi)) / (1 + e * sin (phi))) ^ (e / 2)) );
    end

    lambda = lambda0 + atan2 (x, -y);

  elseif (latitude < -80.0)  %/* south polar aspect */

    %/* Subtract the false easting/northing */

    x = -(utm_x - 2000000);
    y = -(utm_y - 2000000);

    %/* Solve for inverse equations */

    k0 = 0.994;
    rho = sqrt (x*x + y*y);
    t = rho * sqrt ( ((1+e) ^ (1+e)) * ((1-e) ^ (1-e)) ) / (2*a*k0);

    %/* Solve for latitude and longitude */

    chi = 2*pi - 2 * atan (t);
    phit = chi + (e2/2 + 5*e4/24 + e6/12 + 13*e8/360) * sin (2*chi) + ...
           (7*e4/48 + 29*e6/240 + 811*e8/11520) * sin (4*chi) + ...
           (7*e6/120 + 81*e8/1120) * sin (6*chi) + ...
           (4279*e8/161280) * sin (8*chi);

    phi = phit+10*LOWER_EPS_LIMIT;
    while (abs (phi-phit) > LOWER_EPS_LIMIT)
      phi = phit;
      phit = 2*pi - 2 * atan (t * ( ((1-e*sin(phi)) / (1+e*sin(phi)) ) ^ (e/2)));
    end

    phi = -phi;
    lambda = -(-lambda0 + atan2 (x , -y));

  else

    %/* Now take care of the UTM locations */

    k0 = 0.9996;

    %/* Remove false eastings/northings */

    x = utm_x - 500000.0;
    y = utm_y;

    if (latitude < 0.0)   %/* southern hemisphere */
      y = y - 10000000.0;
    end

    %/* Calculate the footpoint latitude */

    phi0 = 0.0;
    e1 = (1.0 - sqrt (1.0-e2)) / (1.0 + sqrt (1.0-e2));
    e12 = e1 * e1;
    e13 = e1 * e12;
    e14 = e12 * e12;

    mm0 = a * ((1.0-e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0) * phi0 - ...
         (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0) * sin (2.0*phi0) + ...
         (15.0*e4/256.0 + 45.0*e6/1024.0) * sin (4.0*phi0) - ...
         (35.0*e6/3072.0) * sin (6.0*phi0));
    mm = mm0 + y/k0;
    mu = mm / (a * (1.0-e2/4.0-3.0*e4/64.0-5.0*e6/256.0));

    phi1 = mu + (3.0*e1/2.0 - 27.0*e13/32.0) * sin (2.0*mu) + ...
           (21.0*e12/16.0 - 55.0*e14/32.0) * sin (4.0*mu) + ...
           (151.0*e13/96.0) * sin (6.0*mu) + ...
           (1097.0*e14/512.0) * sin (8.0*mu);

    %/* Now calculate lambda and phi */

    ep2 = e2 / (1.0 - e2);
    cc1 = ep2 * cos (phi1) * cos (phi1);
    tt1 = tan (phi1) * tan (phi1);
    nn1 = a / sqrt (1.0 - e2 * sin (phi1) * sin (phi1));
    rr1 = a * (1.0 - e2) / ((1.0 - e2 * sin (phi1) * sin (phi1)) ^ 1.5);
    dd = x / (nn1 * k0);

    dd2 = dd * dd;
    dd3 = dd * dd2;
    dd4 = dd2 * dd2;
    dd5 = dd3 * dd2;
    dd6 = dd4 * dd2;

    phi = phi1 - (nn1 * tan (phi1) / rr1) * ...
          (dd2/2.0 - (5.0+3.0*tt1+10.0*cc1-4.0*cc1*cc1-9.0*ep2) * dd4 / 24.0 + ...
          (61.0+90.0*tt1+298.0*cc1+45.0*tt1*tt1-252.0*ep2-3.0*cc1*cc1) * dd6 / 720.0);
    lambda = lambda0 + ...
             (dd - (1.0+2.0*tt1+cc1) * dd3 / 6.0 + ...
             (5.0-2.0*cc1+28.0*tt1-3.0*cc1*cc1+8.0*ep2+24.0*tt1*tt1) * dd5 / 120.0) / cos (phi1);
  end

  %/* Convert phi/lambda to degrees */

  latitude = phi * 180.0 / pi;
  longitude = lambda * 180.0 / pi;

  %/* All done */

  return

