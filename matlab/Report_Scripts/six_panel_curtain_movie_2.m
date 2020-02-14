clear all; close all;

addpath(genpath('tuflowfv'));

ncfile = 'D:\Studysites\Erie\Simulations\20160602_Erie_2013_WSnetcdf_AED2\Output\erie__AED.nc';
geofile = 'D:\Studysites\Erie\Simulations\20160602_Erie_2013_WSnetcdf_AED2\Input\log\erie_geo.nc';
linefile = 'GIS/erie_1.xy';

ylimit = [-70 1.5];
xlimit = [0 45];

frames_per_second = 12;


outdir = 'E:\Dropbox\AED_LakeErie\TFV\20160602_Erie_2013_WSnetcdf_AED2\';

   if ~exist(outdir,'dir')
        mkdir(outdir);
    end

   if ~exist(outdir,'dir')
        mkdir(outdir);
   end
   
   sim_name = [outdir,'ERIE_2.mp4'];
   
 hvid = VideoWriter(sim_name,'MPEG-4');
    set(hvid,'Quality',100);
    set(hvid,'FrameRate',12);
    framepar.resolution = [1024,768];
    
    open(hvid);

%__________________________________________________________________________

line = load(linefile);


dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

geo = tfv_readnetcdf(geofile);
[pt_id,geodata,cells_idx2] = tfv_searchnearest(line,geo);

sXX = geodata.X(1:end);
sYY = geodata.Y(1:end);


curt.dist(1:length(geodata.X)) = 0;
for ii = 1:length(geodata.X)-1
    temp_d = sqrt((sXX(ii+1)-sXX(ii)) .^2 + (sYY(ii+1) - sYY(ii)).^2);
    curt.dist(ii+1) = curt.dist(ii) + temp_d;
end

DX(:,1) = sXX;
DX(:,2) = sYY;
curt.base = geodata.Z;


inc = 1;

% Bathymetry Fills
fillX = [min(curt.dist /1000) sort(curt.dist /1000) max(curt.dist /1000)];
fillY =[-70;curt.base;-70];


[~,TL2] =  min(abs(timesteps - datenum(2008,02,10,12,00,00)));

