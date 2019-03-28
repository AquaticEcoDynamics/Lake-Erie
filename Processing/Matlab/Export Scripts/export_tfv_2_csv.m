function export_tfv_2_csv

% Very simple version of tfv_export for surface data only

ncfile = 'V:\Busch\Studysites\Swan\Simulations\Swan Flood Modelling\Swan_2017_Flood_Event_v2\Output\swan.nc';

outdir = 'Example_Output/export_tfv_2_csv_Flood/';

shp(1).X = 391366.25;
shp(1).Y = 6463072.05;
shp(1).Name = 'Narrows';
 
shp(2).X = 401953.32;
shp(2).Y = 6469699.15;
shp(2).Name = 'Helena';

shp(3).X = 401603.56;
shp(3).Y = 6470767.98;
shp(3).Name = 'Guildford';


vars = {...
'H',...
'TEMP',...
'SAL',...
};


%_______________________________________

if ~exist(outdir,'dir')
    mkdir(outdir);
end

rawGeo = tfv_readnetcdf(ncfile,'timestep',1);

geo_x = double(rawGeo.cell_X);
geo_y = double(rawGeo.cell_Y);
dtri = DelaunayTri(geo_x,geo_y);


for i = 1:length(shp)
    
    files.(['fid',num2str(i)]) = fopen([outdir,shp(i).Name,'.csv'],'wt');
    
    pnt(1,1) = shp(i).X;
    pnt(1,2) = shp(i).Y;
    
    temp = nearestNeighbor(dtri,pnt);
    
    temp2 = find(rawGeo.idx2==temp);
    pnt_id(i) = max(temp2);
    
end

fids = fieldnames(files);

for i = 1:length(fids)
    fprintf(files.(fids{i}),'Time,');
    for j = 1:length(vars)
        fprintf(files.(fids{i}),'%s,',vars{j});
    end
    fprintf(files.(fids{i}),'%i',pnt_id(i) );
    fprintf(files.(fids{i}),'\n');
end

dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

clear dat

for i = 1:1:length(timesteps)
    
    data = tfv_readnetcdf(ncfile,'timestep',i);

    for j = 1:length(fids)
        
        fprintf(files.(fids{j}),'%s,',datestr(timesteps(i),'dd/mm/yyyy HH:MM:SS'));
        
        for k = 1:length(vars)
            pdata = data.(vars{k})(pnt_id(j));
            
            fprintf(files.(fids{j}),'%d,',pdata);
            
        end
        fprintf(files.(fids{j}),'\n');
        
    end

end

fclose all;

clear all;

close all;

end
%-------------------------------------------------------------------------%
function [data,ncid] = tfv_readnetcdf(filename,varargin)
% Function to perform several basic netcdf data import tasks.
%
% Based upon the fantastic 'netcdf_get_var.m' from WBM, this function makes
% some slight midifications to the code, as well as alters some variable
% names to conform to the standard used throughout these function.

% data = tfv_readnetcdf(filename)
% data = tfv_readnetcdf(filename,'names',names)
% data = tfv_readnetcdf(filename,'timestep',tstep)
% data = tfv_readnetcdf(filename,'names',names,'timestep',tstep)
% data = tfv_readnetcdf(filename,'timeseries',PointIds)
% data = tfv_readnetcdf(filename,'names',names,'timeseries',PointIds)
%
%-------------------------------------------------------------------------%


data = struct();

% Deal with variable arguments
names = {};
tstep = [];
timeseries = false;
isTime = false;
pointids = [];
Npts = [];
info = {};
if mod(nargin-1,2)>0
    errormessage('error1');
end
for i = 1 : 2 : nargin-1
    varargtyp{i} = varargin{i};
    varargval{i} = varargin{i+1};
    switch varargtyp{i}
        case 'names'
            names = [varargval{i};{'ResTime'}];
        case 'timestep'
            if timeseries
                errormessage('error2');
            end
            tstep = varargval{i};
        case 'timeseries'
            if ~isempty(tstep)
                errormessage('error2');
            end
            timeseries = true;
            pointids = varargval{i};
            Npts = size(pointids,1);
        case 'time'
            isTime = true;
            names = {'ResTime'};
        otherwise
            errormessage('error3');
            
    end
