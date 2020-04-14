clear all; close all;

addpath(genpath('geo'));


basedir = '../../data/LE_2013_nearshore_DO/';

dirlist = dir([basedir,'*.mat']);

for i = 1:length(dirlist)
    thesite = regexprep(dirlist(i).name,'.mat','');
    tt = load([basedir,dirlist(i).name]);
    data.(thesite) = tt.(thesite);
    clear tt;
end

vars = [];

sites = fieldnames(data);

for i = 1:length(sites)
    vars = [vars;fieldnames(data.(sites{i}))];
end
uvars = unique(vars);

oldvars = {...
    'Cond',...
    'DO',...
    'DO_Sat',...
    'Depth',...
    'SpCond',...
    'Temp',...
    'Time',...
    'Turbidity',...
    'pH',...
    };

newvars = {...
    'Cond',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_OXY_SAT',...
    'Depth',...
    'SpCond',...
    'TEMP',...
    'Time',...
    'WQ_DIAG_TOT_TURBIDITY',...
    'WQ_CAR_PH',...
    };

conv = [...
    1,...
    1000/32,...
    1,...
    1,...
    1,...
    1,...
    1,...
    1,...
    1,...
    ];



[snum,sstr] = xlsread('Site_Details.xlsx','A2:E7');

snames = sstr(:,1);
lat = snum(:,3);
lon = snum(:,2);
sdepth = snum(:,4);

ns = [];

for i = 1:length(sites)
    
    
    vars = fieldnames(data.(sites{i}));
    
    tt = find(strcmpi(snames,sites{i}) == 1);
    
    [X, Y] = ll2utm (lon(tt), lat(tt));
    bdepth = sdepth(tt);
    
    
    for j = 1:length(vars)
        
        if strcmpi(vars{j},'Time') == 0 & ...
                strcmpi(vars{j},'Depth') == 0
            
            ss = find(strcmpi(oldvars,vars{j}) == 1);
            
            thevar = newvars{ss};
            
            switch vars{j}
                case 'Cond'
                    ns.(sites{i}).SAL.Data = conductivity2salinity(data.(sites{i}).(vars{j}));
                    thevar = 'SAL';
                 case 'SpCond'
                    ns.(sites{i}).SAL.Data = conductivity2salinity(data.(sites{i}).(vars{j}));
                    thevar = 'SAL';
                otherwise
                    ns.(sites{i}).(thevar).Data = data.(sites{i}).(vars{j}) * conv(ss);
            end
            
            ns.(sites{i}).(thevar).Depth = bdepth + data.(sites{i}).Depth;
            ns.(sites{i}).(thevar).Date(:,1) = data.(sites{i}).Time;
            ns.(sites{i}).(thevar).X = X;
            ns.(sites{i}).(thevar).Y = Y;
            ns.(sites{i}).(thevar).Agency = 'ECCC-YSI';
            
        end
    end
end

save ns.mat ns -mat;
            
            
            
            
            
            
            
            
            
            
            
            