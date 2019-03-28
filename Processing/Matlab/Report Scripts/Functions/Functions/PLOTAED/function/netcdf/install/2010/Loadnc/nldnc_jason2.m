function [data] = nldnc(filename,namelist)

netcdf_object=netcdf(filename,'nowrite');
variables=var(netcdf_object);
vnamesfull=names_netcdf(filename);

if ~exist('namelist') | isempty(namelist);
  vnames = vnamesfull;
else
  if iscell(namelist)
    lengthTmp =11;

    tmp_vnames = cell(lengthTmp ,1);
    tmp_vnames{1} = 'X';
    tmp_vnames{2} = 'Y';
    tmp_vnames{3} = 'Z';
    tmp_vnames{4} = 'S';
    tmp_vnames{5} = 'Ordinal_Dates';
    tmp_vnames{6} = 'T';
    tmp_vnames{7} = 'FreeSurfHeights';
    tmp_vnames{8} = 'DX';
    tmp_vnames{9} = 'DY';
    tmp_vnames{10} = 'Iway_pts';
    tmp_vnames{11} = 'Jway_pts';

    vnames = cell(lengthTmp+length(namelist) ,1);

    for i = 1:lengthTmp
      vnames{i} = tmp_vnames{i};
    end

    for i = 1:length(namelist)
      vnames{i+lengthTmp} = namelist{i};
    end
  else
    vnames = {'X'; 'Y';'Z';'S';'T';'Ordinal_Dates';'FreeSurfHeights';'DX';'DY'; 'Iway_pts'; 'Jway_pts';namelist};
  end
end
startTime = netcdf_object{'time'}.units(end-17:end);
data.mTime = datenum(startTime);


for ii = 1:length(vnames)
  found=strmatch(vnames(ii),vnamesfull,'exact');
  if ~isempty(found)
    %disp(['loading ',char(vnames(ii))]);
    cmd = sprintf('data.%s = variables{found} (:);',char(vnames(ii)));
    eval(cmd)
    cmd = sprintf('find(data.%s < -9.9e+16); data.%s(ans)=NaN;',char(vnames(ii)),char(vnames(ii)));
    eval(cmd)
  else
  found=strmatch(vnames(ii),namelist,'exact');
  if ~isempty(found)
    disp(['Error loading ',char(vnames(ii)),' Variable not in file']);
  end
  end
end
netcdf_object = close(netcdf_object);
clear netcdf_obj variables