end



% Gather netcdf file info
ncid = netcdf.open(filename,'NC_NOWRITE');
[ndims,nvars,~,unlimdimid] = netcdf.inq(ncid);
dimids = (0:ndims-1)';
dimnames = cell(ndims,1);
dimlen = zeros(1,ndims);
for i = 1 : ndims
    [dimnames{i},dimlen(i)] = netcdf.inqDim(ncid,dimids(i));
end
varid = (0:nvars-1)';
varnames = cell(nvars,1);
xtype = zeros(nvars,1);
vardimids = cell(nvars,1);
varunlimdim = cell(nvars,1);
for i = 1 : nvars
    [varnames{i},xtype(i),vardimids{i}] = netcdf.inqVar(ncid,varid(i));
    varunlimdim{i} = find(vardimids{i}==unlimdimid,1,'first');
end
% Check timestep is appropriate (if specified)
if ~isempty(tstep) && unlimdimid>=0
    if tstep > dimlen(unlimdimid+1)
        errormessage('error4');
    end
end

if isTime
    time_id = netcdf.inqVarID(ncid,'ResTime');
    time_long_name = netcdf.getAtt(ncid,time_id,netcdf.inqAttName(ncid,time_id,0));
    time_datum = time_long_name(end-18:end);
    %Date in matlab dates from which time is measured in seconds
    start_date = datenum(time_datum,'dd/mm/yyyy HH:MM');
end


% Get variables
if ~timeseries % We are chasing entire variables at one or all timesteps
    if isempty(names) % Get all variables
        for i = 1 : nvars
            if isempty(tstep) || isempty(varunlimdim{i}) % get all timesteps (if applicable)
                data.(varnames{i}) = netcdf.getVar(ncid,varid(i));
            else  % get specified timestep (if applicable)
                start = zeros(size(vardimids{i}));
                start(varunlimdim{i}) = tstep - 1;
                count = dimlen(vardimids{i}+1);
                count(varunlimdim{i}) = 1;
                varnames{i} = regexprep(varnames{i},'+','_');
                varnames{i} = regexprep(varnames{i},'(','_');
                varnames{i} = regexprep(varnames{i},')','_');
                data.(varnames{i}) = netcdf.getVar(ncid,varid(i),start,count);
            end
        end
    else % Get dimension variables and specified variables only
        for i = 1 : length(dimnames)
            j = strcmp(varnames,dimnames{i});
            if any(j)
                data.(varnames{j}) = netcdf.getVar(ncid,varid(j));
            end
        end
        for i = 1 : length(names)
            %disp('crash 1');
            if isfield(data,names{i}), continue, end
            j = strcmp(varnames,names{i});
            if any(j)
                if isempty(tstep)
                    %disp('crash 2');
                    if strcmpi(varnames{j},'ResTime') == 0
                        disp('____________________________________________');
                        disp('____________________________________________');
                        disp('WARNING: NETCDF is being limited via Timesteps');
                        
                        %data.(varnames{j}) = netcdf.getVar(ncid,varid(j),[0 0],[19146 1270],'double');
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j),'double');
                    else
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j),'double');
                    end
                else
                    if isempty(varunlimdim{j})
                        disp('crash 3');
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j),'double');
                    else
                        disp('crash 4');
                        start = zeros(size(vardimids{j}));
                        start(varunlimdim{j}) = tstep - 1;
                        count = dimlen(vardimids{j}+1);
                        count(varunlimdim{j}) = 1;
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j),start,count,'double');
                    end
                end
            else
                disp([names{i},' variable not found in ',filename]);
            end
        end
    end
