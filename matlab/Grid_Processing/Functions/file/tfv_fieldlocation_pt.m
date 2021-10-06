function fieldloc = tfv_fieldlocation_pt(filename,fielddata)
% Function to get the cell ID of the fielddata locations as found in the
% standard fielddata.mat file
% Written by Brendan Busch 03/12/2012

fieldloc = [];

sites = fieldnames(fielddata);
rawGeo = tfv_readnetcdf(filename,'timestep',1);

for ii = 1:length(sites)
    vars = fieldnames(fielddata.(sites{ii}));
    
    fieldloc.(sites{ii}).X = fielddata.(sites{ii}).(vars{1}).X;
    fieldloc.(sites{ii}).Y = fielddata.(sites{ii}).(vars{1}).Y;
    fieldloc.(sites{ii}).Name = fielddata.(sites{ii}).(vars{1}).Title;
    
    pnt(1,1) = fieldloc.(sites{ii}).X;
    pnt(1,2) = fieldloc.(sites{ii}).Y;

geo_x = double(rawGeo.cell_X);
geo_y = double(rawGeo.cell_Y);
dtri = DelaunayTri(geo_x,geo_y);

pt_id = nearestNeighbor(dtri,pnt);
fieldloc.(sites{ii}).cell_id = pt_id;

fieldloc.(sites{ii}).cell_3D_id = find(rawGeo.idx2==pt_id);
fieldloc.(sites{ii}).surfIndex = min(fieldloc.(sites{ii}).cell_3D_id);
fieldloc.(sites{ii}).botIndex = max(fieldloc.(sites{ii}).cell_3D_id);
    
    
end




%--% Search
