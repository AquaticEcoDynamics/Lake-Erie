function installnetcdf

thismat = version;
yearmat = thismat(end-5:end-2);


if str2num(yearmat) == 2010
cur = '../function/netcdf/install/2010/';

addpath([cur '/mexcdf/mexnc']);
addpath([cur '/mexcdf/snctools']);
addpath ([cur,'/Loadnc']);
addpath ([cur,'/netcdfLink']);
addpath ([cur,'/netcdfLink/netcdf/']);
addpath ([cur,'/netcdfLink/netcdf/nctype']);
addpath ([cur,'/netcdfLink/netcdf/ncsource']);	
addpath ([cur,'/netcdfLink/netcdf/ncutility']);
javaaddpath([cur '/netcdfAll-4.1.jar']);
savepath

elseif str2num(yearmat) == 2012 || str2num(yearmat) == 2011
cur = '../function/netcdf/install/2011/';

addpath([cur '/mexcdf/mexnc']);
addpath([cur '/mexcdf/snctools']);
addpath ([cur,'/Loadnc']);
addpath ([cur,'/netcdfLink']);
addpath ([cur,'/netcdfLink/netcdf/']);
addpath ([cur,'/netcdfLink/netcdf/nctype']);
addpath ([cur,'/netcdfLink/netcdf/ncsource']);	
addpath ([cur,'/netcdfLink/netcdf/ncutility']);
javaaddpath([cur '/netcdfAll-4.2.jar']);
savepath
end

