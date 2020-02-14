function [fig] = tfv_plotcurtain(filename,geoname,curtpoints,varargin)

fig = [];
%--% Augument Pairing check
if mod(length(varargin),2) > 0
    
    disp('Additonal Arguments must be in pairs');
    return
    
end

%--% Defaults
timeslice = 1;
varname = 'TEMP';
viewlim = [0 0];
isPlot = false;
for ii = 1:2:length(varargin)
    switch varargin{ii}
        case 'timeslice'
            timeslice = varargin{ii+1};
        case 'variable'
            varname = varargin(ii+1);
        case 'view'
            viewlim = varargin{ii+1};
        case 'isPlot'
            isPlot =  varargin{ii+1};
        otherwise
            disp(['Augument ',varargin{ii},' is not vaild']);
            return
    end
end


%--% Load netcdf Data

data = tfv_readnetcdf(filename,'timestep',timeslice);

geo = tfv_readnetcdf(geoname);
rawpnt = load(curtpoints);

curt(:,1) = rawpnt(:,1);
curt(:,2) = rawpnt(:,2);
%--% Search routine

pt_id = searchnearest(curt,geo);


%--% Load cData

%--% Calulate Grid
gridmesh = calculategrid(data,geo,pt_id,varname);

if strcmp(varname{1},'WQ_AED_OXYGEN_OXY') == 1
     gridmesh.c = gridmesh.c * 32 / 1000;
end


%--% Plot
if ~isPlot
    fig.fg = figure('Position', [1 1 1920 1004],...
        'Renderer','zbuffer','visible','off');
end

fig.ax = patch(gridmesh.x,gridmesh.y,gridmesh.z,gridmesh.c');hold on

view(viewlim);

set(fig.ax,'Edgecolor',[0.8 0.8 0.8],'LineWidth',0.05,'FaceColor','flat');

set(gca,'Color','None',...
    'box','on');

set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit')
%cb = colorbar;

end %--%
%-------------------------------------------------------------------------%
function pt_id = searchnearest(curt,geo)
geo_x = geo.face_ctrd(1,:);
geo_y = geo.face_ctrd(2,:);

dtri = DelaunayTri(geo_x',geo_y');

query_points(:,1) = curt(~isnan(curt(:,1)),1);
query_points(:,2) = curt(~isnan(curt(:,2)),2);

pt_id = nearestNeighbor(dtri,query_points);
end %--%
%-------------------------------------------------------------------------%
function gridmesh = calculategrid(data,geo,pt_id,varname)

%--%
gridmesh = [];

geo_face_idx3 = geo.face_idx3(pt_id);
% Index Number Transfered to cell index number
geo_face_cells(1:2,1:length(geo_face_idx3)) = ...
    geo.face_cells(1:2,geo_face_idx3);

[unique_geo_face_cells_w0,ind] = unique(geo_face_cells(:));
% Get rid of zeros
unique_geo_face_cells = ...
    unique_geo_face_cells_w0(unique_geo_face_cells_w0 ~= 0);

cells_idx2 = geo.cell_idx2(unique_geo_face_cells);

matching.x = geo.cell_ctrd(1,cells_idx2);
matching.y = geo.cell_ctrd(2,cells_idx2);

N = length(cells_idx2);
count = 1;
for n = 1 : (N - 1)
    i2 = cells_idx2(n);
    % Traditionl
    NL = data.NL(i2);
    i3 = data.idx3(i2);
    i3z = i3 + i2 -1;
    %if data.layerface_Z(i3z) ~=0 && data.layerface_Z(i3z + 1) ~=0
        
        xv{count} = repmat([matching.x(count);...
            matching.x(count);...
            matching.x(count+1);...
            matching.x(count+1)],...
            [1 NL]);
        
        yv{count} = repmat([matching.y(count);...
            matching.y(count);...
            matching.y(count+1);...
            matching.y(count+1)],...
            [1 NL]);
        zv{count} = zeros(4,NL);
        for i = 1 : NL
            zv{count}(:,i) = [data.layerface_Z(i3z); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z+1); ...
                data.layerface_Z(i3z)];
            i3z = i3z + 1;
        end
        
        %--% Now for the data
        holding = varname{1};
        cv{count} = data.(holding{1})(i3:i3+NL-1);
        count = count + 1;
    %end
    
end

gridmesh.x = cell2mat(xv);
gridmesh.y = cell2mat(yv);
gridmesh.z = cell2mat(zv);
gridmesh.c = cell2mat(cv');
end %--%
%-------------------------------------------------------------------------%
