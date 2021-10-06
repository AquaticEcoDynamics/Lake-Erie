function [pt_id,geodata,subsample] = tfv_searchnearest(curt,geo)
geo_x = geo.face_ctrd(1,:);
geo_y = geo.face_ctrd(2,:);

dtri = DelaunayTri(geo_x',geo_y');

query_points(:,1) = curt(~isnan(curt(:,1)),1);
query_points(:,2) = curt(~isnan(curt(:,2)),2);

pt_id = nearestNeighbor(dtri,query_points);

geo_face_idx3 = geo.face_idx3(pt_id);
% Index Number Transfered to cell index number
geo_face_cells(1:2,1:length(geo_face_idx3)) = ...
    geo.face_cells(1:2,geo_face_idx3);

[unique_geo_face_cells_w0,ind] = unique(geo_face_cells(:));
unique_geo_face_cells = ...
    unique_geo_face_cells_w0(unique_geo_face_cells_w0 ~= 0);
cells_idx2 = geo.cell_idx2(unique_geo_face_cells(1:end-1));

subsample = cells_idx2(1:4:length(cells_idx2));

geodata.X  = geo.cell_ctrd(1,subsample);
geodata.Y = geo.cell_ctrd(2,subsample);
geodata.Z = geo.cell_Zb(subsample);


end %--%