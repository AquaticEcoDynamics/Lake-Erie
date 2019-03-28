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