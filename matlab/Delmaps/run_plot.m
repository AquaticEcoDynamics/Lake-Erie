clear all; close all;

%ncfile1 = 'F:/Output.n/erie_AED.nc';
%ncfile2 = 'F:/Output.n/erie_AED.nc';


start_timeave = datenum(2013,06:09,01);
end_timeave = datenum(2013,07:10,01);


varname = {...
 'WQ_PHS_FRP',...
 'WQ_DIAG_PHY_TCHLA',...
 'WQ_DIAG_TOT_TP',...
 'WQ_OXY_OXY',...
 'WQ_BIV_FILTFRAC',...
 'WQ_OGM_POC',...
 'WQ_OGM_DOP',...
 'WQ_NIT_AMM',...
 'WQ_NIT_NIT',...
 'WQ_DIAG_MAG_TMALG',...
%  'WQ_PHS_FRP_ADS',...
%  'WQ_OGM_DOC',...
%  'WQ_OGM_POC',...
%  'WQ_OGM_DON',...
%  'WQ_OGM_PON',...
};

def.cAxis(1).value = [-0.003 0.003];     %'WQ_DIAG_TOT_TN',...
def.cAxis(1).clip  = [-0.0003 0.0003];   
def.conv(1)        = 30.91/1000;        
def.label(1)       = {'\DeltaPO_4 (\mug/L)'}; 
def.thedepth(1)    = {'surface'}; %or bottom

def.cAxis(2).value = [-2 2];             %'WQ_DIAG_TOT_TN',...
def.cAxis(2).clip  = [-0.2 0.2];   
def.conv(2)        = 1;   
def.label(2)       = {'\DeltaChl-a (\mug/L)'}; 
def.thedepth(2)    = {'surface'}; %or bottom

def.cAxis(3).value = [-0.003 0.003];             %'WQ_DIAG_TOT_TN',...
def.cAxis(3).clip  = [-0.0003 0.0003];   
def.conv(3)        = 30.91/1000; 
def.label(3)       = {'\DeltaTP (\mug/L)'}; 
def.thedepth(3)    = {'surface'}; %or bottom

def.cAxis(4).value = [-1 1];             %'WQ_DIAG_TOT_TN',...
def.cAxis(4).clip  = [-0.1 0.1];   
def.conv(4)        = 32./1000; 
def.label(4)       = {'\DeltaO_2 (mg/L)'}; 
def.thedepth(4)    = {'bottom'}; %or bottom

def.cAxis(5).value = [-1 1];             %'WQ_DIAG_TOT_TN',...
def.cAxis(5).clip  = [-0.1 0.1];   
def.conv(5)        = 1; 
def.label(5)       = {'\Delta[mussel filtration frac.]'}; 
def.thedepth(5)    = {'surface'}; %or bottom

def.cAxis(6).value = [-1 1];             %'WQ_DIAG_TOT_TN',...
def.cAxis(6).clip  = [-0.2 0.2];   
def.conv(6)        = 12./1000; 
def.label(6)       = {'\DeltaPOC (gC/m^3)'}; 
def.thedepth(6)    = {'surface'}; %or bottom

def.cAxis(7).value = [-0.005 0.005];             %'WQ_DIAG_TOT_TN',...
def.cAxis(7).clip  = [-0.001 0.001];   
def.conv(7)        = 30.91/1000;
def.label(7)       = {'\DeltaDOP (gP/m^3)'}; 
def.thedepth(7)    = {'surface'}; %or bottom

def.cAxis(8).value = [-0.05 0.05];             %'WQ_DIAG_TOT_TN',...
def.cAxis(8).clip  = [-0.01 0.01];   
def.conv(8)        = 14.0/1000;  
def.label(8)       = {'\DeltaNH_4 (gN/m^3)'}; 
def.thedepth(8)    = {'bottom'}; %or bottom

def.cAxis(9).value = [-0.2 0.2];             %'WQ_DIAG_TOT_TN',...
def.cAxis(9).clip  = [-0.02 0.02];   
def.conv(9)        = 14.0/1000; 
def.label(9)       = {'\Delta NO_3 (gN/m^3)'}; 
def.thedepth(9)    = {'surface'}; %or bottom

def.cAxis(10).value = [-50 50];             %'WQ_DIAG_TOT_TN',...
def.cAxis(10).clip  = [-5 5];   
def.conv(10)        = 1; 
def.label(10)       = {'\DeltaCGM (gDW/m^2)'}; 
def.thedepth(10)    = {'bottom'}; %or bottom



%%%%% SCN 01 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED.nc';
ncfile2 = '/Volumes/T7/Erie/Output.01/erie_01_AED.nc';
 
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

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED.nc';
ncfile2 = '/Volumes/T7/Erie/Output.02/erie_02_AED.nc';
 
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

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED.nc';
ncfile2 = '/Volumes/T7/Erie/Output.06/erie_06_AED.nc';
 
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




%%%%% SCN 07 vs SCN 00 

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED.nc';
ncfile2 = '/Volumes/T7/Erie/Output.07/erie_07_AED.nc';
 
folder = 'del07-00';


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

ncfile1 = '/Volumes/T7/Erie/Output.00/erie_00_AED.nc';
ncfile2 = '/Volumes/T7/Erie/Output.10/erie_10_AED.nc';
 
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

