clear all; close all;

addpath(genpath('tuflowfv'));
int = 1;

var(int).name = 'TEMP';
var(int).nc = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_tfv.nc';
var(int).conv = 1;
var(int).caxis = [0 25];
var(int).Title = 'Temperature (C)';
int = int  + 1;

var(int).name = 'WQ_OXY_OXY';
var(int).nc = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_aed.nc';
var(int).conv = 32/1000;
var(int).caxis = [5 20];
var(int).Title = 'Oxygen (mg/L)';
int = int  + 1;

var(int).name = 'WQ_PHS_FRP';
var(int).nc = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_aed.nc';
var(int).conv = 31/1000;
var(int).caxis = [0 0.035];
var(int).Title = 'PO_4 (mg/L)';
int = int  + 1;

var(int).name = 'WQ_DIAG_TOT_TP';
var(int).nc = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_aed_diag.nc';
var(int).conv = 31/1000;
var(int).caxis = [0 0.05];
var(int).Title = 'TP (mg/L)';
int = int  + 1;

var(int).name = 'WQ_DIAG_PHY_TCHLA';
var(int).nc = 'G:\tfv_007_2013_BMT_aed2_BIV\Output\erie_aed_diag.nc';
var(int).conv = 1;
var(int).caxis = [0 15];
var(int).Title = 'TCHLa (ug/L)';
int = int  + 1;




pdate = datenum(2013,11:1:15,01,12,00,00);

outputdir = 'D:\Cloud\Cloudstor\Data_Erie\2019\tfv_007_2013_BMT_aed2_BIV\Multisheet\';

cols = 2;
rows = 3;

if ~exist(outputdir,'dir')
    mkdir(outputdir);
end

%__________________________________________________________________________________

for j = 1:length(pdate)
    figure
    
    
    
    for i = 1:length(var)
        dat = tfv_readnetcdf(var(i).nc,'time',1);
        [~,var(i).ts] = min(abs(dat.Time - pdate(j)));
        
        
        
        subplot(rows,cols,i)
        
        data = tfv_readnetcdf(var(i).nc,'timestep',var(i).ts);
        
        vert(:,1) = data.node_X;
        vert(:,2) = data.node_Y;
        
        faces = data.cell_node';
        
        %--% Fix the triangles
        faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);
        
        
        surf_ind = data.idx3;
        
        bottom_ind(1:length(data.idx3)-1) = data.idx3(2:end) - 1;
        bottom_ind(length(data.idx3)) = length(data.idx3);
        
        
        cdata = data.(var(i).name)(surf_ind) * var(i).conv;
        
        %colormap(jet);
        
        fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat;hold on
        
        caxis(var(i).caxis);
        
        cb = colorbar('location','southoutside');
        
        cb1 = get(cb,'position');
        set(cb,'position',[cb1(1) (cb1(2)-0.1) cb1(3) 0.01]);
        
        text(0.2,0.99,var(i).Title,'fontsize',8,'units','normalized');
        text(0.6,0.0,datestr(pdate(j),'dd-mm-yyyy'),'fontsize',8,'units','normalized','horizontalalignment','center');
        axis off; axis equal;
        
        
    end
    
    
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 16;
    ySize = 20;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    finalname = [outputdir,datestr(pdate(j),'yyyymmdd'),'.png'];
    %print(gcf,finalname,'-depsc2');
    print(gcf,finalname,'-dpng','-r300');
    
    close all;
    
end

