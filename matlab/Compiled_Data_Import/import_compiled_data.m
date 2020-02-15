clear all; close all;

addpath(genpath('geo'));

basedir = '../../raw/Compiled/';

filenames = {...
    'LE_2008_compiled.xlsx',...
    'LE_2009_compiled.xlsx',...
    'LE_2010_compiled.xlsx',...
    'LE_2011_compiled.xlsx',...
    'LE_2012_compiled.xlsx',...
    'LE_2013_compiled.xlsx',...
    'LE_2014_compiled.xlsx',...
    'LE_2015_compiled.xlsx',...
    'LE_2016_compiled.xlsx',...
    'LE_2017_compiled.xlsx',...
    'LE_2018_compiled.xlsx',...
    };

sheets = {'ECCC',...
          'EPA',...
    };

[snum,sstr] = xlsread('Conversion.xlsx','A2:C10000');

headers = sstr(:,1);
AED = sstr(:,2);
conv = snum(:,1);

erie_all  = [];

site_inc = 1;

for i = 1:length(filenames)
    disp(filenames{i});
    for j = 1:length(sheets)
        
        thefile = [basedir,filenames{i}];
        
        [snum,sstr] = xlsread(thefile,sheets{j},'A6:O100000');
        
        source  = [];
        cruise = [];
        air_temp = [];
        X = [];
        Y = [];
        lon = [];
        lat = [];
        station_name = [];
        depth = [];
        date = [];
        
        if strcmpi(sheets{j},'ECCC') == 1
        source  = sstr(:,1);
        cruise = snum(:,1);
        air_temp = snum(:,4);
        lat = snum(:,7);
        lon = snum(:,8);
        station_name = snum(:,9);
        depth = snum(:,11) * -1;
        date = datenum(sstr(:,15),'dd/mm/yyyy');
        
        
        
        else
            [snum1,~] = xlsread(thefile,sheets{j},'D6:O100000');
            source  = sstr(:,1);
            cruise = sstr(:,2);
            air_temp = snum1(:,2);
            lat = snum1(:,5);
            lon = snum1(:,6);
            station_name = sstr(:,10);
            depth = snum1(:,9) * -1;
            date = datenum(sstr(:,15),'dd/mm/yyyy');
            
            
        end
        [X,Y] = ll2utm(lon,lat);
        
        [snum,~] = xlsread(thefile,sheets{j},'R6:BQ100000');
        
        for k = 1:size(snum,2)
            for l = 1:size(snum,1)
                
                if strcmpi(AED{k},'Ignore') == 0
                    if ~isnan(snum(l,k))
                        sname = ['station_',num2str(site_inc)];

                        erie_all.(sname).(AED{k}).Date = date(l);
                        erie_all.(sname).(AED{k}).Depth = depth(l);
                        erie_all.(sname).(AED{k}).Data = snum(l,k) * conv(k);
                        erie_all.(sname).(AED{k}).X = X(l);
                        erie_all.(sname).(AED{k}).Y = Y(l);
                        erie_all.(sname).(AED{k}).source = source{l};
                        if strcmpi(sheets{j},'ECCC') == 1
                            erie_all.(sname).(AED{k}).station = ['STN_',num2str(station_name(l))];
                        else
                            erie_all.(sname).(AED{k}).station = station_name{l};
                        end
                        
                        site_inc = site_inc + 1;
                    end
                end
            end
        end
        
        
        
        
        
        
        
        
    end
    
    
end
        

save erie_all.mat erie_all -mat;
        
format_erie_all;       
        