clear all; close all;

%ncfile1 = 'F:/Output.n/erie_AED.nc';
%ncfile2 = 'F:/Output.n/erie_AED.nc';


start_timeave = datenum(2013,06:09,01);
end_timeave = datenum(2013,07:10,01);


varname = {...
 'WQ_DIAG_TOT_PAR',...
 'WQ_DIAG_MAG_PUP_BEN',...
 'WQ_DIAG_MAG_GPP_BEN',...
%  'WQ_PHS_FRP_ADS',...
%  'WQ_OGM_DOC',...
%  'WQ_OGM_POC',...
%  'WQ_OGM_DON',...
%  'WQ_OGM_PON',...
};

def.cAxis(1).value = [-10 10];     %'WQ_DIAG_TOT_TN',...
def.cAxis(1).clip  = [-1 1];   
def.conv(1)        = 1;        
def.label(1)       = {'\DeltaPAR (W/m^2)'}; 
def.thedepth(1)    = {'bottom'}; %or bottom

def.cAxis(2).value = [-0.1 0.1];     %'WQ_DIAG_TOT_TN',...
def.cAxis(2).clip  = [-0.01 0.01];   
def.conv(2)        = 1;        
def.label(2)       = {'\DeltaCGM P uptake (mmolP/m^2/day)'}; 
def.thedepth(2)    = {'bottom'}; %or bottom

def.cAxis(3).value = [-0.1 0.1];     %'WQ_DIAG_TOT_TN',...
def.cAxis(3).clip  = [-0.01 0.01];   
def.conv(3)        = 1;        
def.label(3)       = {'\DeltaCGM GPP (mmolC/m^2/day)'}; 
def.thedepth(3)    = {'bottom'}; %or bottom
 


%%%%% SCN 01 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED_diag.nc';
ncfile2 = '/Volumes/T7/Erie/Output.01/erie_01_AED_diag.nc';
 
folder = 'del01-00';


for i = 1:length(start_timeave) 
    for j = 1:length(varname)
        
        mkdir([folder,'/',def.thedepth{j},'/',varname{j},'/']);
        
        %titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mm-dd'),' : ',datestr(end_timeave(i),'mm-dd')] ];
        titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mmm')] ];
        
        outname = [folder,'/',def.thedepth{j},'/',varname{j},'/',datestr(start_timeave(i),'yyyy_mm_dd'),' ',varname{j},'.png'];
       
        erie_delmap_v2(ncfile1,ncfile2,varname{j},titletxt,def.cAxis(j).value,def.cAxis(j).clip,...
            start_timeave(i),end_timeave(i),outname,def.conv(j),def.thedepth{j});
    end
end


%%%%% SCN 02 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED_diag.nc';
ncfile2 = '/Volumes/T7/Erie/Output.02/erie_02_AED_diag.nc';
 
folder = 'del02-00';


for i = 1:length(start_timeave) 
    for j = 1:length(varname)
        
        mkdir([folder,'/',def.thedepth{j},'/',varname{j},'/']);
        
        %titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mm-dd'),' : ',datestr(end_timeave(i),'mm-dd')] ];
        titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mmm')] ];
        
        outname = [folder,'/',def.thedepth{j},'/',varname{j},'/',datestr(start_timeave(i),'yyyy_mm_dd'),' ',varname{j},'.png'];
       
        erie_delmap_v2(ncfile1,ncfile2,varname{j},titletxt,def.cAxis(j).value,def.cAxis(j).clip,...
            start_timeave(i),end_timeave(i),outname,def.conv(j),def.thedepth{j});
    end
end




%%%%% SCN 06 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED_diag.nc';
ncfile2 = '/Volumes/T7/Erie/Output.06/erie_06_AED_diag.nc';
 
folder = 'del06-00';


for i = 1:length(start_timeave) 
    for j = 1:length(varname)
        
        mkdir([folder,'/',def.thedepth{j},'/',varname{j},'/']);
        
        %titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mm-dd'),' : ',datestr(end_timeave(i),'mm-dd')] ];
        titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mmm')] ];
        
        outname = [folder,'/',def.thedepth{j},'/',varname{j},'/',datestr(start_timeave(i),'yyyy_mm_dd'),' ',varname{j},'.png'];
       
        erie_delmap_v2(ncfile1,ncfile2,varname{j},titletxt,def.cAxis(j).value,def.cAxis(j).clip,...
            start_timeave(i),end_timeave(i),outname,def.conv(j),def.thedepth{j});
    end
end






%%%%% SCN 10 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED_diag.nc';
ncfile2 = '/Volumes/T7/Erie/Output.10/erie_10_AED_diag.nc';
 
folder = 'del10-00';


for i = 1:length(start_timeave) 
    for j = 1:length(varname)
        
        mkdir([folder,'/',def.thedepth{j},'/',varname{j},'/']);
        
        %titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mm-dd'),' : ',datestr(end_timeave(i),'mm-dd')] ];
        titletxt = [def.label(j), regexprep(varname{j},'_',' '), [datestr(start_timeave(i),'yyyy-mmm')] ];
        
        outname = [folder,'/',def.thedepth{j},'/',varname{j},'/',datestr(start_timeave(i),'yyyy_mm_dd'),' ',varname{j},'.png'];
       
        erie_delmap_v2(ncfile1,ncfile2,varname{j},titletxt,def.cAxis(j).value,def.cAxis(j).clip,...
            start_timeave(i),end_timeave(i),outname,def.conv(j),def.thedepth{j});
    end
end

