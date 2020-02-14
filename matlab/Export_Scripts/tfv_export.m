function tfv_export(filename)
% A simple function to plot and export the tfv data based on a
% configuration file.
% Usage: tfv_export config.nml
%
% Written by Brendan Busch

conf = read_nml_file(filename);

ncfile = conf.Configuration.model;

sites = conf.Sites;

variables = conf.Variables;

vars = fieldnames(variables);
snames = fieldnames(sites);
outdir = conf.Configuration.output_directory;

if ~exist(outdir,'dir')
    mkdir(outdir);
end


sim = [];
%__________________________________________________________________________

allvars = tfv_infonetcdf(ncfile);


for i = 1:length(vars)

    raw.data = tfv_readnetcdf(ncfile,'names',vars{i});
    
    for j = 1:length(snames)
        
        X = sites.(snames{j}).X;
        Y = sites.(snames{j}).Y;
        
        if i == 1;
        % Data for shapefile
            S(j).X = X;
            S(j).Y = Y;
            S(j).Name = snames{j};
            S(j).Full_Name = sites.(snames{j}).name;
            S(j).Geometry = 'Point';
        
        end
        data = tfv_getmodeldatalocation(...
                ncfile,raw.data,X,Y,vars(i));
   
        export_data(data,conf,vars{i},snames{j});
        
        
        sim.(vars{i}).(snames{j}) = data;
        
        clear data;
                
    end
    
end

shpdir = [outdir,'GIS/'];

if ~exist(shpdir,'dir')
    mkdir(shpdir);
end

% Save the output
shapewrite(S,[shpdir,'Sites.shp']);

save([outdir,'sim.mat'],'sim','-mat');
    
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
function data = read_nml_file(filename)

fid = fopen(filename,'rt');

data = [];

EOF=0;
while ~EOF
    tline = fgetl(fid);
    if (tline == -1), break, end %end of nml file
    if isempty(tline)
        continue
    end
    
    if strcmp(tline(1),'&')
        
        isinternal = 1;
        varname = regexprep(tline,'&','');
        while isinternal
            
            tline = fgetl(fid);
            
            if (tline == -1), break, end %end of nml file
            if isempty(regexprep(tline,' ',''))
                continue
            else
                if ~strcmp(tline(1),'&')
                    if ~strcmp(tline(1),'!')  %Is not a comment line
                        %tline_cmp = regexprep(tline,' ','');
                        eval(['data.(varname).',tline,';']);
                    end
                else
                    varname = regexprep(tline,'&','');
                    
                end
            end
        end
    end
end
fclose(fid);
end
%-------------------------------------------------------------------------%

function [varnames,dimnames,data] = tfv_infonetcdf(filename);
% Simple function to get all variable names from a Tuflow netcdf file
data = [];
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

end
%-------------------------------------------------------------------------%
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

if strcmp(varname{1},'H') == 0 & strcmp(varname{1},'cell_A') == 0 & strcmp(varname{1},'cell_Zb') == 0
    
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

cont = tfv_readnetcdf(filename,'time',1);
data.date = cont.Time;


