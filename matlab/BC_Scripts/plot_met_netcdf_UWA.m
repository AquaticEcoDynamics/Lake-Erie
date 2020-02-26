clear all; close all;


wind = 'F:\Dropbox\Erie_Simulation_2020\tfv_008_AED_BIV\BCs\Met\Met_Zones.nc';

temp = 'F:\Dropbox\Erie_Simulation_2020\tfv_008_AED_BIV\BCs\Met\Met_Zones.nc';

relhum = 'F:\Dropbox\Erie_Simulation_2020\tfv_008_AED_BIV\BCs\Met\Met_Zones.nc';

rad = 'F:\Dropbox\Erie_Simulation_2020\tfv_008_AED_BIV\BCs\Met\Met_Zones.nc';

dataw = tfv_readnetcdf(wind,'names',{'u';'v'});

dataw.Date = datenum(1990,01,01) + dataw.time/24;

dataw.Speed = sqrt(power(dataw.u,2) + power(dataw.v,2));


datat = tfv_readnetcdf(temp,'names',{'temp'});

datat.Date = datenum(1990,01,01) + datat.time/24;

datar = tfv_readnetcdf(relhum,'names',{'rhum'});

datar.Date = datenum(1990,01,01) + datar.time/24;

datard = tfv_readnetcdf(rad,'names',{'dswr';'dlwr'});

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