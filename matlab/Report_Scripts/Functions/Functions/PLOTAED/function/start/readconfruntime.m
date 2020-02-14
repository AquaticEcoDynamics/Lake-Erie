function userdata = readconfRUNTIME(fullpath,filename)
% This function takes the user configuration file and creates the
% structured type userdata.
warning off
[num,str] = xlsread(filename);

% Start and end date info
% Start and end date info


if strcmp(computer,'PCWIN64') > 0
    numdates = num(7,1);
    userdata.startdate = datenum(str(16,2),'dd/mm/yy');
    userdata.enddate = datenum(str(16 + (numdates-1),2),'dd/mm/yy');
    for ii = 1:numdates
        userdata.datearray(ii) = datenum(str(15 + ii,2),'dd/mm/yy');
    end
else
    numdates = num(7,2);
    userdata.startdate = x2mdate(num(8,2));
    userdata.enddate = x2mdate(num(8+(numdates-1),2));
    for ii = 1:numdates
        userdata.datearray(ii) = x2mdate(num(7+ii,2));
    end
end

% Plot Type
userdata.png = str(4,3);
userdata.type = str(5,2);
userdata.modeltype = str(6,2);
userdata.directory = str(4,3);
userdata.validation = str(4,4);
% Set sheet defaults
userdata.defaults.sheet.type = str(9,1);
userdata.defaults.sheet.focus = str(9,2);
userdata.defaults.sheet.background = str(9,3);
userdata.defaults.sheet.show = str(9,4);
userdata.defaults.sheet.region = str(9,5);
userdata.defaults.sheet.plotint = num(1,5);

% Set Line defaults
userdata.defaults.line.type = str(13,1);
userdata.defaults.line.validation = str(13,2);
userdata.defaults.line.sitename = str{13,3};
userdata.defaults.line.show = str(13,4);

% Now import in the site information
[num1] = xlsread([fullpath.confpth,'/plot/sitelist.xls']);
userdata.defaults.line.site = num1;

% Now the netcdf information
numNETCDF = length(str) - 25;
for ii = 1:numNETCDF
    userdata.simulation(ii).project = str(25+ii,1);
    userdata.simulation(ii).server = str(25+ii,2);
    userdata.simulation(ii).folder = str(25+ii,3);
    userdata.simulation(ii).grid = str(25+ii,4);
    userdata.simulation(ii).colour = str(25+ii,5);
    userdata.simulation(ii).legend = str(25+ii,6);
end

warning on







