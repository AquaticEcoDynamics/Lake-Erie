clear all; close all;
addpath(genpath('tuflowfv'))

% A simple script to do a multiplot stacked area plot from a TFV netcdf.

ncfile = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_AED_DIAG.nc';

outputdirectory = 'D:\Cloud\Cloudstor\Data_Erie\2019\Time Curtain\';

%
% site(1).X = 2005700.0;
% site(1).Y = 15469300.0;
% site(1).Name = 'Erie Open';
%
% site(2).X = 1619500.0;
% site(2).Y = 1619500.0;
% site(2).Name = 'Erie Mid';

site = shaperead('GIS/Erie_Pnt.shp');

datearray = datenum(2013,11:1:15,01);

ylab = {'TCHLa (ug/L)';...
    'TP (mg/L)',...
    };

vars = {'WQ_DIAG_PHY_TCHLA';...
    'WQ_DIAG_TOT_TP';...
%     'WQ_PHY_NODUL';...
%     'WQ_PHY_CHLOR';...
%     'WQ_PHY_CRYPT';...
%     'WQ_OXY_OXY';...
%     'WQ_PHS_FRP';...
    };


%WQ_DIAG_BIV_NMP

cax(1).val = [0 15];
cax(2).val = [0 0.05];
% cax(3).val = [0 15];
% cax(4).val = [0 15];
% cax(5).val = [0 15];
% cax(6).val = [8 14];
% cax(7).val = [0 0.3];

conversions = [1 31/1000 1 1 1 32/1000 ];


tz = tfv_readnetcdf(ncfile,'names',{'layerface_Z';'NL'});


td = tfv_readnetcdf(ncfile,'timestep',1);

dat = tfv_readnetcdf(ncfile,'time',1);



%_______________________________
for j = 1:length(site)
    
    
    
    %--% Search
    pnt(1,1) = site(j).X;
    pnt(1,2) = site(j).Y;
    
    geo_x = double(td.cell_X);
    geo_y = double(td.cell_Y);
    dtri = DelaunayTri(geo_x,geo_y);
    
    
    pt_id = nearestNeighbor(dtri,pnt);
    
    Cell_3D_IDs = find(td.idx2==pt_id);
    
    %     surfIndex = min(Cell_3D_IDs);
    %     botIndex = max(Cell_3D_IDs);
    
    
    NL = tz.NL(pt_id);
    i3 = td.idx3(pt_id);
    i3z = i3 + pt_id -1;
    
    Layer = tz.layerface_Z((i3z+1):(i3z+NL),:);
    
    deepest = min(Layer(:));
    
    level = max(Layer(:));
    
    [XX,YY] = meshgrid([datearray(1):1/24:datearray(end)],[deepest:0.05:level]);
    
    for k = 1:length(dat.Time)
            xData(1:length(Layer(:,k)),k) = dat.Time(k);
    end
    
    for i = 1:length(vars)
        
        data = tfv_readnetcdf(ncfile,'names',vars(i));
        data = rmfield(data,'ResTime');  
        if ~exist([outputdirectory,vars{i},'/'],'dir')
            mkdir([outputdirectory,vars{i},'/']);
        end

        finalname =[[outputdirectory,vars{i},'/'],site(j).Name,'.png'];
        
        aData = data.(vars{i})(Cell_3D_IDs,:) .* conversions(i);
        

        
        F = TriScatteredInterp(xData(:),Layer(:),aData(:));
        
        ZZ = F(XX,YY);
        figure;
        axes('position',[0.1 0.1 0.8 0.7]);
        
        pcolor(XX,YY,ZZ);shading flat;
        
        cb = colorbar('location','northoutside');
        
        set(cb,'position',[0.1 0.85 0.8 0.02]);
        
        
        
        caxis(cax(i).val);
        %legend(regexprep(vars,'_',' '),'location','northwest');
        
        xlim([datearray(1) datearray(end)]);
        ylim([deepest level]);
        
        text(0.05,0.9,ylab{i},'fontsize',8,'fontweight','bold','units','normalized');
        ylabel('Depth (m)','fontsize',8);
        
        set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'),'fontsize',8);
        
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 14;
        ySize = 5;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        
        %print(gcf,finalname,'-depsc2');
        print(gcf,finalname,'-dpng','-r300');
        
        
        clear aData
        close all;
    end
    clear Layer xData 
    
    
end