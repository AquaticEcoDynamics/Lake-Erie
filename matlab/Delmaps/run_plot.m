clear all; close all;


ncfile1 = 'F:/Output.n/erie_AED.nc';
ncfile2 = 'F:/Output.n/erie_AED.nc';

var = 'WQ_NCS_SS1';

start_timeave = datenum(2013,05,08);
end_timeave = datenum(2013,05,20);

titletxt = 'My variable name (units)';

del_caxis = [-1 1];
del_clip = [-0.1 0.1];

outname = 'theplot.png';

erie_delmap_v2(ncfile1,ncfile2,var,titletxt,del_caxis,del_clip,start_timeave,end_timeave,outname);

del_caxis = [-2 2];
del_clip = [-0.1 0.1];

outname = 'theplot2.png';
erie_delmap_v2(ncfile1,ncfile2,var,titletxt,del_caxis,del_clip,start_timeave,end_timeave,outname);
