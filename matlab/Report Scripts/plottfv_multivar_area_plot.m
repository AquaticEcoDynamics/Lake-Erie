clear all; close all;
addpath(genpath('tuflowfv'))

% A simple script to do a multiplot stacked area plot from a TFV netcdf.

ncfile = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_004_2013_MET_aed2_2018_BIV_ICE_RST\Output\erie_AED.nc';

outputdirectory = 'C:\tfv_004_2013_MET_aed2_2018_BIV_ICE_RST\Area\';

if ~exist(outputdirectory,'dir')
    mkdir(outputdirectory);
end
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


vars = {'WQ_PHY_DINOF';...
    'WQ_PHY_CYANO';...
    'WQ_PHY_NODUL';...
    'WQ_PHY_CHLOR';...
    'WQ_PHY_CRYPT';...
    };

conversions = [1 1 1 1 1];

data = tfv_readnetcdf(ncfile,'names',vars);

data = rmfield(data,'ResTime');

td = tfv_readnetcdf(ncfile,'timestep',1);

dat = tfv_readnetcdf(ncfile,'time',1);

%_______________________________
for j = 1:length(site)
    
    finalname =[outputdirectory,site(j).Name,' Area.eps'];
    
    
    %--% Search
    pnt(1,1) = site(j).X;
    pnt(1,2) = site(j).Y;
    
    geo_x = double(td.cell_X);
    geo_y = double(td.cell_Y);
    dtri = DelaunayTri(geo_x,geo_y);
    
    
    pt_id = nearestNeighbor(dtri,pnt);
    
    Cell_3D_IDs = find(td.idx2==pt_id);
    
    surfIndex = min(Cell_3D_IDs);
    botIndex = max(Cell_3D_IDs);
    
    for i = 1:length(vars)
        aData(:,i) = data.(vars{i})(surfIndex,:) .* conversions(i);
    end
    
    figure;area(dat.Time,aData);
    
    legend(regexprep(vars,'_',' '),'location','northwest','fontsize',6);
    
    xlim([datearray(1) datearray(end)]);
    ylim([0 30]);
    set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yyyy'),'fontsize',6);
    
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 10;
    ySize = 6;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    
    print(gcf,finalname,'-depsc2');
    saveas(gcf,regexprep(finalname,'.eps','.png'));
    
    close all;
end