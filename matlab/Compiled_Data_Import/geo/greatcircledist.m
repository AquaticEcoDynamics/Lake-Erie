function rng = greatcircledist(lon1,lat1,lon2,lat2,r,deg)

deg_to_rad = pi / 180.;
if deg
    lon1 = lon1 * deg_to_rad;
    lat1 = lat1 * deg_to_rad;
    lon2 = lon2 * deg_to_rad;
    lat2 = lat2 * deg_to_rad;
end

a = sin((lat2-lat1)/2.).^2 + cos(lat1) .* cos(lat2) .* sin((lon2-lon1)/2.).^2;
rng = r .* 2.*atan2(sqrt(a),sqrt(1.-a));