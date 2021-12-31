clear all; close all;

addpath(genpath('../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
ncfile = 'Y:\Erie\Erie_TFVAED_Scn00\Output.00\erie_00_AED_diag.nc';
ncfile2 = 'Y:\Erie\tfv_011_Scn00\Output\erie_00_AED_diag.nc';
%TMALG
%No Conv
%FRP
%Normal Conv


%%
%titles = {'WVHT','TAUB','PICKUP_TOTAL','TSS'}; %DEPOSITION_TOTAL
titles = {'WQ_DIAG_MAG_GPP_BEN','WQ_DIAG_MAG_GPP_BEN','WQ_DIAG_TOT_PAR','WQ_DIAG_TOT_PAR'}; %DEPOSITION_TOTAL
titles2 = {'GPP (mmolC/m^2/day): v10','GPP (mmolC/m^2/day): v11','PAR (W/m^2): v10','PAR (W/m^2): v11'}; %DEPOSITION_TOTAL
conv = [1 1 1 1];
caxt = [0.1 0.1 100 100];
%bedmass=ncread(ncfile,'BED_MASS_LAYER_1');

clip_depth = 0.05;% In m
%clip_depth = 999;% In m

%____________


dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

dat = tfv_readnetcdf(ncfile,'timestep',1);
clear funcions

vert(:,1) = dat.node_X;
vert(:,2) = dat.node_Y;

faces = dat.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);


bottom_ind(1:length(dat.idx3)-1) = dat.idx3(2:end) - 1;
bottom_ind(length(dat.idx3)) = length(dat.idx3);

clear dat;

%____________

dat = tfv_readnetcdf(ncfile2,'time',1);
timesteps2 = dat.Time;

dat = tfv_readnetcdf(ncfile2,'timestep',1);
clear funcions

vert2(:,1) = dat.node_X;
vert2(:,2) = dat.node_Y;

faces2 = dat.cell_node';

%--% Fix the triangles
faces2(faces2(:,4)== 0,4) = faces2(faces2(:,4)== 0,1);


bottom_ind2(1:length(dat.idx3)-1) = dat.idx3(2:end) - 1;
bottom_ind2(length(dat.idx3)) = length(dat.idx3);

clear dat;



%% plotting
%img_dir = 'X:\CDM\hchb_tfvaed_20201101_20210401_v1\check_MA2\';
img_dir = 'check_MA2\';

if ~exist(img_dir,'dir')
    mkdir(img_dir);
end

sim_name = [img_dir,'animation_MA2.mp4'];

% hvid = VideoWriter(sim_name,'MPEG-4');
% set(hvid,'Quality',100);
% set(hvid,'FrameRate',8);
% framepar.resolution = [1024,768];
% 
% open(hvid);



hfig = figure('visible','on','position',[304         166        1271         812]);
set(gcf,'color','w');
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'paperposition',[0.635 6.35 20.32 20.24])


t0=datenum('20130601 00:00','yyyymmdd HH:MM');
tt1 = find(abs(timesteps-t0)==min(abs(timesteps-t0)));

t1=datenum('20130701 00:00','yyyymmdd HH:MM');
tt2 = find(abs(timesteps-t1)==min(abs(timesteps-t1)));



plot_interval=1;
loc=[0.05 0.6 0.45 0.4;...
    0.55 0.6 0.45 0.4;...
    0.05 0.10 0.45 0.4;...
    0.55 0.10 0.45 0.4];

cbloc =[0.1 0.57 0.35 0.01;...
    0.6 0.57 0.35 0.01;...
    0.1 0.05 0.35 0.01;...
    0.6 0.05 0.35 0.01];

loc1=[0.42 0.48 0.3 0.05];
loc2=[0.45 0.45 0.3 0.1];

for i=tt1:tt2
    
    
    
    
    tdat = tfv_readnetcdf(ncfile,'timestep',i);
    
    
    [~,ind] = min(abs(timesteps2 - timesteps(i)));
    tdat2 = tfv_readnetcdf(ncfile2,'timestep',ind);
    
    
    clf;
    %for ddd = 1:2
    
    for ii=1:4
        axes('Position',loc(ii,:))
        mapshow('Background.png');hold on
        switch ii
            case 1
                cdata01=tdat.(titles{ii});
                cdata0 = cdata01(bottom_ind);
                cdata0 = cdata0 * conv(ii);
                
                patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata0);shading flat;
                set(gca,'box','on');
                
            case 2
                cdata01=tdat2.(titles{ii});
                cdata0 = cdata01(bottom_ind2);
                cdata0 = cdata0 * conv(ii);
                
                patFig = patch('faces',faces2,'vertices',vert2,'FaceVertexCData',cdata0);shading flat;
                set(gca,'box','on');
            case 3
                cdata01=tdat.(titles{ii});
                cdata0 = cdata01(bottom_ind);
                cdata0 = cdata0 * conv(ii);
                
                
                patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata0);shading flat;
                set(gca,'box','on');
            case 4
                cdata01=tdat2.(titles{ii});
                cdata0 = cdata01(bottom_ind2);
                cdata0 = cdata0 * conv(ii);
                
                patFig = patch('faces',faces2,'vertices',vert2,'FaceVertexCData',cdata0);shading flat;
                set(gca,'box','on');
        end
        
        
        
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        %x_lim = [151.12 151.25]; %get(gca,'xlim');
        %y_lim = [-23.82 -23.74]; % get(gca,'ylim');
        %x_lim = get(gca,'xlim');
        %y_lim = get(gca,'ylim');
        
        
        
        caxis([0 caxt(ii)]);
        
        cb = colorbar('southoutside');
        text(0.1,0.8,titles2{ii},'color','w','fontsize',12,'units','normalized');
        %title(titles2{ii});
        set(cb,'position',cbloc(ii,:),...
            'units','normalized','ycolor','k');
        
        %colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
        hold on;
        %set(gca,'box','on');
        axis on;
        axis equal;
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        
         xlim([602439.852885338          638063.943455774]);
         ylim([4734143.11147883          4757422.98087388]);
        
        % set(gca,'xlim',x_lim,'ylim',y_lim);
    end
    
    str=['Time: ',datestr(timesteps(i),'yyyy-mm-dd HH:MM')];
    
    %        text(loc1(1),loc1(2),str,'fontsize',14,'HorizontalAlignment','center');
    
    annotation('textbox',loc1,'String',str,'FitBoxToText','on',...
        'FontWeight','bold','FontSize',14,'LineStyle','none','HorizontalAlignment','left');
    
    img_name =[img_dir,datestr(timesteps(i),'yyyymmddHHMM'),'.png'];
    
    saveas(gcf,img_name);
    %writeVideo(hvid,getframe(hfig));
    %end
end

%   img_name ='snapshot.png';

%   saveas(gcf,img_name);

close(hvid);