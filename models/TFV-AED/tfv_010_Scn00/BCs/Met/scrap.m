data = tfv_readnetcdf('Radiation_utm_20130507_20150930.nc');

stime = datenum('01/01/1990 00:00','dd/mm/yyyy HH:MM');
data.mtime = stime + (data.time/24);

dswr = squeeze(data.dswr(10,9,:));

plot(data.mtime(1:200),dswr(1:200)); datetick('x');