function tfv_save_bottom_var_cells(ncfile,varname,savename)
% Simple function to process a tuflowfv netcdf file and save the relevent
% data for the bottom cells in a mat file for future use.

% Get time data

dat = tfv_readnetcdf(ncfile,'time',1);
proc.Time = dat.Time;
data = tfv_readnetcdf(ncfile,'names',varname);

info = tfv_readnetcdf(ncfile,'timestep',1);

for ii = 1:length(proc.Time)
    
    for jj = 1:length(info.idx3)
        
        proc.bottom(jj,ii) = data.(varname)(info.idx3(jj) + (info.NL(jj)-1),ii);
        
    end
end

proc.vert(:,1) = info.node_X;
proc.vert(:,2) = info.node_Y;
proc.faces = info.cell_node';
proc.faces(proc.faces(:,4)== 0,4) = proc.faces(proc.faces(:,4)== 0,1);
proc.cellarea = info.cell_A;
proc.X = info.cell_X;
proc.Y = info.cell_Y;

proc.bottom = proc.bottom * 32 / 1000;

proc.bottom(proc.bottom < 2) = -1;
proc.bottom(proc.bottom >= 2 & proc.bottom < 4) = 0;
proc.bottom(proc.bottom >=4 & proc.bottom <= 6) = 999;
proc.bottom(proc.bottom > 6) = 1;



save(savename,'proc','-mat');