else % We are chasing timeseries output for specified points within variables
    if isempty(names) % Get all variables
        data.point_ids = pointids;
        for i = 1 : nvars
            if isempty(varunlimdim{i}), continue, end
            if length(vardimids{i})==1 % Get unlimited dimension variable
                data.(varnames{i}) = netcdf.getVar(ncid,varid(i));
                continue
            end
            if length(dimlen(vardimids{i}+1))~=size(pointids,2)+1
                errormessage('error5',varnames{i});
            end
            data.(varnames{i}) = zeros(dimlen(unlimdimid+1),Npts);
            for n = 1 : Npts
                start = [pointids(n,:)-1 0];
                count = ones(size(start));
                count(end) = dimlen(unlimdimid+1);
                stride = dimlen(vardimids{i}+1);
                stride(varunlimdim{i}) = 1;
                if any(start)<0 || ...
                        length(start)~=length(vardimids{i}) || ...
                        any(start+1>dimlen(vardimids{i}+1))
                    
                    errormessage('error6',...
                        num2str(pointids(n,:)),varnames{i})
                    
                else
                    data.(varnames{i})(:,n) = netcdf.getVar(ncid,varid(i),start,count,stride);
                end
            end
        end
    else % Get specified variables only
        data.point_ids = pointids;
        for i = 1 : length(names)
            if isfield(data,names{i}), continue, end
            j = strcmp(varnames,names{i});
            if any(j)
                if isempty(varunlimdim{j}), continue, end
                if length(vardimids{j})==1 % Get unlimited dimension variable
                    data.(varnames{j}) = netcdf.getvar(ncid,varid(j));
                    continue
                end
                if length(dimlen(vardimids{j}+1))~=size(pointids,2)+1
                    errormessage('error5',varnames{j});
                end
                data.(varnames{j}) = zeros(dimlen(unlimdimid+1),Npts);
                for n = 1 : Npts
                    start = [pointids(n,:)-1 0];
                    count = ones(size(start));
                    count(end) = dimlen(unlimdimid+1);
                    stride = dimlen(vardimids{j}+1);
                    stride(varunlimdim{j}) = 1;
                    if any(start)<0 ||...
                            length(start)~=length(vardimids{j}) ||...
                            any(start+1>dimlen(vardimids{j}+1))
                        errormessage('error6',...
                            num2str(pointids(n,:)),varnames{j});
                    else
                        
                        data.(varnames{j})(:,n) = netcdf.getvar(ncid,varid(j),start,count,stride);
                        
                    end
                end
            else
                disp([names{i},' variable not found in ',filename]);
            end
        end
    end
    netcdf.close(ncid)
end
if isTime
    data.Time = data.ResTime/24 + start_date;
    netcdf.close(ncid)
end
end %--% tfv_readnetcdf
%-------------------------------------------------------------------------%
function errormessage(messID,varargin)
% Very simple container function for the error messages
switch messID
    
    case 'error1'
        errorstr = ['Expecting variable arguments',...
            ' as descriptor/value pairs'];
        
    case 'error2'
        errorstr = ['Specifying timeseries and timestep',...
            ' are mutually exclusive'];
        
    case 'error3'
        errorstr = 'Unexpected variable argument type';
        
    case 'error4'
        errorstr = ['specified timestep is greater than',...
            ' unlimited dimension length'];
        
    case 'error5'
        errorstr = ['Variable, ',varargin{1},...
            ', rank is not compatible with specified pointids'];
        
    case 'error6'
        errorstr = ['Pointid [',varargin{1},...
            '] is not compatible with variable, ',varargin{2}];
        
    otherwise
        errorstr = 'UNKNOWN Message ID';
end
error('MATLAB:myCode:dimensions', errorstr);
end %--% errormessage
%-------------------------------------------------------------------------%







%end


