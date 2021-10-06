%
% [cell_idx2, coords, chain] = fv_get_curtain_ids(pline,geofil)
%
% pline is an xy matrix of curtain vertex coordinates (Npts,2)
% geofil is the _geo.nc file output by TUFLOW-FV

function [cell_idx2, coords, chain] = fv_get_curtain_ids(pline,geofil)

% Load geometry file
%geo = netcdf_get_var(geofil);

geo = tfv_readnetcdf(geofil)

% Construct curtain line segments
xy1 = [pline(1:end-1,:) pline(2:end,:)];
Nseg = size(xy1,1);

% Construct mesh face line segments
Nface = size(geo.face_ctrd,2);
xy2 = zeros(Nface,4);
node_idx2 = geo.node_idx2(geo.face_vert(1,geo.face_idx3));
xy2(:,1:2) = geo.node_coord(:,node_idx2)';
node_idx2 = geo.node_idx2(geo.face_vert(2,geo.face_idx3));
xy2(:,3:4) = geo.node_coord(:,node_idx2)';

% Calculate intersections
out = lineSegmentIntersect(xy1,xy2);

% Extract face intersections
Nint = sum(sum(out.intAdjacencyMatrix));
face_idx2 = zeros(Nint,1);
coords = zeros(Nint+2,2);
chain = zeros(Nint+2,1);
sumLseg = 0;
n = 1;
for i = 1 : Nseg
    Lseg = sqrt(sum((pline(i+1,:)-pline(i,:)).^2));
    sumLseg = sumLseg + Lseg;
    iface = find(out.intAdjacencyMatrix(i,:));
    Ntmp = length(iface);
    dist = out.intNormalizedDistance1To2(i,iface);
    [dist, itmp] = sort(dist);
    iface = iface(itmp);
    face_idx2(n:n+Ntmp-1) = iface;
    coords(n+1:n+Ntmp,1) = out.intMatrixX(i,iface);
    coords(n+1:n+Ntmp,2) = out.intMatrixY(i,iface);
    dist = dist * Lseg;
    chain(n+1:n+Ntmp) = chain(n+1) + dist;
    chain(n+Ntmp+1) = sumLseg;
    n = n + Ntmp;
end
coords(1,:) = pline(1,:);
coords(end,:) = pline(end,:);

% Find corresponding cells
face_idx3 = geo.face_idx3(face_idx2);
cell_idx2 = zeros(Nint+1,1);
for i = 2 : Nint
    itmp = find(all(...
                [any(geo.cell_faces==face_idx3(i-1));...
                any(geo.cell_faces==face_idx3(i))]...
                ));
    if(~isempty(itmp))
    cell_idx2(i) = geo.cell_idx2(itmp(1));
    else
    cell_idx2(i) = cell_idx2(i-1)+1;
    disp(cell_idx2(i))
    end
end
% First cell
itmp = geo.face_cells(:,face_idx3(1));
itmp = geo.cell_idx2(itmp);
cell_idx2(1) = itmp(itmp~=cell_idx2(2));
% Last cell
%itmp = geo.face_cells(:,face_idx3(end));
%itmp = geo.cell_idx2(itmp);
%cell_idx2(end) = itmp(itmp~=cell_idx2(end-1));
cell_idx2(end) = max(cell_idx2(1:end-1));
