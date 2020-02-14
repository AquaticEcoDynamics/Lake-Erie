function plotSheetData(nc,userdata,opts,var,plottime,currentVariable,reference,fullpath,int)
% Function to .........
warning off
% Output Directory
disp(currentVariable);
outdir = ([fullpath.outputpth,'/',userdata.directory{1},'/',currentVariable]);
mkdir([outdir,'/png/']);
mkdir([outdir,'/eps/']);


imagename = ([fullpath.confpth,'/image/',userdata.defaults.sheet.focus{1},...
    '/',userdata.defaults.sheet.focus{1},'_',userdata.defaults.sheet.background{1}]);
[XImage,map] = imread([imagename,'.png']);
R =  worldfileread([imagename,'.pgw']);
toplot(1:length(nc),1) = 0;
%find nearest
nearestX = [];
for ii = 1:length(nc)
    T = delaunayn(nc(ii).data.matdate);
    nearestX(ii) = dsearchn(nc(ii).data.matdate,T,plottime);
    if ~isnan(nearestX(ii))
        if abs(plottime - nc(ii).data.matdate(nearestX(ii))) < 10
            toplot(ii) = 1;
        end
    end
end
if sum(toplot) > 0
    axes('position',[0.1 0.1 0.8 0.8])
    set(gcf,'visible',userdata.defaults.sheet.show{1})

    [HH,imMap] = plotimage1surf(XImage,R,'2d');
    hold on
    freezeColors
    for ii = 1:length(nc)
        if toplot(ii) > 0
            colormap(jet);
            plotvar = squeeze(nc(ii).data.([var.([currentVariable]).ELCD])(nearestX(ii),:,:));
            pcolor(reference(ii).X,reference(ii).Y,plotvar');hold on
            clear plotvar;
        end
    end
    
    if sum(toplot) > 0
        shading flat
        hMin = nc(ii).data.hMin;
        hMax = nc(ii).data.hMax;
        caxis([hMin hMax])
        cbar = colorbar;
        labels = get(cbar,'YTickLabel');    % Get the current labels
        set(cbar,'YLimMode','manual',...
            'YTickMode','manual',...
            'YAxisLocation',opts.colorbar.side{1},... %# Freeze the current limits
            'YTick',[hMin (hMin + (hMax  - hMin)/2) hMax],...
            'YTickLabel',[hMin (hMin + (hMax  - hMin)/2) hMax]);  %# Change the labels
        set(cbar,'position',str2num(opts.colorbar.location{1}),...
            'fontweight',opts.colorbar.fontweight{1},'fontsize',opts.colorbar.fontsize,...
            'fontname',opts.colorbar.fontname{1})
        
        % Clock loopDate
        axes('position',str2num(opts.datestamp.location{1}))
        set(gca,'color','none')
        text(0,0,datestr(plottime,opts.datestamp.format{1}),...
            'fontsize',9,'fontname','Helvetica','fontweight','bold')
        axis off
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = opts.sheet.width;
        ySize = opts.sheet.height;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        print('-dpng',[outdir,'/png/',currentVariable,'_',datestr(plottime,'yyyymmdd'),'_',num2str(int)],'-zbuffer')
        print('-depsc',[outdir,'/eps/',currentVariable,'_',datestr(plottime,'yyyymmdd'),'_',num2str(int)],'-zbuffer')
        
        close
    end
end

warning on
