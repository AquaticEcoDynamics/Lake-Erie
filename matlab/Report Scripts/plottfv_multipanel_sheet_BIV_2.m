clear all; close all;

addpath(genpath('tuflowfv'));
int = 1;

% var(int).name = 'WQ_BIV_FILTFRAC';
% var(int).nc = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_004_2013_MET_aed2_2018_BIV - Copy\Output\erie_aed.nc';
% var(int).conv = 1;
% var(int).caxis = [0 0.8];
% var(int).Title = 'BIV FRAC';
% int = int  + 1;
% 
% var(int).name = 'WQ_DIAG_BIV_NUM';
% var(int).nc = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_004_2013_MET_aed2_2018_BIV - Copy\Output\erie_aed_diag.nc';
% var(int).conv = 1;
% var(int).caxis = [0 1];
% var(int).Title = 'BIV NUM';
% int = int  + 1;
% 
% var(int).name = 'WQ_DIAG_BIV_NMP';
% var(int).nc = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_004_2013_MET_aed2_2018_BIV - Copy\Output\erie_aed_diag.nc';
% var(int).conv = 1;
% var(int).caxis = [0 1];
% var(int).Title = 'BIV NMP';
% int = int  + 1;
% 
% var(int).name = 'WQ_DIAG_BIV_TBIV';
% var(int).nc = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_004_2013_MET_aed2_2018_BIV - Copy\Output\erie_aed_diag.nc';
% var(int).conv = 1;
% var(int).caxis = [0 1000];
% var(int).Title = 'BIV TBIV';
% int = int  + 1;


var(int).name = 'WQ_MAG_CGM';
var(int).nc = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed.nc';
var(int).conv = 1;
var(int).caxis = [0 0.8];
var(int).Title = 'CLADOPHORA';
int = int  + 1;

var(int).name = 'WQ_MAG_CGM_IP';
var(int).nc = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed.nc';
var(int).conv = 1;
var(int).caxis = [0 1];
var(int).Title = 'CLADOPHORA IN';
int = int  + 1;

var(int).name = 'WQ_MAG_CGM_IP';
var(int).nc = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed.nc';
var(int).conv = 1;
var(int).caxis = [0 1];
var(int).Title = 'CLADOPHORA IP';
int = int  + 1;

var(int).name = 'WQ_DIAG_MAG_GPP';
var(int).nc = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed_diag.nc';
var(int).conv = 1;
var(int).caxis = [0 1000];
var(int).Title = 'GPP';
int = int  + 1;





% var(int).name = 'WQ_DIAG_PHY_TCHLA';
% var(int).nc = 'D:\Simulations\Erie\Lake Erie\TFVAED2\tfv_002_2013_2dwind_aed2_2018\Output\erie__aed_diag.nc';
% var(int).conv = 1;
% var(int).caxis = [0 15];
% var(int).Title = 'TCHLa (ug/L)';
% int = int  + 1;




pdate = datenum(2013,05,28:05:80,12,00,00);

outputdir = 'F:\Dropbox\Data_Erie\20180330\tfv_004_2013_MET_aed2_2018_BIV_Updated\Multisheet_CLADOPHORA_surface\';

cols = 2;
rows = 2;

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
        
        
        cdata = data.(var(i).name)(bottom_ind) * var(i).conv;
        
        %colormap(jet);
        
        fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat;hold on
        
        %caxis(var(i).caxis);
        
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

