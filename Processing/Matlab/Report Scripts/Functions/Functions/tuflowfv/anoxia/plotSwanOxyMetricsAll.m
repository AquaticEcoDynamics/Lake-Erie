%calcSwanOxyMetricsAll(simfile,curtainfile)
% function [oxy_metrics] = calcSwanOxyMetrics(simfile,curtainfile)
%
% Inputs:
%		simfile   : filename of TUFLOW_FV netcdf simulation file
%       curtainfile  : filename of text file containing x,y points for the
%       thalwig location
%  
% Outputs
%		oxy_metrics   : contains time series and bulk normalised parameters
%		used to decribe metrics to measure efficiency of oxygenation plants
%		in the Swan river at Guildford and Caversham
%
% Uses
%       tfv_readnetcdf
%
%
% Written by L. Bruce 12 February 2013 specifically for Swan River data

oxy0 = load('../Output/swan_v19_FABMv2_2010_Oxy0_oxy_metrics.mat');
oxy0 = oxy0.oxy_metrics;
oxy1 = load('../Output/swan_v20_FABMv2_2010_Oxy1_oxy_metrics.mat');
oxy1 = oxy1.oxy_metrics;
oxy6 = load('Output/swan_Oxy6_oxy_metrics.mat');
oxy6 = oxy6.oxy_metrics;
oxy7 = load('Output/swan_Oxy7_oxy_metrics.mat');
oxy7 = oxy7.oxy_metrics;
oxy8 = load('Output/swan_Oxy8_oxy_metrics.mat');
oxy8 = oxy8.oxy_metrics;
oxy9 = load('Output/swan_Oxy9_oxy_metrics.mat');
oxy9 = oxy9.oxy_metrics;


%Plot tracer extent
figure
plot(oxy1.sim_time,smooth(oxy1.L_trace5_range/1000,24),'b', ...
    oxy6.sim_time,smooth(oxy6.L_trace5_range/1000,24),'g', ...
    oxy7.sim_time,smooth(oxy7.L_trace5_range/1000,24),'c', ...
    oxy9.sim_time,smooth(oxy9.L_trace5_range/1000,24),'m')
hold on
%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 50])
xlim([oxy1.sim_time(1) datenum('01-Jan-2011')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
%legend('Oxy Off','Guild & Cav base','Economic','Tidal Optim','High Flow - Oxy Off','High Flow - Guild & Cav Base','Location','NorthOutside')
legend('Oxy 1','Oxy6','Oxy7','Oxy9')
ylabel('Maximum Range of Influence (km)')
hold off
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_tracer_range.png'],'-opengl');
        
%Plot oxygen % for full domain
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_DO2,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_DO2,24),'b', ...
    oxy6.sim_time,smooth(oxy6.Apc_DO2,24),'g', ...
    oxy7.sim_time,smooth(oxy7.Apc_DO2,24),'c', ...
    oxy8.sim_time,smooth(oxy8.Apc_DO2,24),'r', ...
    oxy9.sim_time,smooth(oxy9.Apc_DO2,24),'m')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([oxy1.sim_time(1) datenum('01-Jan-2011')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy6','Oxy7','Oxy8','Oxy9')
ylabel('Percent Anoxia')
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_fulldomain_anox.png'],'-opengl');
        
%Plot Hypoxia
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_DO4,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_DO4,24),'b', ...
    oxy6.sim_time,smooth(oxy6.Apc_DO4,24),'g', ...
    oxy7.sim_time,smooth(oxy7.Apc_DO4,24),'c', ...
    oxy8.sim_time,smooth(oxy8.Apc_DO4,24),'r', ...
    oxy9.sim_time,smooth(oxy9.Apc_DO4,24),'m')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([oxy1.sim_time(1) datenum('01-Jan-2011')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy6','Oxy7','Oxy8','Oxy9')
ylabel('Percent Hypoxia')
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_fulldomain_hypox.png'],'-opengl');


%Plot oxygen % for oxy plant region - Anoxia
%First 6 months
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_oxy_DO2,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_oxy_DO2,24),'b', ...
    oxy6.sim_time,smooth(oxy6.Apc_oxy_DO2,24),'g', ...
    oxy7.sim_time,smooth(oxy7.Apc_oxy_DO2,24),'c')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([oxy1.sim_time(1) datenum('01-Jul-2010')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy6','Oxy7')
ylabel('Percent Anoxia')
hold off
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_oxydomain_anox_JanJul.png'],'-opengl');
        
%Second 6 months
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_oxy_DO2,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_oxy_DO2,24),'b', ...
    oxy8.sim_time,smooth(oxy8.Apc_oxy_DO2,24),'r', ...
    oxy9.sim_time,smooth(oxy9.Apc_oxy_DO2,24),'m')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([datenum('01-Jul-2010') datenum('01-Jan-2011')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy8','Oxy9')
ylabel('Percent Anoxia')
hold off
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_oxydomain_anox_JulDec.png'],'-opengl');
        
%Plot oxygen % for oxy plant region - Anoxia
%First 6 months
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_oxy_DO4,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_oxy_DO4,24),'b', ...
    oxy6.sim_time,smooth(oxy6.Apc_oxy_DO4,24),'g', ...
    oxy7.sim_time,smooth(oxy7.Apc_oxy_DO4,24),'c')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([oxy1.sim_time(1) datenum('01-Jul-2010')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy6','Oxy7')
ylabel('Percent Hypoxia')
hold off
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_oxydomain_hypox_JanJul.png'],'-opengl');
        
%Second 6 months
figure
plot(oxy0.sim_time,smooth(oxy0.Apc_oxy_DO4,24),'k', ...
    oxy1.sim_time,smooth(oxy1.Apc_oxy_DO4,24),'b', ...
    oxy8.sim_time,smooth(oxy8.Apc_oxy_DO4,24),'r', ...
    oxy9.sim_time,smooth(oxy9.Apc_oxy_DO4,24),'m')
hold on

%Plot black line on when oxyplant is on
plot([oxy1.sim_time(1) datenum('1-June-2010') datenum('1-June-2010') ...
    datenum('1-Sep-2010') datenum('1-Sep-2010') datenum('1-Jan-2011')], ...
                                     [43 43 0 0 43 43],'k','LineWidth',3)
set(gca,'FontSize',12)
%Set xaxis (time) limits and tick marks
ylim([0 100])
xlim([datenum('01-Jul-2010') datenum('01-Jan-2011')])
xlim_date = xlim;
XTick_interval = (xlim_date(2) - xlim_date(1))/6;
XTick_dates = xlim_date(1):XTick_interval:xlim_date(2);
XTickLabel_dates = datestr(XTick_dates,'dd/mm/yy');
set(gca,'XTick',XTick_dates, 'XTickLabel',XTickLabel_dates)
legend('Oxy 0','Oxy 1','Oxy8','Oxy9')
ylabel('Percent Hypoxia')
hold off
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 28.;
        ySize = 10.;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        print(gcf,'-dpng',['Swan_OxyAll_%oxy_oxydomain_hypox_JulDec.png'],'-opengl');