% dat = tfv_readnetcdf(filename,'time',1);
% data.date = dat.Time;
%--%
end
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function data = tfv_readfvc(filename)
% Function to read the tuflow fvc file and output relevant info in the
% structure 'data'.
%
%       %--% Usage: data = tfv_readfvc('tuflow.fvc'; %--%
%
%       %--% Output Variables: %--%
%
%             * maindirectory
%             * fvc - Control file name (no Path)
%             * StartTime
%             * EndTime
%             * meshfile
%             * layerfile
%             * initialWaterLevel
%             * initialSalinity
%             * initialTemperature
%             * outputdirectory
%             * BC - Actual variable name is based on BC Keyword
%
%
%       %--% No External M_Files %--%
%
%
%
%
%       %--% Created by Brendan Busch 25/03/2012 %--%
%-------------------------------------------------------------------------%
%--%  Initialise Structure
data = [];

[data.maindirectory,...
    data.fvc,...
    data.simname] = parsedir(filename);

%--% Open File
fid = fopen(filename,'rt');

%--% Logical test for End of File
EOF = 0;

while ~EOF
    %--% Get current line
    sLinestring = fgetl(fid);
    %--% Check for empty line
    if ~isempty(sLinestring)
        %--% Check for End of File
        if sLinestring == -1
            EOF = 1;
        else
            [param,value] = parseline(sLinestring,fid);
            if ~isempty(param)
                data.(param) = value;
            end
        end
    end
end

data.netcdf.Interval(:,1) = data.StartTime:(data.Interval/86400):data.EndTime;
%data.netcdf.WQInterval(:,1) = data.StartTime:(data.WQinterval/86400):data.EndTime;
end %--% tfv_readfvc
%-------------------------------------------------------------------------%
function [param,value,fid] = parseline(sLinestring,fid)
% Function to take an input create by fgetl and output resulting
% param/value pair for final structure
%
% To output other parametres, simply add to the switch.  Be sure to remove
% the spaces for the case string.  This is to account for any odd whitespce
% that may exist in the file. If extra processing required, create a
% subfunction to keep the switch readable

%--% Initialise
param = [];
value = [];

%--% Test for comment line
if strcmp('!',sLinestring(1)) == 1
    return;
end

%--% Not a comment so split along the '==' string
cParval = regexp(sLinestring,'==','split');

if length(cParval) == 1
    return; %--% Special case for material section
end

%--% Remove any whitespace
par = regexprep(cParval{1},'\s','');
val = regexprep(cParval{2},'\s','');

%--% Now for our switch statement
switch par
    
    case 'starttime'
        
        param = 'StartTime';
        value = datenum(val,'dd/mm/yyyyHH:MM:SS');
        
    case 'endtime'
        
        param = 'EndTime';
        value = datenum(val,'dd/mm/yyyyHH:MM:SS');
        
    case 'geometry2d'
        
        param = 'meshfile';
        value = val;
        
    case 'layerfaces'
        
        param = 'layerfile';
        value = val;
        
    case 'initialwaterlevel'
        
        param = 'initialWaterLevel';
        value = str2double(val);
        
    case 'initialsalinity'
        
        param = 'initialSalinity';
        value = str2double(val);
        
    case 'initialtemperature'
        
        param = 'initialTemperature';
        value = str2double(val);
        
    case 'outputdir'
        
        param = 'outputdirectory';
        value = val;
        
    case 'bc'
        %--% Need some extra editing
        [varlist,filepath] = parsebc(val);
        param = varlist;
        value = filepath;
        
    case 'output'
        if strcmp(val,'netcdf') == 1
            [param,value,fid] = parsenetcdf(fid);
        end
    otherwise
        return
end

end %--% parseline
%-------------------------------------------------------------------------%
function [varlist,filepath] = parsebc(val)
% Extra processing for the BC data

% Split along the comma
cBCspt = regexp(val,',','split');

varlist = cBCspt{1};
filepath = cBCspt{end};

end %--% parsebc
%-------------------------------------------------------------------------%
function [maindir,fvc,simname] = parsedir(filename)

cSimdir = regexp(filename,'Input/','split');

if ~isempty(cSimdir)
    maindir = cSimdir{1};
    fvc = regexprep(cSimdir{end},{'\';'/'},'');
else
    %--% User is in the Input directory
    temppath = pwd;
    maindir = regexp(temppath,'/Input/','split');
    fvc = filename;
end

nameall = regexp(fvc,'\.','split');
simname = nameall{1};
end %--% parsedir
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
function [param,value,fid] = parsenetcdf(fid)
% Extra processing for netcdf
sLine = fgetl(fid);
cLine = regexp(sLine,'==','split');

par = regexprep(cLine{1},'\s','');
val = regexprep(cLine{2},'\s','');

if strcmp(par,'suffix') == 1
    junk = fgetl(fid);
    newline = fgetl(fid);
    param = 'WQinterval';
    snewline = regexp(newline,'==','split');
    val = regexprep(snewline{2},'\s','');
    value = str2double(val);
else
    newline = fgetl(fid);
    param = 'Interval';
    snewline = regexp(newline,'==','split');
    val = regexprep(snewline{2},'\s','');
    value = str2double(val);
end

end %--% Parsenetcdf
%-------------------------------------------------------------------------%
function export_data(data,conf,var,site)
% Simple plotting function for tfv_export.

outdir = conf.Configuration.output_directory;

full_dir = [outdir,'Export/',site,'/',var,'/'];

if ~exist(full_dir,'dir')
    mkdir(full_dir);
end

plot(data.date,smooth(data.surface,conf.Configuration.smooth),'k','DisplayName','Surface');hold on
plot(data.date,smooth(data.bottom,conf.Configuration.smooth),'r','DisplayName','Bottom');

stime = datenum(conf.Configuration.time_start,'dd/mm/yyyy');
etime = datenum(conf.Configuration.time_end,'dd/mm/yyyy');

datearray = stime:(etime - stime)/5:etime;

xlim([stime etime]);
set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd/mm/yy'),...
    'FontSize',6,'FontWeight','Bold');
ylim([conf.Variables.(var).caxis(1) conf.Variables.(var).caxis(2)]);
ytic = get(gca,'YTick');
set(gca,'YTick',ytic,...
    'FontSize',6,'FontWeight','Bold');
title(conf.Sites.(site).name,'fontSize',6,'FontWeight','bold');

xlab = 'Date';
ylab = [conf.Variables.(var).name,' (',conf.Variables.(var).units,')'];

xlabel(xlab,'fontSize',6,'FontWeight','bold');
ylabel(ylab,'fontSize',6,'FontWeight','bold');

leg = legend('location','NE');
set(leg,'FontSize',5);
savename = [full_dir,'Image'];

%--% Paper Size
            set(gcf, 'PaperPositionMode', 'manual');
            set(gcf, 'PaperUnits', 'centimeters');
            xSize = 16;
            ySize = 6;
            xLeft = (21-xSize)/2;
            yTop = (30-ySize)/2;
            set(gcf,'paperposition',[0 0 xSize ySize])



saveas(gcf,savename,'fig');
saveas(gcf,savename,'png');


close;

fid = fopen([full_dir,site,'_',var,'.csv'],'wt');

fprintf(fid,'Date,Surface,Bottom\n');

for i = 1:length(data.date)
    
    pdate = datestr(data.date(i),'dd/mm/yyyy HH:MM:SS');
    psurface = data.surface(i);
    pbottom = data.bottom(i);
    
    fprintf(fid,'%s,%4.5f,%4.5f\n',pdate,psurface,pbottom);
    
    clear pdate psurface pbottom;
    
end
fclose(fid);
end %---------------------------------------------------------------------%