% 
% 'WQ_TRC_SS1',...
% 'WQ_TRC_RET',...
% 'WQ_OXY_OXY',...
% 'WQ_CAR_DIC',...
% 'WQ_CAR_PH',...
% 'WQ_CAR_CH4',...
% 'WQ_SIL_RSI',...
% 'WQ_NIT_AMM',...
% 'WQ_NIT_NIT',...
% 'WQ_PHS_FRP',...
% 'WQ_PHS_FRP_ADS',...
% 'WQ_OGM_DOC',...
% 'WQ_OGM_POC',...
% 'WQ_OGM_DON',...
% 'WQ_OGM_PON',...
% 'WQ_OGM_DOP',...
% 'WQ_OGM_POP',...
% 'WQ_PHY_GRN',...
% 'WQ_GEO_FEII',...
% 'WQ_GEO_FEIII',...
% 'WQ_GEO_AL',...
% 'WQ_GEO_CL',...
% 'WQ_GEO_SO4',...
% 'WQ_GEO_NA',...
% 'WQ_GEO_K',...
% 'WQ_GEO_MG',...
% 'WQ_GEO_CA',...
% 'WQ_GEO_PE',...
% 'WQ_GEO_UBALCHG',...
% 'WQ_DIAG_SDF_FSED_OXY',...
% 'WQ_DIAG_SDF_FSED_RSI',...
% 'WQ_DIAG_SDF_FSED_FRP',...
% 'WQ_DIAG_SDF_FSED_PON',...
% 'WQ_DIAG_SDF_FSED_DON',...
% 'WQ_DIAG_SDF_FSED_POP',...
% 'WQ_DIAG_SDF_FSED_DOP',...
% 'WQ_DIAG_SDF_FSED_POC',...
% 'WQ_DIAG_SDF_FSED_DOC',...
% 'WQ_DIAG_SDF_FSED_DIC',...
% 'WQ_DIAG_TRC_D_TAUB',...
% 'WQ_DIAG_OXY_SED_OXY',...
% 'WQ_DIAG_OXY_ATM_OXY_EXCH',...
% 'WQ_DIAG_OXY_SAT',...
% 'WQ_DIAG_CAR_PCO2',...
% 'WQ_DIAG_CAR_CH4OX',...
% 'WQ_DIAG_CAR_SED_DIC',...
% 'WQ_DIAG_CAR_ATM_CO2_EXCH',...
% 'WQ_DIAG_CAR_ATM_CH4_EXCH',...
% 'WQ_DIAG_SIL_SED_RSI',...
% 'WQ_DIAG_NIT_NITRIF',...
% 'WQ_DIAG_NIT_DENIT',...
% 'WQ_DIAG_NIT_SED_AMM',...
% 'WQ_DIAG_NIT_SED_NIT',...
% 'WQ_DIAG_PHS_SED_FRP',...
% 'WQ_DIAG_OGM_CDOM',...
% 'WQ_DIAG_PHY_GRN_NTOP',...
% 'WQ_DIAG_PHY_GRN_FI',...
% 'WQ_DIAG_PHY_GRN_FNIT',...
% 'WQ_DIAG_PHY_GRN_FPHO',...
% 'WQ_DIAG_PHY_GRN_FSIL',...
% 'WQ_DIAG_PHY_GRN_FT',...
% 'WQ_DIAG_PHY_GRN_FSAL',...
% 'WQ_DIAG_PHY_GPP',...
% 'WQ_DIAG_PHY_NCP',...
% 'WQ_DIAG_PHY_PPR',...
% 'WQ_DIAG_PHY_NPR',...
% 'WQ_DIAG_PHY_NUP',...
% 'WQ_DIAG_PHY_PUP',...
% 'WQ_DIAG_PHY_CUP',...
% 'WQ_DIAG_PHY_PAR',...
% 'WQ_DIAG_PHY_TCHLA',...
% 'WQ_DIAG_PHY_TPHYS',...
% 'WQ_DIAG_PHY_IN',...
% 'WQ_DIAG_PHY_IP',...
% 'WQ_DIAG_GEO_PCO2',...
% 'WQ_DIAG_GEO_NONCON_MH',...
% 'WQ_DIAG_TOT_TN',...
% 'WQ_DIAG_TOT_TP',...
% 'WQ_DIAG_TOT_TOC',...
% 'WQ_DIAG_TOT_TSS',...
% 'WQ_DIAG_TOT_TURBIDITY',...