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
            if isfield(data,names{i}), continue, end
            j = strcmp(varnames,names{i});
            if any(j)
                if isempty(tstep)
                    data.(varnames{j}) = netcdf.getVar(ncid,varid(j));
                else
                    if isempty(varunlimdim{j})
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j));
                    else
                        start = zeros(size(vardimids{j}));
                        start(varunlimdim{j}) = tstep - 1;
                        count = dimlen(vardimids{j}+1);
                        count(varunlimdim{j}) = 1;
                        data.(varnames{j}) = netcdf.getVar(ncid,varid(j),start,count);
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
