clear all;
%close all;

addpath(genpath('Functions'));
%addpath(genpath('matfiles_for_Brendan_plot'));


%shp = shaperead('Images/House.shp');


ncfile = 'D:\Studysites\Erie\Simulations\tfv_erie_v1_oxy_trc1\Output\erie.nc';
geofile = 'D:\Studysites\Erie\Simulations\tfv_erie_v1_oxy_trc1\Input\log\erie_geo.nc';
linefile1 = 'GIS\Erie_1.xy';
linefile2 = 'GIS\Detroit.xy';




varname = 'WQ_OXY_OXY';

image = 'Images/LE1.png';

dry_cell_val = 0.045;

CAX = [2 15];

color_title = '';

movie_title = 'Oxygen (mg/L)';

movie_name = 'sim_v1_OXY';

frames_per_second = 22;

line = load(linefile1);
line2 = load(linefile2);

conv = 32/1000;

%__________________________________________________________________________
dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

data = tfv_readnetcdf(ncfile,'timestep',1);

geo = tfv_readnetcdf(geofile);

% Lake Erie________________________________________________________________

ylimit = [-65 1.5];
xlimit = [0 400];

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

% Bathymetry Fills
fillX = [min(curt.dist /1000) sort(curt.dist /1000) max(curt.dist /1000)];
fillY =[-70;curt.base;-70];

% St Clair________________________________________________________________
% 
% ylimit1 = [-9 1.5];
% xlimit1 = [0 40];
% 
% [pt_id_1,geodata_1,cells_idx2_1] = tfv_searchnearest(line2,geo);
% 
% sXX1 = geodata_1.X(1:end);
% sYY1 = geodata_1.Y(1:end);
% 
% 
% curt_1.dist(1:length(geodata_1.X)) = 0;
% for ii = 1:length(geodata_1.X)-1
%     temp_d = sqrt((sXX1(ii+1)-sXX1(ii)) .^2 + (sYY1(ii+1) - sYY1(ii)).^2);
%     curt_1.dist(ii+1) = curt_1.dist(ii) + temp_d;
% end
% 
% DX_1(:,1) = sXX1;
% DX_1(:,2) = sYY1;
% curt_1.base = geodata_1.Z;
% 
% 
% % Bathymetry Fills
% fillX1 = [min(curt_1.dist /1000) sort(curt_1.dist /1000) max(curt_1.dist /1000)];
% fillY1 =[-15;curt_1.base;-15];
% 



inc = 1;



%_________________________________________________________________________

% Ticks

xtik = min(timesteps): (max(timesteps) - min(timesteps))/5:max(timesteps);

%--% Build the bathymetry

vert(:,1) = data.node_X;
vert(:,2) = data.node_Y;

faces = data.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);


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
    clear functions

    if strcmpi(varname,'H') == 0
        cdata = data.(varname)(surf_ind(surf_ind > 0));
        
        
    else
        cdata = data.(varname) - data.cell_Zb;
        
    end
    
    dry_cells = data.H - data.cell_Zb;
    
    cdata(dry_cells < dry_cell_val) = NaN;
    
    %cdata(no_house) = NaN;
    %______________________________________________________________________
    
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
        for n1 = 1 : NL
            zv{n}(:,n1) = [data.layerface_Z(i3z); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z)];
            i3z = i3z + 1;
        end
        
        val{n} = data.(varname)(i3:i3+NL-1);
    
    end
    model.x = cell2mat(xv);
    model.z = cell2mat(zv);
    model.c = cell2mat(val');

    %______________________________________________________________________
    
% 
    
    
    
    if first_plot == 1
    
    
    figure('color','k','visible','on','position',[115    72   844   918]);
    
    
    axes('position',[0 0.3 1 0.7])
    
    [HH,imMap] = plotimage1surf(XImage,R,'2d');
    hold on
    freezeColors
    
    axis equal
    
    colormap(flipud(jet));
    
    fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata .* conv);shading flat;hold on
    
    caxis(CAX);
    
    
    
    cb = colorbar;
    set(cb,'position',[0.9 0.35 0.01 0.3],...
        'units','normalized','ycolor','w');
    colorTitleHandle = get(cb,'Title');
    titleString = color_title;
    set(colorTitleHandle ,'String',titleString,'color','w','fontsize',10);
    
    text(0.05,0.9,'Lake Erie',...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',24,'color','w');
%     
    text(0.82,0.53,movie_title,...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',16,'color','w');
%     
%     
    tx1 = text(0.05,0.1,datestr(timesteps(i),'dd/mm/yyyy'),...
        'Units','Normalized',...
        'Fontname','Candara','fontweight','bold',...
        'Fontsize',20,'color','w');
    
    xlim([275921.466072442          678975.697421754]);
    ylim([4512857.54965632          4820169.66292764]);
    
    
   % scatter(408801.4383, 6486245.496, 'wO','SizeData',100,'markerfacecolor','w');hold on;
   % text(408801.4383-50,6486245.496+50,'Gauge G1','Fontname','Candara','fontweight','bold','Fontsize',20,'color','w');
    %______________________________________________________________________
    % Top Plot
    axes('position',[0.03,0.05,0.95,0.24])
    
    P1 = patch(model.x /1000,model.z,model.c'  .* conv,'edgecolor','none');hold on
    F1 = fill(fillX,fillY,[0.6 0.6 0.6]);
    
    xlim(xlimit);
    ylim(ylimit);
    xlabel('Distance from Detroit River (km)','fontsize',12,'FontWeight','bold','color','w');
    ylabel('Depth (m)','fontsize',12,'FontWeight','bold','color','w');
    set(gca,'YColor','w','XColor','w','box','on');
    text(0.035,0.1,'Depth (m)','Color','w','units','normalized','fontsize',16,'FontWeight','bold');
    
    caxis(CAX);
     
%     first_plot = 0;
%     else
%         
%       set(fig.ax,'FaceVertexCData',cdata .* conv); 
%       set(P1,'CData',model.c'  .* conv);
%       set(tx1,'String',datestr(timesteps(i),'dd/mm/yyyy'));
    end
      
    
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


