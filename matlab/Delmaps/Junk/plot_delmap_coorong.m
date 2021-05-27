clear; close all;


scen_a = 'CoorongBGC_SC14_base_typ_001_all'; %base case
% scen_b = 'SC07';

scen_b = {...
%     'CoorongBGC_SC04_LAC_dry_001_all',...
%       'CoorongBGC_SC08_pump_in_out_constant_250_ML_d_dry_001_all',...
%       'CoorongBGC_SC09_pump_out_500_ML_d_dry_001_all',...
%       'CoorongBGC_SC10_pump_out_250_ML_d_plus_dredge_dry_001_all',...
%       'CoorongBGC_SC11_LAC_plus_dredge_dry_001_all',...
%       'CoorongBGC_SC12_pump_out_125_ML_d_dry_001_all',...
%       'CoorongBGC_SC13_pump_in_constant_250_ML_d_dry_001_all',...
%       'CoorongBGC_SC14_base_typ_001_all',...
      'CoorongBGC_SC15_culverts_10x1500_typ_001_all',...
      'CoorongBGC_SC16_pump_out_250_ML_d_typ_001_all',...
      'CoorongBGC_SC17_LAC_typ_001_all',...
      'CoorongBGC_SC18_SEFA_typ_001_all',...
      'CoorongBGC_SC19_dredge_typ_001_all',...
      'CoorongBGC_SC20_pump_in_out_reverse_500_ML_d_typ_001_all',...
      'CoorongBGC_SC21_pump_in_out_constant_250_ML_d_typ_001_all',...
      'CoorongBGC_SC22_pump_out_500_ML_d_typ_001_all',...
      'CoorongBGC_SC23_pump_out_250_ML_d_plus_dredge_typ_001_all',...
      'CoorongBGC_SC24_LAC_plus_dredge_typ_001_all',...
      'CoorongBGC_SC25_pump_out_125_ML_d_typ_001_all',...
      'CoorongBGC_SC26_pump_in_constant_250_ML_d_typ_001_all',...
      'CoorongBGC_SC27_ABG_typ_001_all',...
    };
	
	scentext = {...
%         'SC04',...
%       'SC08',...
%       'SC09',...
%       'SC10',...
%       'SC11',...
%       'SC12',...
%       'SC13',...
%       'SC14',...
      'SC15',...
      'SC16',...
      'SC17',...
      'SC18',...
      'SC19',...
      'SC20',...
      'SC21',...
      'SC22',...
      'SC23',...
      'SC24',...
      'SC25',...
      'SC26',...
      'SC27',...
    };

year_array = 2018:2019;

