function data = tfv_getmodeldatalocation(filename,rawData,X,Y,varname)
%--% Function to load the tuflowFV model output at a specified location
% (X,Y).
% Usage: H = H = getmodeldatalocation(filename,X,Y,varname)

%rawData = tfv_readnetcdf(filename,'names',varname);
rawGeo = tfv_readnetcdf(filename,'timestep',1);

%--% Search
pnt(1,1) = X;
pnt(1,2) = Y;

geo_x = double(rawGeo.cell_X);
geo_y = double(rawGeo.cell_Y);
dtri = DelaunayTri(geo_x,geo_y);


pt_id = nearestNeighbor(dtri,pnt);

Cell_3D_IDs = find(rawGeo.idx2==pt_id);

%disp(rawGeo.NL(pt_id));

if(length(Cell_3D_IDs) ~= rawGeo.NL(pt_id))
    %disp('cell3DiDs ~=NL');
    %disp(pt_id);
end

surfIndex = min(Cell_3D_IDs);
botIndex = max(Cell_3D_IDs);

%surfIndex = rawGeo.idx3(pt_id);
%botIndex = rawGeo.idx3(pt_id) + (rawGeo.NL(pt_id) -1);
%pointIndex = surfIndex:botIndex;

data.profile = zeros(length(Cell_3D_IDs)+2,size(rawData.(varname{1}),2));
data.depths  = zeros(length(Cell_3D_IDs)+2,1);

if strcmp(varname{1},'H') == 0
    
    data.surface = rawData.(varname{1})(surfIndex,:);
    data.bottom  = rawData.(varname{1})(botIndex,:);
    %data.profile = rawData.(varname{1})(Cell_3D_IDs,:);
    
    data.profile(1,:) = rawData.(varname{1})(Cell_3D_IDs(1),:);
    data.profile(2:length(Cell_3D_IDs)+1,:) = rawData.(varname{1})(Cell_3D_IDs,:);
    data.profile(length(Cell_3D_IDs)+2,:) = rawData.(varname{1})(Cell_3D_IDs(length(Cell_3D_IDs)),:);

    data.depths(1)  = rawGeo.layerface_Z(surfIndex + pt_id - 1);
    for i = 1 : rawGeo.NL(pt_id)
      % mid point of layer  
      data.depths(i+1) = (rawGeo.layerface_Z(Cell_3D_IDs(i) + pt_id-1) + rawGeo.layerface_Z(Cell_3D_IDs(i) + pt_id-1 +1))/2.;
    end
    data.depths(length(Cell_3D_IDs)+2)  = rawGeo.layerface_Z(botIndex+pt_id-1+1);    
    
    %disp(rawGeo.layerface_Z((surfIndex + pt_id - 1 ): (botIndex + pt_id + 10 )));
    
    %disp('n');
    
    %disp(data.depths);
    
   
   
else
    data.surface = rawData.(varname{1})(pt_id,:);
    data.bottom  = rawData.(varname{1})(pt_id,:);
    data.profile = rawData.(varname{1})(pt_id,:);
    data.depths  = -99.;

end

controlfile = regexprep(filename,{'Output'},'Input');
controlfile = regexprep(controlfile,{'nc'},'fvc');

cont = tfv_readfvc(controlfile);
data.date = cont.netcdf.Interval(1:length(data.surface));
% dat = tfv_readnetcdf(filename,'time',1);
% data.date = dat.Time;
%--%