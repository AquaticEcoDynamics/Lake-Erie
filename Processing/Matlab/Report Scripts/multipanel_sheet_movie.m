clear all; close all;

addpath(genpath('tuflowfv'));


ncfile1 = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed.nc';
ncfile2 = 'D:\Simulations\Erie\tfv_004_2013_MET_aed2_2018_BIV\Output\erie_aed_diag.nc';

outdir = 'F:\Dropbox\AED_LakeErie\Report\';

if ~exist(outdir,'dir')
    mkdir(outdir);
end


sim_name = [outdir,'4Panel.mp4'];

hvid = VideoWriter(sim_name,'MPEG-4');
set(hvid,'Quality',100);
set(hvid,'FrameRate',6);
framepar.resolution = [1024,768];

open(hvid);

dat = tfv_readnetcdf(ncfile1,'time',1);
timesteps1 = dat.Time;

dat1 = tfv_readnetcdf(ncfile2,'time',1);
timesteps2 = dat1.Time;

dat = tfv_readnetcdf(ncfile1,'timestep',1);
clear funcions


vert(:,1) = dat.node_X;
vert(:,2) = dat.node_Y;

faces = dat.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

bottom_cells(1:length(dat.idx3)-1) = dat.idx3(2:end) - 1;
bottom_cells(length(dat.idx3)) = length(dat.idx3);



first_plot = 1;

for i = 50:1:length(timesteps2)
    
    [~,ts] = min(abs(timesteps1-timesteps2(i)));
    
    tdat1 = tfv_readnetcdf(ncfile1,'timestep',ts);
    tdat2 = tfv_readnetcdf(ncfile2,'timestep',i);
    clear functions
    
    cdata_frp = tdat1.WQ_PHS_FRP(tdat1.idx3(tdat1.idx3 > 0));
    cdata_tchla = tdat2.WQ_DIAG_PHY_TCHLA(tdat2.idx3(tdat2.idx3 > 0));
    cdata_tmalg = tdat2.WQ_DIAG_MAG_TMALG(bottom_cells);
    cdata_BIV = tdat2.WQ_DIAG_BIV_GRZ(bottom_cells);
    
    if first_plot
        
        hfig = figure('visible','on','position',[317.8 233 1628.8 800.8]);
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf,'paperposition',[0.635 6.35 20.32 15.24])
        
        axes('position',[0.0 00.5 0.7 0.5]);
        
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata_frp);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis([0 2.5]);
        
        text(0.1,0.9,'Surface Phosphate',...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',12,...
            'fontweight','Bold',...
            'color','k');
        
        
        cb = colorbar;
        
        set(cb,'position',[0.61 0.55 0.01 0.3],...
            'units','normalized','ycolor','k');
        
        axis off
        axis equal
        
        axes('position',[0.0 0 0.7 0.5]);%______________________________________
        
        patFig2 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata_tchla);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis([0 20]);
        
        text(0.1,0.9,'Surface Chlorophll-a',...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',12,...
            'fontweight','Bold',...
            'color','k');
        
        txtDate = text(0.6,0.1,datestr(timesteps2(i),'dd mmm yyyy HH:MM'),...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',21,...
            'color','k');
        cb = colorbar;
        
        set(cb,'position',[0.61 0.05 0.01 0.3],...
            'units','normalized','ycolor','k');
        
        axis off
        axis equal
        
        axes('position',[0.7 0.5 0.3 0.5]);%______________________________________
        
        patFig3 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata_tmalg);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis([0 20]);
        text(0.1,0.9,'Cladophoria Biomass',...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',12,...
            'fontweight','Bold',...
            'color','k');
        cb = colorbar;
        
        set(cb,'position',[0.96 0.55 0.01 0.3],...
            'units','normalized','ycolor','k');
        
        
        
        axis off
        axis equal
        xlim([553814.984018236          681207.909678015]);
        ylim([4654205.4002249          4758593.34929615]);
        axes('position',[0.7 0.0 0.3 0.5]);%______________________________________
        
        patFig4 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata_BIV);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis([0 0.25]);
        text(0.1,0.9,'Mussel Grazing Rate',...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',12,...
            'fontweight','Bold',...
            'color','k');
        cb = colorbar;
        
        set(cb,'position',[0.96 0.05 0.01 0.3],...
            'units','normalized','ycolor','k');
        
        
        
        axis off
        axis equal
        xlim([553814.984018236          681207.909678015]);
        ylim([4654205.4002249          4758593.34929615]);
        
        first_plot = 0;
        
        
    else
        
        set(patFig1,'Cdata',cdata_frp);drawnow;
        set(patFig2,'Cdata',cdata_tchla);drawnow;
        set(patFig3,'Cdata',cdata_tmalg);drawnow;
        set(patFig4,'Cdata',cdata_BIV);drawnow;

        
        set(txtDate,'String',datestr(timesteps2(i),'dd mmm yyyy HH:MM'));
                drawnow;

        %caxis(cax);
        
    end
        writeVideo(hvid,getframe(hfig));

end

close(hvid);

close all;
