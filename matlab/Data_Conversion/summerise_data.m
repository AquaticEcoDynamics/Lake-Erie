function summerise_sites(swan,folder,shpname)


outdir = folder;

%load(matfile);

%eval(['swan = ',regexprep(matfile,'.mat',''),';']);

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(swan);

for k = 1:length(sites)
    
    
    
    
    sitename = sites{k};
    
    
    vars = fieldnames(swan.(sitename));
    
    findir = [outdir,sitename,'\'];
        
    if ~exist(findir,'dir');
        mkdir(findir);
    end
    
    
    
    fid = fopen([findir,'1. Summary.csv'],'wt');
    fprintf(fid,'Variable Name,Min Date,Max Date,Number of Samples\n');
    
    for i = 1:length(vars)
        
        disp([sitename,': ',vars{i}]);
        
        mindate = min(swan.(sitename).(vars{i}).Date);
        maxdate = max(swan.(sitename).(vars{i}).Date);
        num_samples = length(swan.(sitename).(vars{i}).Date);
        
        fprintf(fid,'%s,%s,%s,%5.3f\n',vars{i},datestr(mindate,'dd/mm/yyyy HH:MM:SS'),datestr(maxdate,'dd/mm/yyyy HH:MM:SS'),num_samples);
        
         xdata = swan.(sitename).(vars{i}).Date;
         ydata = swan.(sitename).(vars{i}).Data;
         
         plot(xdata,ydata,'.r');
         
         set(gca,'XGrid','on','YGrid','on');
         
         
         if max(xdata) - min(xdata) > 10
             xarray = min(xdata):(max(xdata) - min(xdata))/5:max(xdata);
             xlim([min(xdata) max(xdata)]);
             set(gca,'XTick',xarray,'xticklabel',datestr(xarray,'dd/mm/yyyy'));
         else
             datetick('x','dd/mm/yyyy');
         end
         
         title(regexprep([sitename,': ',vars{i}],'_','-'),'fontsize',10,'fontweight','bold');
         
         savename = [findir,vars{i},'.png'];
         
         set(gcf, 'PaperPositionMode', 'manual');
         set(gcf, 'PaperUnits', 'centimeters');
         xSize = 18;
         ySize = 7;
         xLeft = (21-xSize)/2;
         yTop = (30-ySize)/2;
         set(gcf,'paperposition',[0 0 xSize ySize]);
         
         print(gcf,savename,'-dpng');
         
         close
%         
        
        
        
    end
    
    fclose(fid);
    
end

sites =fieldnames(swan);


for i = 1:length(sites)
    vars = fieldnames(swan.(sites{i}));
    
    S(i).X = swan.(sites{i}).(vars{1}).X(1);
    S(i).Y = swan.(sites{i}).(vars{1}).Y(1);
    S(i).Name = sites{i};
    S(i).FullName = sites{i};
    S(i).Geometry = 'Point';
end

shapename = [outdir,shpname];

shapewrite(S,shapename);

