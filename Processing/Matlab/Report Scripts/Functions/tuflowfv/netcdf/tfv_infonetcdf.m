function [varnames,dimnames,data] = tfv_infonetcdf(filename);
% Simple function to get all variable names from a Tuflow netcdf file
data = [];
ncid = netcdf.open(filename,'NC_NOWRITE');
[ndims,nvars,~,unlimdimid] = netcdf.inq(ncid);
dimids = (0:ndims-1)';
dimnames = cell(ndims,1);
dimlen = zeros(1,ndims);
for i = 1 : ndims
    [dimnames{i},dimlen(i)] = netcdf.inqDim(ncid,dimids(i));
end
varid = (0:nvars-1)';
varnames = cell(nvars,1);
xtype = zeros(nvars,1);
vardimids = cell(nvars,1);
varunlimdim = cell(nvars,1);
for i = 1 : nvars
    [varnames{i},xtype(i),vardimids{i}] = netcdf.inqVar(ncid,varid(i));
    varunlimdim{i} = find(vardimids{i}==unlimdimid,1,'first');
end