for TL = 1:4:length(timesteps)
    
    data = tfv_readnetcdf(ncfile,'timestep',TL);
    data2 = tfv_readnetcdf(regexprep(ncfile,'_AED.nc','_tfv.nc'),'timestep',TL);
    clear functions
    %
    % Build Patch Grid_________________________________________________
    N = length(geodata.X);
    
    for n = 1 : (N - 1)
        i2 = cells_idx2(n);
        % Traditionl
        NL = data.NL(i2);
        i3 = data.idx3(i2);
        i3z = i3 + i2 -1;
        
        xv{n} = repmat([curt.dist(n);...
            curt.dist(n);...
            curt.dist(n+1);...
            curt.dist(n+1)],...
            [1 NL]);
        
        zv{n} = zeros(4,NL);
        for i = 1 : NL
            zv{n}(:,i) = [data.layerface_Z(i3z); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z)];
            i3z = i3z + 1;
        end
        
        SAL{n} = data.WQ_OXY_OXY(i3:i3+NL-1);
        DO{n} = data2.TEMP(i3:i3+NL-1);
        TCHLA{n} = data.WQ_PHS_FRP(i3:i3+NL-1);
        NIT{n} = data.WQ_NIT_NIT(i3:i3+NL-1);
        AMM{n} = data.WQ_NIT_AMM(i3:i3+NL-1);
        FRP{n} = data.WQ_SIL_RSI(i3:i3+NL-1);
        
    end
    if inc == 1
        model.x = cell2mat(xv);
        model.z = cell2mat(zv);
    end
    % Add the conversions
    model.SAL = cell2mat(SAL')* 32 / 1000;
    model.DO = cell2mat(DO');%* 32 / 1000;
    model.TCHLA = cell2mat(TCHLA');
    model.NIT = cell2mat(NIT');
    model.AMM = cell2mat(AMM');
    model.FRP = cell2mat(FRP');
    
    
    
    
    
    % Now the plot.......
    hfig = figure('position',[47 54 1768 917],'color','k');

    axes('position',[0.075 0.05 0.4 0.3],'color','k'); % Bottom Left
    
    P1 = patch(model.x /1000,model.z,model.AMM','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %%xlim(xlimit);
    ylim(ylimit);
    %xlabel('Distance from Niagara (km)','fontsize',12,'FontWeight','bold','color','w');
    ylabel('Depth (mAHD)','fontsize',12,'FontWeight','bold','color','w');
    set(gca,'YColor','w','XColor','w','box','on');
    text(0.05,0.1,'Ammonium','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    
    caxis([0 30]);
    
    cb = colorbar;
    
    set(cb,'position',[0.485 0.07 0.01 0.25],'YColor','w');
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 6','color','w','fontsize',8);
    
    
    
    axes('position',[0.55 0.05 0.4 0.3],'color','k'); % Bottom Right
    
    P2 = patch(model.x /1000,model.z,model.FRP','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %xlim(xlimit);
    ylim(ylimit);
    
    set(gca,'YColor','w','XColor','w','box','on');
    text(0.05,0.1,'Silica','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    %xlabel('Distance from Niagara (km)','fontsize',12,'FontWeight','bold','color','w');

    
    caxis([0 400]);
    
    cb = colorbar;
    
    set(cb,'position',[0.96 0.07 0.01 0.25],'YColor','w')
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 7','color','w','fontsize',8);
    
    
    axes('position',[0.075 0.35 0.4 0.3],'color','k'); % Middle Left
    
    P3 = patch(model.x /1000,model.z,model.TCHLA','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %xlim(xlimit);
    ylim(ylimit);
        ylabel('Depth (mAHD)','fontsize',12,'FontWeight','bold','color','w');

    set(gca,'YColor','w','XColor','w','box','on','XtickLabel',[]);
    text(0.05,0.1,'Phosphate','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    
    caxis([0 5]);
    
    cb = colorbar;
    
    set(cb,'position',[0.485 0.37 0.01 0.25],'YColor','w')
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 4','color','w','fontsize',8);
    
    axes('position',[0.55 0.35 0.4 0.3],'color','k'); % Middle Right
    
    P4 = patch(model.x /1000,model.z,model.NIT','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %xlim(xlimit);
    ylim(ylimit);
    
    set(gca,'YColor','w','XColor','w','box','on','XtickLabel',[]);
    text(0.05,0.1,'Nitrate','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    caxis([0 50]);
    cb = colorbar;
    set(cb,'position',[0.96 0.37 0.01 0.25],'YColor','w')
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 5','color','w','fontsize',8);
    
    
    axes('position',[0.075 0.65 0.4 0.3],'color','k'); % Top Left
    
    P5 = patch(model.x /1000,model.z,model.SAL','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %xlim(xlimit);
    ylim(ylimit);
    
    set(gca,'YColor','w','XColor','w','box','on','XtickLabel',[]);
    text(0.05,0.1,'Oxygen','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    
    text(0.05,1.05,datestr(timesteps(TL),'dd-mm-yyyy HH:MM:SS'),'FontSize',15,'color','w','units','Normalized','FontWeight','bold');
    ylabel('Depth (mAHD)','fontsize',12,'FontWeight','bold','color','w');

    
    
    caxis([0 16]);
    cb = colorbar;
    set(cb,'position',[0.485 0.67 0.01 0.25],'YColor','w')
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 2','color','w','fontsize',8);
    
    axes('position',[0.55 0.65 0.4 0.3],'color','k'); % Top Right
    
    P6 = patch(model.x /1000,model.z,model.DO','edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    %xlim(xlimit);
    ylim(ylimit);
    
    set(gca,'YColor','w','XColor','w','box','on','XtickLabel',[]);
    
    text(0.05,0.1,'Temperature','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    
    caxis([5 25]);
    
    cb = colorbar;
    set(cb,'position',[0.96 0.67 0.01 0.25],'YColor','w')
    colorTitleHandle = get(cb,'Title');
    %set(colorTitleHandle ,'String','TRC 3','color','w','fontsize',8);
    
%     mm.frames(inc)=getframe(gcf);
%     mm.times(inc) = inc/frames_per_second;
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');

    set(gcf,'paperposition',[0 0 40 25])
    
    set(gcf,'inverthardcopy','off')
    
    
    %print(gcf,'-dpng',[outdir,'Sheet_',num2str(inc),'.png'],'-opengl');
    inc = inc + 1;
    
        writeVideo(hvid,getframe(hfig));

    close
end
      close(hvid);

%  mm.width=size(mm.frames(1).cdata,2);
%     mm.height=size(mm.frames(1).cdata,1);
%     
%     mm.videoQuality = 20;
%     
%     mm.videoCompressor = 'ffdshow video encoder';
%     %mmwrite([name,'\',varname,'.avi'],mm);
%     mmwrite(['6Panel_Full.avi'],mm);
%     infile = ['6Panel_Full.avi'];
%     outfile = ['6Panel_Full.mp4'];
%     
%     eval(['!HandBrakeCLI.exe -i ',infile,' -o ',outfile]);
%     
%     delete(infile);
%     copyfile(outfile,[outdir,'6Panel_Full.mp4']);
%     delete(outfile);
