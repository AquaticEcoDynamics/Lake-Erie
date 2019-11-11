function     plotLineData(nc,userdata,opts,var,site,sitenumber,currentVariable,cax,fullpath);
% Function to....
didplot = 0;
get(0,'CurrentFigure');
if strcmp(userdata.defaults.line.type,'Joined') > 0
    joinedDates = [];
    joinedData = [];
    for ii = 1:length(nc)
        dbNumber = site.([cell2mat(userdata.simulation(ii).project)]).Datablock.([cell2mat(userdata.simulation(ii).grid)])(sitenumber);
        if ~isnan(dbNumber)
            joinedDates = [joinedDates;nc(ii).data.matdate];
            switch currentVariable
                case 'Level'
                    joinedData = [joinedData;nc(ii).data.FreeSurfHeights(:,dbNumber)];
                otherwise
                    joinedData = [joinedData;nc(ii).data.crtdata(:,1,dbNumber)];
            end
        end
    end
    if ~isempty(joinedData)
        hold on
        [unDates,ind] = unique(joinedDates);
        unData = joinedData(ind);
        fullDates = [min(unDates):1:max(unDates)];
        fullData = interp1(unDates,unData,fullDates);
        h1 = plot(fullDates,smooth(fullData(:),opts.line.joined),'displayname','Simulation');hold on
        set(h1,'color','k');
        didplot = 1;
        clear h1;
    end
    
else
    for ii = 1:length(nc)
        dbNumber = site.([cell2mat(userdata.simulation(ii).project)]).Datablock.([cell2mat(userdata.simulation(ii).grid)])(sitenumber);
        if ~isnan(dbNumber)
            switch currentVariable
                case 'Level'
                    h1 = plot(nc(ii).data.matdate,nc(ii).data.FreeSurfHeights(:,dbNumber),'displayname',userdata.simulation(ii).legend); hold on
                otherwise
                    h1 = plot(nc(ii).data.matdate,smooth(nc(ii).data.crtdata(:,1,dbNumber),opts.line.smoothdefault),'displayname',userdata.simulation(ii).legend); hold on
            end
            set(h1,'color',str2num(cell2mat(userdata.simulation(ii).colour)));
            clear h1
            didplot = 1;
        end
        clear dbNumber
    end
end
if didplot ==1
    
    disp(['Plotting ',site.([cell2mat(userdata.simulation(1).project)]).name{sitenumber}]);
    leg = legend('location',var.([currentVariable]).Legend);
    set(leg,'fontsize',6);
    titlestr = [site.([cell2mat(userdata.simulation(1).project)]).name(sitenumber),...
                ' - ',var.([currentVariable]).Title];
    titlestr = strrep(titlestr,'_','-');        
    title(titlestr,'fontsize',opts.title.fontsize);
    ylimitsMin = cax.([currentVariable]).([site.([cell2mat(userdata.simulation(1).project)]).region{sitenumber}]).min;
    ylimitsMax = cax.([currentVariable]).([site.([cell2mat(userdata.simulation(1).project)]).region{sitenumber}]).max;
    if ~isnan(ylimitsMin)
        set (gca,'xlim',[userdata.startdate userdata.enddate],'ylim',[ylimitsMin ylimitsMax]);
    else
        set (gca,'xlim',[userdata.startdate userdata.enddate]);
    end
    %dxt = userdata.enddate - userdata.startdate;
    %xt_new = userdata.startdate:dxt/8:userdata.enddate;
    xt_new = userdata.datearray;
	% Hack for River Murray
	%xt_new(1) = datenum('01/07/2010','dd/mm/yyyy');
	%xt_new(2) = datenum('01/10/2010','dd/mm/yyyy');
	%xt_new(3) = datenum('01/01/2011','dd/mm/yyyy');
	
	%xt_new(4) = datenum('01/04/2011','dd/mm/yyyy');
	%xt_new(5) = datenum('01/07/2011','dd/mm/yyyy');
	%xt_new(6) = datenum('01/10/2011','dd/mm/yyyy');
	%xt_new(7) = datenum('01/01/2012','dd/mm/yyyy');
	%xt_new(8) = datenum('01/04/2012','dd/mm/yyyy');
	
    set(gca,'xtickmode','manual','XTick',xt_new,...
        'XTickLabel',datestr(xt_new,cell2mat(opts.datetick.format)),'fontsize',opts.xaxis.fontsize)
    xlabel('Date','fontsize',6)
    ylabel([var.([currentVariable]).Title,' ',var.([currentVariable]).Units],'fontsize',opts.yaxis.fontsize)
    
    fullDirEPS = [fullpath.outputpth,'/',cell2mat(userdata.directory),'/EPS/',currentVariable,'/'];
    fullDirPNG = [fullpath.outputpth,'/',cell2mat(userdata.directory),'/PNG/',currentVariable,'/'];
    
    mkdir(fullDirEPS);
    
    pngName = [fullDirPNG,site.([cell2mat(userdata.simulation(1).project)]).name{sitenumber},'.png'];
    epsName = [fullDirEPS,site.([cell2mat(userdata.simulation(1).project)]).name{sitenumber},'.eps'];
    
    if strcmpi(userdata.simulation(1).project,'murray')
        if ~exist([fullDirEPS,'6_Sites.ai'],'file');
            copyfile('../data/murray/ai/6_Sites.ai',[fullDirEPS,'6_Sites.ai']);
        end
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = opts.line.width;
    ySize = opts.line.height;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[xLeft yTop xSize ySize])
    set(gcf,'position',[0.01 0.01 xSize*50 ySize*50])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    print('-depsc',epsName,'-painters');
    if strcmp(userdata.png,'on')
        mkdir(fullDirPNG);
        print('-dpng',pngName,'-opengl');
    end
    
    close all
    
end