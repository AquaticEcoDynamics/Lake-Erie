clear all; close all;

load erie.mat;

lowerlakes = erie;

shp = shaperead('erie_sites_1.shp');

outdir = 'Final_Data/'; 


sites = fieldnames(lowerlakes);

vars = [];
all_vars = [];

for i = 1:length(sites)
    all_vars = [all_vars;fieldnames(lowerlakes.(sites{i}))];
end
vars = unique(all_vars);




if ~exist(outdir,'dir')
    mkdir(outdir);
end



for i = 1:length(vars)
    
    vardir = [outdir,vars{i},'/'];
    
    if ~exist(vardir,'dir')
        mkdir(vardir);
    end
    
    for j = 1:length(shp)
        
        filename = [vardir,shp(j).Name,'.png'];
        sitename = [vardir,shp(j).Name,'.csv'];
        figure
        fid = fopen(sitename,'wt');
        fprintf(fid,'Site Names\n');
        
        for k = 1:length(sites)
            if isfield(lowerlakes.(sites{k}),vars{i})
                
                X = lowerlakes.(sites{k}).(vars{i}).X;
                Y = lowerlakes.(sites{k}).(vars{i}).Y;
                
                if inpolygon(X,Y,shp(j).X,shp(j).Y)
                    
                    Agency = lowerlakes.(sites{k}).(vars{i}).Agency;
                    switch Agency
                        case 'ECCC'
                            scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'.k');hold on
                        case 'EPA'
                            scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'^r');hold on
%                         case 'MAFRL'
%                             scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'sb');hold on
%                         case 'SCU'
%                             scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'dg');hold on
                        otherwise
                            scatter(lowerlakes.(sites{k}).(vars{i}).Date,lowerlakes.(sites{k}).(vars{i}).Data,'dg');hold on
                    end
                    
                    fprintf(fid,'%s\n',sites{k});
                end
            end
        end
        
        box on
        
        grid on
        
        xarray = datenum(2008:05:2020,01,01);
        
        set(gca,'xtick',xarray,'xticklabel',datestr(xarray,'yyyy'));
        
        xlim([xarray(1) xarray(end)]);
        
        ylabel(regexprep(vars{i},'_','-'));
        
        title(shp(j).Name);
        
        
        saveas(gcf,filename);
        fclose(fid);
        close;
        
    end
end
        
        
        
        
        
                    
                    
                    
                
                
        
        
        
        
        
    
