function data = tfv_process_netcdf_pt(filename,pnt)
% Function to process a tuflow netcdf and output the data at a given point
% for all valid variables, including time in Matlab format.
%
% Written by Brendan Busch 03/12/2012

data = [];

% These variables will be xcreened out of the final output. If one of these
% is required, then remove from this list (or comment)
invalid_vars = {...
    'ResTime';...
    'cell_Nvert';...
    'cell_node';...
    'NL';...
    'idx2';...
    'idx3';...
    'cell_X';...
    'cell_Y';...
    'cell_Zb';...
    'cell_A';...
    'node_X';...
    'node_Y';...
    'node_Zb';...
    'layerface_Z';...
    'stat';...
    'V_x';...
    'V_y';...
    'W';...
    };

% Get time model time output;
nctime = tfv_readnetcdf(filename,'time',1);
mTime = nctime.Time;
clear nctime;

rawGeo = tfv_readnetcdf(filename,'timestep',1);
allvars = tfv_infonetcdf(filename);


% Get valid varnames
int = 1;
for ii = 1:length(allvars)
    if strcmp(allvars{ii},invalid_vars) == 0
        validnames{int} = allvars(ii);
        int = int + 1;
    end
end
disp('Loading netcdf data - It can take awhile');
rawData = tfv_readnetcdf(filename,'names',validnames');
disp('Finished loading netcdf data');

%__________________________________________________________________________

for pp = 1:length(pnt)
    pt_id = pnt(pp);
    for kk = 1:length(validnames)
        varname = cell2mat(validnames{kk});
        
        cellname = ['Cell',num2str(pt_id)];
        
        Cell_3D_IDs = find(rawGeo.idx2==pt_id);
                
        if(length(Cell_3D_IDs) ~= rawGeo.NL(pt_id))
            disp('cell3DiDs ~=NL')
            disp(pt_id)
        end
        
        surfIndex = min(Cell_3D_IDs);
        botIndex = max(Cell_3D_IDs);
        
        
        data.(cellname).(varname).profile = zeros(length(Cell_3D_IDs)+2,size(rawData.(varname),2));
        data.(cellname).(varname).depths  = zeros(length(Cell_3D_IDs)+2,1);
        
        if strcmp(varname(1),'H') == 0
            
            data.(cellname).(varname).surface = rawData.(varname)(surfIndex,:);
            data.(cellname).(varname).bottom  = rawData.(varname)(botIndex,:);
            %data.profile = rawData.(varname)(Cell_3D_IDs,:);
            
            data.(cellname).(varname).profile(1,:) = rawData.(varname)(Cell_3D_IDs(1),:);
            data.(cellname).(varname).profile(2:length(Cell_3D_IDs)+1,:) = rawData.(varname)(Cell_3D_IDs,:);
            data.(cellname).(varname).profile(length(Cell_3D_IDs)+2,:) = rawData.(varname)(Cell_3D_IDs(length(Cell_3D_IDs)),:);
            
            data.(cellname).(varname).depths(1)  = rawGeo.layerface_Z(surfIndex + pt_id - 1);
            for i = 1 : rawGeo.NL(pt_id)
                % mid point of layer
                data.(cellname).(varname).depths(i+1) = (rawGeo.layerface_Z(Cell_3D_IDs(i) + pt_id-1) + rawGeo.layerface_Z(Cell_3D_IDs(i) + pt_id-1 +1))/2.;
            end
            data.(cellname).(varname).depths(length(Cell_3D_IDs)+2)  = rawGeo.layerface_Z(botIndex+pt_id-1+1);
        else
            data.(cellname).(varname).surface = rawData.(varname)(pt_id,:);
            data.(cellname).(varname).bottom  = rawData.(varname)(pt_id,:);
            data.(cellname).(varname).profile = rawData.(varname)(pt_id,:);
            data.(cellname).(varname).depths  = -99.;
        end
        
        data.(cellname).(varname).Time = mTime;
    end
end