for i=1:length(scen_b)
    
    for j=1:length(year_array)
        
        hsi1a= load(['Y:\CIIP\Scenarios\Plotting\',scen_a,'\Sheets\',num2str(year_array(j)),'\1_adult_new\HSI_adult.mat']);
        hsi2a= load(['Y:\CIIP\Scenarios\Plotting\',scen_a,'\Sheets\',num2str(year_array(j)),'\2_flower_new\HSI_flower.mat']);
        hsi3a= load(['Y:\CIIP\Scenarios\Plotting\',scen_a,'\Sheets\',num2str(year_array(j)),'\3_seed_new\HSI_seed.mat']);
        hsi_sexual_a = load(['Y:\CIIP\Scenarios\Plotting\',scen_a,'\Sheets\',num2str(year_array(j)),'\HSI_sexual.mat']);
        
        hsi1b= load(['Y:\CIIP\Scenarios\Plotting\',scen_b{i},'\Sheets\',num2str(year_array(j)),'\1_adult_new\HSI_adult.mat']);
        hsi2b= load(['Y:\CIIP\Scenarios\Plotting\',scen_b{i},'\Sheets\',num2str(year_array(j)),'\2_flower_new\HSI_flower.mat']);
        hsi3b= load(['Y:\CIIP\Scenarios\Plotting\',scen_b{i},'\Sheets\',num2str(year_array(j)),'\3_seed_new\HSI_seed.mat']);
        hsi_sexual_b = load(['Y:\CIIP\Scenarios\Plotting\',scen_b{i},'\Sheets\',num2str(year_array(j)),'\HSI_sexual.mat']);
        
        
        hsi1_del = hsi1b.min_cdata-hsi1a.min_cdata;
        hsi2_del = hsi2b.min_cdata-hsi2a.min_cdata;
        hsi3_del = hsi3b.min_cdata-hsi3a.min_cdata;
        hsi_sexual_del = hsi_sexual_b.min_cdata - hsi_sexual_a.min_cdata;
        
        
        
        outdir = ['Y:\CIIP\Scenarios\Plotting\',scen_b{i},'\Sheets\',num2str(year_array(j)),'\'];
        %%
        %plotting
        
        del_axis= [-1 1];
        del_clip= [-0.1 0.1];
        newmap = blank_col(del_axis, del_clip);
        
        filename = ['Y:\CIIP\Scenarios\BMT_scenarios\CoorongBGC_SC08_pump_in_out_constant_250_ML_d_dry_001_all.nc'];
        
        dat = tfv_readnetcdf(filename,'time',1);
        timesteps = dat.Time;
        dat = tfv_readnetcdf(filename,'timestep',1);
        tt = tfv_readnetcdf(filename,'names',{'cell_A'});
        Area = tt.cell_A;
        
        data = tfv_readnetcdf(filename,'names',{'SAL';'D'});
        
        vert = [];
        faces = [];
        
        vert(:,1) = dat.node_X;
        vert(:,2) = dat.node_Y;
        faces = dat.cell_node';
        faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);
        
        %%
        %%%%%%%%%%%%%%%%%%
        
        hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 707.3333]);
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf,'paperposition',[0.635 6.35 20.32 15.24])
        colormap(newmap);
        
        
        axes('position',[ 0.0 0.05  0.5 1]);
        %axes('position',[ 0.0 0.0  0.5 1]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1_del);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        xlim([3.1808e+05 3.6820e+05]);
        ylim([6.022e+06 6.0704e+06]);
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        %camroll(-20)
        cb = colorbar('location','South','orientation','horizontal');
        set(cb,'position',[0.05 0.15 0.25 0.01]);
        
        text(0.1,0.6,'Adult','fontsize',12,'units','normalized');
        text(0.1,0.1,['\Delta HSI: ',scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',12);
        
        %axes('position',[0.5 0.66 0.5 .33]);
        axes('position',[ 0.1 0.1  0.5 1]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        xlim([3.1808e+05 3.6820e+05]);
        ylim([6.022e+06 6.0704e+06]);
        text(0.1,0.6,'Flower','Units','Normalized','fontsize',12);
        
        axes('position',[ 0.2 0.15  0.5 1]);
        %axes('position',[0.5 0.33 0.5 .33]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        xlim([3.1808e+05 3.6820e+05]);
        ylim([6.022e+06 6.0704e+06]);
        text(0.1,0.6,'Seed','Units','Normalized','fontsize',12);
        
        axes('position',[ 0.48 0.25  0.5 1]);
        %axes('position',[0.5 0.33 0.5 .33]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_sexual_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        % xlim([3.1008e+05 3.6120e+05]);
        % ylim([6.0275e+06 6.0704e+06]);
        xlim([3.1808e+05 3.6820e+05]);
        ylim([6.022e+06 6.0704e+06]);
        
        text(0.21,0.7,'HSI (sexual)','Units','Normalized','fontsize',12);
        
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 21;
        ySize = 12.5;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        
        saveas(gcf,[outdir,'HSI_sexual_north_del_noocean.png']);
        
        %%
        %______________________________
        
        
        hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 707.3333]);
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf,'paperposition',[0.635 6.35 20.32 15.24])
        colormap(newmap);
        
        axes('position',[ 0.0 0.1  0.5 0.9]);
        %axes('position',[ 0.0 0.0  0.5 1]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1_del);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        xlim([3.4280e+05 3.9398e+05]);
        ylim([5.9896e+06 6.0326e+06]);
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        %camroll(-20)
        cb = colorbar('location','South','orientation','horizontal');
        set(cb,'position',[0.05 0.15 0.25 0.01]);
        
        text(0.25,0.95,'Adult','fontsize',12,'units','normalized');
        text(0.10,0.05,['\Delta HSI: ',scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',12);
        
        %axes('position',[0.5 0.66 0.5 .33]);
        axes('position',[ 0.1 0.1  0.5 0.9]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        xlim([3.4280e+05 3.9398e+05]);
        ylim([5.9896e+06 6.0326e+06]);
        text(0.25,0.95,'Flower','Units','Normalized','fontsize',12);
        
        axes('position',[ 0.2 0.1  0.5 0.9]);
        %axes('position',[0.5 0.33 0.5 .33]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        xlim([3.4280e+05 3.9398e+05]);
        ylim([5.9896e+06 6.0326e+06]);
        text(0.25,0.95,'Seed','Units','Normalized','fontsize',12);
        
        axes('position',[ 0.48 0.10  0.5 0.9]);
        %axes('position',[0.5 0.33 0.5 .33]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_sexual_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        xlim([3.4280e+05 3.9398e+05]);
        ylim([5.9896e+06 6.0326e+06]);
        text(0.31,0.95,'HSI (sexual)','Units','Normalized','fontsize',12);
        
        
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 21;
        ySize = 12.5;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        saveas(gcf,[outdir,'HSI_sexual_south_del.png']);
        
        
        
        %%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % WHOLE COORONG PLOTS
        %
        del_axis= [-1 1];
        del_clip= [-0.1 0.1];
        newmap = blank_col(del_axis, del_clip);
        
        %%%%%%%%%%%%%%%%%%''
        hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
        colormap(newmap);
        
        axes('position',[ -0.30 0.0  1.0 1.0]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1_del);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        camroll(-25)
        
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        cb = colorbar('location','South','orientation','horizontal');
        set(cb,'position',[0.05 0.15 0.25 0.01]);
        
        text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
        text(0.35,0.17,['\Delta HSI: ',scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',12);
        
        axes('position',[ -0.18 0.0  1.0 1.0]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        camroll(-25)
        
        text(0.40,0.75,'Flower','Units','Normalized','fontsize',12);
        
        axes('position',[ -0.06 0.0  1.0 1.0]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        camroll(-25)
        
        text(0.41,0.75,'Seed','Units','Normalized','fontsize',12);
        
        axes('position',[ 0.26 0.0  1.0 1.0]);
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_sexual_del);shading flat
        set(gca,'box','on');
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        caxis(del_axis);
        axis equal
        axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
        camroll(-25)
        
        text(0.42,0.95,'HSI (sexual)','Units','Normalized','fontsize',12);
        
        
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 18;
        ySize = 20;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        saveas(gcf,[outdir,'HSI_sexual_del.png']);
        
        %             save([outdir,'HSI_sexual.mat'],'min_cdata','-mat');
        %             export_area([outdir,'HSI_sexual.csv'],min_cdata,Area);
        
    end
end
% close all;

