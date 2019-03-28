function [fig] = tfv_plotsheet(filename,varargin)
% Function to plot a sheet image from a TuflowFV netcdf
%
% Usage: fig = tfv_plotsheet(filename,varargin)
%
% Name Value Pair Keywords....
% * variable
% * timeslice
%-------------------------------------------------------------------------%

%--% Augument Pairing check
if mod(length(varargin),2) > 0
    
    disp('Additonal Arguments must be in pairs');
    return
    
end

%--% Defaults
timeslice = 1;
varname = 'TEMP';
isPlot = false;
for ii = 1:2:length(varargin)
    switch varargin{ii}
        case 'timeslice'
            timeslice = varargin{ii+1};
        case 'variable'
            varname = varargin(ii+1);
        case 'isPlot'
            isPlot = varargin{ii+1};
        otherwise
            disp(['Augument ',varargin{ii},' is not vaild']);
            return
    end
end

%--% Load netcdf Data

data = tfv_readnetcdf(filename,'timestep',timeslice);


%--% Build the bathymetry

vert(:,1) = data.node_X;
vert(:,2) = data.node_Y;

faces = data.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

%--% Now for the data
holding = varname{1};
if strcmp(holding{1},'H') == 0
    cdata = data.(holding{1})(data.idx3(data.idx3 > 0));
else
    cdata = data.(holding{1});
end

if ~isPlot
    
    fig.fg = figure(...
        'Renderer','zbuffer',...
        'visible','on');
end


fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat

axis equal

set(gca,'Color','None',...
    'box','on');

set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit');

%colorbar
