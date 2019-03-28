clear all;
%close all;

addpath(genpath('Functions'));
%addpath(genpath('matfiles_for_Brendan_plot'));


%shp = shaperead('Images/House.shp');


ncfile = 'D:\Studysites\Erie\Simulations\tfv_erie_v1_oxy_trc1\Output\erie.nc';%Output\

varname = 'WQ_TRC_SS1';

image = 'Images/LE1.png';

dry_cell_val = 0.045;

CAX = [0 2];

color_title = '';

movie_title = 'Detroit River Tracer';

movie_name = 'sim_v1';

frames_per_second = 12;

% % % % Top Plot stuff
% % % top_plot_title = 'Rainfall';
% % % t_xdata = rain.ISOTime;
% % % t_ydata = rain.Precip*1000;
% % % t_xlab = 'Date';
% % % t_ylab = 'Rainfall (mm/day)';
% % % 
% % % % Bottom Plot stuff
% % % bottom_plot_title = '* G1 Field';
% % % bottom_plot_title_1 = '-- G1 Model';
% % % 
% % % b_xdata = G1_level(:,1);
% % % b_ydata = G1_level(:,2)-17.08;
% % % b_xlab = 'Date';
% % % b_ylab = 'Depth (m)';
% % % 
% % % b1_xdata = sim.H.G119.date;
% % % b1_ydata = sim.H.G119.surface - (min(sim.H.G119.surface));


%__________________________________________________________________________
dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

data = tfv_readnetcdf(ncfile,'timestep',1);


% Ticks

xtik = min(timesteps): (max(timesteps) - min(timesteps))/5:max(timesteps);

%--% Build the bathymetry

vert(:,1) = data.node_X;
vert(:,2) = data.node_Y;

faces = data.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

% XX = shp.X(1:end-1);
% YY = shp.Y(1:end-1);
% 
% house_id = inpolygon(data.cell_X,data.cell_Y,XX,YY);
% 
% no_house = find(house_id>0);

surf_ind = data.idx3;



clear data

[XImage,map] = imread(image);
R =  worldfileread(regexprep(image,'png','pgw'));
%%
%__________________________________________________________________________
first_plot = 1;

inc = 1;

for i = 1:1:length(timesteps)%2006%
    
    data = tfv_readnetcdf(ncfile,'timestep',i);
    
    if strcmpi(varname,'H') == 0
        cdata = data.(varname)(surf_ind(surf_ind > 0));
        
        
    else
        cdata = data.(varname) - data.cell_Zb;
        
    end
    
    dry_cells = data.H - data.cell_Zb;
    
    cdata(dry_cells < dry_cell_val) = NaN;
    
    %cdata(no_house) = NaN;
    
    figure('color','k','visible','on','position',[115          72        1720         918]);
    
    axes('position',[0 0 0.7 1])
    
    [HH,imMap] = plotimage1surf(XImage,R,'2d');
    hold on
    freezeColors
    
    axis equal
    
    colormap(jet);
    
    fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat;hold on
    
    caxis(CAX);
    
    
    
    cb = colorbar;
    set(cb,'position',[0.715 0.02 0.01 0.3],...
        'units','normalized','ycolor','w');
    colorTitleHandle = get(cb,'Title');
    titleString = color_title;
    set(colorTitleHandle ,'String',titleString,'color','w','fontsize',10);
    
    text(1.08,0.3,'Lake Erie',...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',24,'color','w');
    
    text(1.08,0.2,movie_title,...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',20,'color','w');
    
    
    text(1.08,0.1,datestr(timesteps(i),'dd/mm/yyyy'),...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',20,'color','w');
    
    xlim([275921.466072442          678975.697421754]);
    ylim([4512857.54965632          4820169.66292764]);
    
   % scatter(408801.4383, 6486245.496, 'wO','SizeData',100,'markerfacecolor','w');hold on;
   % text(408801.4383-50,6486245.496+50,'Gauge G1','Fontname','Candara','fontweight','bold','Fontsize',20,'color','w');
    %______________________________________________________________________
    % Top Plot
    axes('position',[0.73,0.7,0.25,0.25])
    
%     bar(t_xdata,t_ydata,'w');hold on
%     
%     plot([timesteps(i) timesteps(i)],[min(t_ydata) max(t_ydata)],'--r');
%     
%     xlim([min(xtik) max(xtik)]);
%     
%     set(gca,'XTick',xtik,'XTickLabel',datestr(xtik,'dd-mm'),'fontsize',10);
%     
%     xlabel(t_xlab,'color','w','fontsize',12);
%     ylabel(t_ylab,'color','w','fontsize',12);
%     
%     text(0.8,0.9,top_plot_title,'fontsize',14,'color','w','units','normalized');
%     set(gca,'color','k','box','off');
%     
%     set(gca,'YColor','w','XColor','w','box','off');
%     
%     
%     % bottom Plot
%     axes('position',[0.73,0.4,0.25,0.25])
%     set(gca,'YColor','w','XColor','w','box','on');
%     
%     
%     plot(b_xdata,b_ydata,'*w');hold on
%     %plot(b1_xdata,b1_ydata,'--w');hold on
%     
%     ss = find(b1_xdata < timesteps(i));
%     plot(b1_xdata(ss),b1_ydata(ss),'--w');hold on
% 
%     
%     plot([timesteps(i) timesteps(i)],[min(b_ydata) max(b_ydata)],'--r');
%     
%     xlim([min(xtik) max(xtik)]);
%     
%     set(gca,'XTick',xtik,'XTickLabel',datestr(xtik,'dd-mm'),'fontsize',10);
%     
%     xlabel(b_xlab,'color','w','fontsize',12);
%     ylabel(b_ylab,'color','w','fontsize',12);
%     
%     text(0.98,0.9,bottom_plot_title,'fontsize',12,'color','w','units','normalized','horizontalAlignment','right');
%     text(0.98,0.8,bottom_plot_title_1,'fontsize',12,'color','w','units','normalized','horizontalAlignment','right');
%    
%     set(gca,'YColor','w','XColor','w','box','on');
%     
%     set(gca,'color','k','box','off');
    
    
    mm.frames(inc)=getframe(gcf);
    mm.times(inc) = inc/frames_per_second;
    
    
    inc = inc + 1;
    
    close
end
%%
mm.width=size(mm.frames(1).cdata,2);
mm.height=size(mm.frames(1).cdata,1);

mm.videoQuality = 20;

mm.videoCompressor = 'ffdshow video encoder';
%mmwrite([name,'\',varname,'.avi'],mm);
mmwrite([movie_name,'.avi'],mm);
infile = [movie_name,'.avi'];
outfile = [movie_name,'.mp4'];

eval(['!HandBrakeCLI.exe -i ',infile,' -o ',outfile]);

delete(infile);
%copyfile(outfile),[outdir,'6Panel_Full.mp4']);
%delete(outfile);


