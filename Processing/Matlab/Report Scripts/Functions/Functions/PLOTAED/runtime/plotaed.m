function plotaed(filename)
% test script to govern testing for the plotting routine
clc
% Path
addpath('../function/start/');
 fullpath = getpath;
% addpath_recurse([fullpath.functionpth]);
addpath(genpath('../function'));
% Install netcdf software
installnetcdf;
% Read configuration files
gis = readconfgis(fullpath);
userdata = readconfruntime(fullpath,filename);
opts = readconfdefaults(fullpath);
paths = readconfpath(fullpath);
server = readconfserver(fullpath);
cax = readconfcaxis(fullpath);
var = readconfvariable(fullpath);
site = readconfsite(fullpath);
model = readconfmodel(fullpath);
varlist = readconfvariablelist(fullpath);
% Start processing
% Field Data
if strcmp(userdata.validation,'on') > 0
    DWL = processdwl(fullpath,userdata);
    EPA = processepa(fullpath,userdata);
end
modelpath = buildfilepath(fullpath,server,paths,userdata);
fullvariablelist = createvariablelist(varlist,modelpath,var);
reference = referencencfile(modelpath,gis,userdata,model);

% Now start the plotting loop
for ii = 1:length(fullvariablelist)
    disp(fullvariablelist(ii))
    nc = loadncfiles(modelpath,fullvariablelist{ii},var,userdata,cax);
    int = 1;
    if strcmpi(userdata.type{1},'sheet') > 0
        for plottime = userdata.startdate:userdata.defaults.sheet.plotint...
                :userdata.enddate
            plotsheetdata(nc,userdata,opts,var,plottime,...
                fullvariablelist{ii},reference,fullpath,int);
            int = int+1;
        end
    else
        for jj = 1:length(userdata.defaults.line.site)
            val = loadvalidationdata(fullpath,userdata,...
                userdata.defaults.line.site(jj),fullvariablelist(ii),site,var);
            nc = unitelcdconversion(nc,userdata,var,fullvariablelist{ii},...
                site,userdata.defaults.line.site(jj));
            group = getmultiplesites(site,userdata,userdata.defaults.line.site(jj));
            plotvalidationdata(val,site,fullvariablelist{ii},...
                               group,userdata,...
                               userdata.defaults.line.site(jj));
            plotlinedata(nc,userdata,opts,var,site,...
                userdata.defaults.line.site(jj),fullvariablelist{ii},cax,fullpath);
        end
    end
end

