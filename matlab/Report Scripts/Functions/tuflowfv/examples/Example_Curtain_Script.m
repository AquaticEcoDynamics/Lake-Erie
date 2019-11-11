filename ='D:/Studysites/Home Folders/Swan/Simulations/20120327_SWAN_002/Output/swan_curv.nc';;
geoname = 'D:/Studysites/Home Folders/Swan/Simulations/20120327_SWAN_002/Input/log/swan_curv_geo.nc';
curtpoints =  'D:/Studysites/Home Folders/Swan/Simulations/20120327_SWAN_002/Docs/GIS/Txt/UpperReach.xy';
varname = {'SAL'};
output = 'D:/Studysites/Home Folders/Swan/Simulations/20120327_SWAN_002/Output/Images/Salt_Upper/';

mkdir(output);


massfile = regexprep(filename,'\.nc','_MASS.csv');
imp = tfv_readoutputcsv(massfile);
timestamp = imp.TIME;

[viewout] = tfv_getcurtainview(filename,...
    geoname,...
    curtpoints,...
    'timeslice',10,...
    'variable',varname);
close

for ii = 1:10:100000
    
    [fig,gridmesh,data] = tfv_plotcurtain(filename,...
        geoname,...
        curtpoints,...
        'timeslice',ii',...
        'variable',varname,...
        'view',viewout);
    
    axis off
    set(gca,'box','off')
    zlim([-3 5]);
    caxis([15 25]);
    
    
    text(0.1,1.05,'Salinity',...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',16);
    
    text(0.1,0,datestr(timestamp(ii),'dd/mm/yyyy'),...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',16);
    
    print(gcf,'-dpng',[output,'Salt_',num2str(ii),'.png'],'-opengl');
    
    close
    
end