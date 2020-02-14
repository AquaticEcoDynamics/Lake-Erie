function [bathdata] = smoothTUFLOWbathy(filename,n_smth)
% function [bathdata] = smoothTUFLOWbathy(filename,n_smth)
%
% Inputs:
%		filename   : filename of bathymetry file
% Outputs
%		bathdata : a matlab structure that contains all the data in the file
%         as well as the smoothed version
%       n_smth : number of smoothing loops
%
% Uses:
%		pcolor.m
%
% Written by L. Bruce 28 May 2012
%The purpose is to take an exising tuflow bathymetry file and smooth the
%nodes in order to run better.
%Algorithm takes each node and averages based on all connecting nodes in
%each cell that contains that node

% Extract data from netcdf file
bathdata = tfv_readmesh(filename);

%Original bathymetry
x_node = bathdata.ND(:,1);
y_node = bathdata.ND(:,2);
z_node = bathdata.ND(:,3);
z_node_org = z_node;


%Loop through n_smth times
for nn = 1:n_smth
%Loop through nodes and make each node equal to the average of connecting
%nodes
for node_i = 1:length(z_node)
    %find cells that the node is connected to
    for ii = 1:4
       cell_i{ii} = find(bathdata.face(:,ii) == node_i);
    end
    %calculate average for each cell
    jj = 1;
    for ii = 1:4
        if ~isempty(cell_i{ii})
            for kk = 1:length(cell_i{ii})
                node_ave(jj) = mean(z_node(bathdata.face(cell_i{ii}(kk),1:4)));
                jj = jj + 1;
            end
        end
    end
    z_node_smth(node_i) = mean(node_ave);
    clear cell_i
    clear node_ave
end
z_node = z_node_smth;
end

%Calculate maximum depths
for ii=1:floor(length(z_node)/10)
   z_node_max(1+(ii-1)*10:10*ii) = min(z_node_org(1+(ii-1)*10:10*ii));
   z_node_smth_max(1+(ii-1)*10:10*ii) = min(z_node_smth(1+(ii-1)*10:10*ii));
end

%Plot original against smoothed z data
plot(z_node_org,'b')
hold on
plot(z_node_smth,'r')
plot(z_node_max,'g')
plot(z_node_smth_max,'k')
hold off

%Save node data as a tuflow space delimited file
%Keep mesh data, node string data and configuration data as the same
smthfilename = [filename(1:end-4) '_smth' num2str(n_smth) filename(end-3:end)];
fid = fopen(smthfilename,'w');
fid_org = fopen(filename,'r');

%First print header and mesh node information
while 1
    tline = fgetl(fid_org);
    if strncmp(tline,'ND',2), break, end
       fprintf(fid,'%s\n',tline);
     
end
     
%Ignore original node lines
while 1
    tline = fgetl(fid_org);
    if ~strncmp(tline,'ND',2), break, end
     
end

%Print out new smoothed node lines
for node_i = 1:length(z_node)
    fprintf(fid, '%s %u %1.8e %1.8e %1.8e\n','ND',node_i,x_node(node_i),y_node(node_i),z_node_smth(node_i)-0.05);
end

%Print out remaining lines
fprintf(fid,'%s\n',tline);
while 1
    tline = fgetl(fid_org);
    if ~ischar(tline), break, end
       fprintf(fid,'%s\n',tline);
     
end

%Close files
fclose(fid);
fclose(fid_org);

bathdata.z_node_smth = z_node_smth;
bathdata.z_node = z_node;
bathdata.z_node_smth_max = z_node_smth_max;
bathdata.z_node_max = z_node_max;