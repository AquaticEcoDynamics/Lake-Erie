clear all; close all;


%wind = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\Wind_utm_20131001_20151001.nc';

wind = 'E:\Github 2018\Lake-Erie-2019\matlab\merge_netcdf\Merged\Wind_utm_20131001_20151001.nc';

%temp = 'E:\Github 2018\Lake-Erie-2019\models\TFV-AED\tfv_007_AED_BIV\BCs\Met\Temperature_utm_20131001_20151001.nc';
temp = 'E:\Github 2018\Lake-Erie-2019\matlab\merge_netcdf\Merged\Temperature_utm_20131001_20151001.nc';

relhum = 'E:\Github 2018\Lake-Erie-2019\matlab\merge_netcdf\Merged\RelHum_utm_20131001_20151001.nc';

rad = 'E:\Github 2018\Lake-Erie-2019\matlab\merge_netcdf\Merged\Radiation_utm_20130930_20150930.nc';

dataw = tfv_readnetcdf(wind);

dataw.Date = datenum(1990,01,01) + dataw.time/24;

dataw.Speed = sqrt(power(dataw.u,2) + power(dataw.v,2));

datat = tfv_readnetcdf(temp);

datat.Date = datenum(1990,01,01) + datat.time/24;

datar = tfv_readnetcdf(relhum);

datar.Date = datenum(1990,01,01) + datar.time/24;

datard = tfv_readnetcdf(rad);

datard.Date = datenum(1990,01,01) + datard.time/24;

figure

subplot(2,3,1)

plot(dataw.Date,squeeze(dataw.Speed(1,1,:)));
datearray = [min(dataw.Date):(max(dataw.Date) - min(dataw.Date))/5:max(dataw.Date)];
xlim([datearray(1) datearray(end)]);
            
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
title('Wind Speed');
subplot(2,3,2)

plot(datat.Date,squeeze(datat.temp(1,1,:)));
datearray = [min(datat.Date):(max(datat.Date) - min(datat.Date))/5:max(datat.Date)];
xlim([datearray(1) datearray(end)]);
            
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
title('Temperature');

subplot(2,3,3)

plot(datar.Date,squeeze(datar.rhum(1,1,:)));
datearray = [min(datar.Date):(max(datar.Date) - min(datar.Date))/5:max(datar.Date)];
xlim([datearray(1) datearray(end)]);
            
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
title('rhum');

subplot(2,3,4)

plot(datard.Date,squeeze(datard.dswr(1,1,:)));
datearray = [min(datard.Date):(max(datard.Date) - min(datard.Date))/5:max(datard.Date)];
xlim([datearray(1) datearray(end)]);
            
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
title('dswr');

subplot(2,3,5)

plot(datard.Date,squeeze(datard.dlwr(1,1,:)));
datearray = [min(datard.Date):(max(datard.Date) - min(datard.Date))/5:max(datard.Date)];
xlim([datearray(1) datearray(end)]);
            
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
title('dlwr');