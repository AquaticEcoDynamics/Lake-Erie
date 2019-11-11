function plot4bb(xdata,ydata,xdata1,ydata1,xdata2,ydata2,xdata3,ydata3,opts,leg)
% Function to create a standardised plot for the River Murray Report.
% Requires the following opts to work:
%
% opts.title = title string;
% opts.xlabel = xlabel string;
% opts.ylabel = ylabel string;
% opts.savename = save name string
%

figure('visible','off')



plot(xdata,ydata,'color','k');hold on
plot(xdata1,ydata1,'color','r');hold on
plot(xdata2,ydata2,'color','b');hold on
plot(xdata3,ydata3,'color','g');hold on

set(gca,'box','on','XGrid','on','YGrid','on');

sTitle = opts.title;
sXLabel = opts.xlabel;
sYLabel = opts.ylabel;
savename = opts.savename;

if isfield(opts,'xlim')
    datearray = [opts.xlim(1):(opts.xlim(2) - opts.xlim(1))/ 5 :opts.xlim(2)];
else
    datearray = [min(xdata):(max(xdata) - min(xdata))/ 5 :max(xdata)];
end
set(gca,'XTick',datearray','XTickLabel',datestr(datearray,'dd/mm/yy'),...
    'FontSize',6,'FontWeight','Bold','FontName','Optima');

xlabel(sXLabel,'FontSize',8,'FontWeight','Bold','FontName','Optima');

ylab = get(gca,'YTick');

set(gca,'YTick',ylab,...
    'FontSize',6,'FontWeight','Bold','FontName','Optima');

ylabel(sYLabel,'FontSize',8,'FontWeight','Bold','FontName','Optima');

if isfield(opts,'xlim')
    xlim(opts.xlim);
end
title(sTitle,'Units','Normalized','Position',[0.1 1.0],...
    'FontSize',9,'FontWeight','Bold',...
    'FontName','Optima','horizontalalignment','left');

legend(leg,'Location','NE',...
    'FontSize',5,'FontWeight','Bold',...
    'FontName','Optima','box','on');


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 7.5;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[xLeft yTop xSize ySize])
set(gcf,'position',[0.01 0.01 xSize*50 ySize*50])


print(gcf,'-dpng',savename,'-opengl');
savename = regexprep(savename,'png','eps');
print(gcf,'-depsc2',savename,'-painters');

close