clear all; close all;

uwa = 'F:\Dropbox\Erie_Simulation_2020\tfv_008_AED_BIV\BCs\Met\Met_Zones.nc';

wind = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\Wind_utm_20131001_20151001.nc';

temp = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\Temperature_utm_20131001_20151001.nc';

relhum = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\RelHum_utm_20131001_20151001.nc';

rad = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\Radiation_utm_20130930_20150930.nc';


udata = tfv_readnetcdf(uwa,'names',{'lon';'lat'});
%bdata = tfv_readnetcdf(wind,'names',{'X';'Y'});

ind = 1;

for i = 1:length(udata.lon)
    for j = 1:length(udata.lat)
        uarray(ind,1) = udata.lon(i);
        uarray(ind,2) = udata.lat(j);
        uarray(ind,3) = i;
        uarray(ind,4) = j;
        ind = ind + 1;
    end
end
dtri = DelaunayTri(uarray(:,1),uarray(:,2));


dataw = tfv_readnetcdf(wind);

dataw.Date = datenum(1990,01,01) + dataw.time/24;


datat = tfv_readnetcdf(temp);

datat.Date = datenum(1990,01,01) + datat.time/24;

datar = tfv_readnetcdf(relhum);

datar.Date = datenum(1990,01,01) + datar.time/24;

datard = tfv_readnetcdf(rad);

datard.Date = datenum(1990,01,01) + datard.time/24;




%%__________________________________________________________________________
%%
%Wind U,V
%;'temp';'rhum';'dswr';'dlwr'
datauwa = tfv_readnetcdf(uwa,'names',{'u';'v'});

datauwa.Date = datenum(1990,01,01) + datauwa.time/24;

sss = find(datauwa.Date < dataw.Date(1));

newdata = [];
newdata2 = [];
ntime = [];
nU = [];
nV = [];
for i = 1:length(dataw.X)
    for j = 1:length(dataw.Y)
        query_points(:,1) = dataw.X(i);
        query_points(:,2) = dataw.Y(j);

        pt_id = nearestNeighbor(dtri,double(query_points));
        
        newdata(i,j,:) = datauwa.u(uarray(pt_id,3),uarray(pt_id,4),sss);
        newdata2(i,j,:) = datauwa.v(uarray(pt_id,3),uarray(pt_id,4),sss);
    end
end

ntime = [datauwa.Date(sss);dataw.Date];

nU = cat(3,newdata,double(dataw.u));
nV = cat(3,newdata2,double(dataw.v));

nettime = (ntime-datenum(1990,01,01))*24;


filename = 'Merged/Wind_utm_20131001_20151001.nc';

ncwrite(filename,'time',nettime);
ncwrite(filename,'u',nU);
ncwrite(filename,'v',nV);
clear dataw;
%__________________________________________________________________________
%%
%Temp temp
%;'temp';'rhum';'dswr';'dlwr'
datauwa = tfv_readnetcdf(uwa,'names',{'temp'});

datauwa.Date = datenum(1990,01,01) + datauwa.time/24;

sss = find(datauwa.Date < datat.Date(1));

newdata = [];
newdata2 = [];
ntime = [];
nU = [];
nV = [];
for i = 1:length(datat.X)
    for j = 1:length(datat.Y)
        query_points(:,1) = datat.X(i);
        query_points(:,2) = datat.Y(j);

        pt_id = nearestNeighbor(dtri,double(query_points));
        
        newdata(i,j,:) = datauwa.temp(uarray(pt_id,3),uarray(pt_id,4),sss);
        %newdata2(i,j,:) = datauwa.u(uarray(pt_id,3),uarray(pt_id,4),sss);
    end
end

ntime = [datauwa.Date(sss);datat.Date];

nU = cat(3,newdata,double(datat.temp));
%nV = cat(3,newdata2,double(dataw.v));

nettime = (ntime-datenum(1990,01,01))*24;


filename = 'Merged/Temperature_utm_20131001_20151001.nc';

ncwrite(filename,'time',nettime);
ncwrite(filename,'temp',nU);
%ncwrite(filename,'v',nV);
clear datat

%__________________________________________________________________________
%%
%RHUM rhum
%;'temp';'rhum';'dswr';'dlwr'
datauwa = tfv_readnetcdf(uwa,'names',{'rhum'});

datauwa.Date = datenum(1990,01,01) + datauwa.time/24;

sss = find(datauwa.Date < datar.Date(1));

newdata = [];
newdata2 = [];
ntime = [];
nU = [];
nV = [];
for i = 1:length(datar.X)
    for j = 1:length(datar.Y)
        query_points(:,1) = datar.X(i);
        query_points(:,2) = datar.Y(j);

        pt_id = nearestNeighbor(dtri,double(query_points));
        
        newdata(i,j,:) = datauwa.rhum(uarray(pt_id,3),uarray(pt_id,4),sss);
        %newdata2(i,j,:) = datauwa.u(uarray(pt_id,3),uarray(pt_id,4),sss);
    end
end

ntime = [datauwa.Date(sss);datar.Date];

nU = cat(3,newdata,double(datar.rhum));
%nV = cat(3,newdata2,double(dataw.v));

nettime = (ntime-datenum(1990,01,01))*24;


filename = 'Merged/RelHum_utm_20131001_20151001.nc';

ncwrite(filename,'time',nettime);
ncwrite(filename,'rhum',nU);
%ncwrite(filename,'v',nV);
clear datar

%%__________________________________________________________________________
%%
%Solar dswr,dlwr
%;'temp';'rhum';'dswr';'dlwr'
datauwa = tfv_readnetcdf(uwa,'names',{'dswr';'dlwr'});

datauwa.Date = datenum(1990,01,01) + datauwa.time/24;

sss = find(datauwa.Date < datard.Date(1));

newdata = [];
newdata2 = [];
ntime = [];
nU = [];
nV = [];
for i = 1:length(datard.X)
    for j = 1:length(datard.Y)
        query_points(:,1) = datard.X(i);
        query_points(:,2) = datard.Y(j);

        pt_id = nearestNeighbor(dtri,double(query_points));
        
        newdata(i,j,:) = datauwa.dswr(uarray(pt_id,3),uarray(pt_id,4),sss);
        newdata2(i,j,:) = datauwa.dlwr(uarray(pt_id,3),uarray(pt_id,4),sss);
    end
end

ntime = [datauwa.Date(sss);datard.Date];

nU = cat(3,newdata,double(datard.dswr));
nV = cat(3,newdata2,double(datard.dlwr));

nettime = (ntime-datenum(1990,01,01))*24;


filename = 'Merged/Radiation_utm_20130930_20150930.nc';

ncwrite(filename,'time',nettime);
ncwrite(filename,'dswr',nU);
ncwrite(filename,'dlwr',nV);
clear datard;