
clear
close all
%% User input
ncfil1 = '/Volumes/aed-1/StudySites/Swan/Simulations/20120605_SWAN_008_2008_infext_szexe_itjiggy/Output/swan.nc';
ncfil2 = '/Volumes/aed-1/StudySites/Swan/Simulations/20120605_SWAN_008_2008_infext_szexe/Output/swan.nc';


geofil = '/Volumes/aed-1/StudySites/Swan/Simulations/20120605_SWAN_008_2008_infext_szexe_itjiggy/Input/log/swan_curv_geo.nc';
parname = 'SAL';
 
line = load('../bb_matlab/Docs/GIS/Txt/Swan_All.xy');
curt_pline = line; %(1:2500,:);
%curt_pline = line(2000:2200,:);


clim = [0.0 36.0];
t0 = 1;
dt = 20;
tend = 3100;


%%

c = struct();
c.f = figure;
c.AspectRatio = [2000. 1 1];
c.VecScale = 20.;
c.Xinc = 1;
c.Zinc = 1;
%%
[curt_idx2, curt_coords, curt_chain] = fv_get_curtain_ids(curt_pline,geofil);
c.idx2 = curt_idx2;
c.coords = curt_coords;
c.chain = curt_chain;
c = fvcurtain(c,ncfil1,parname,t0);
%c = fvcurtain_vec(c,ncfil,t0);
colorbar
set(c.h,'clim',clim)    
set(c.h,'Position',[0.1 0.5 0.8 .4])

%%

d = struct();
d.f = c.f;
d.AspectRatio = [2000. 1 1];
d.VecScale = 20.;
d.Xinc = 1;
d.Zinc = 1;
%%
[curt_idx2, curt_coords, curt_chain] = fv_get_curtain_ids(curt_pline,geofil);
d.idx2 = curt_idx2;
d.coords = curt_coords;
d.chain = curt_chain;
d = fvcurtain(d,ncfil2,parname,t0);
%d = fvcurtain_vec(d,ncfil,t0);
colorbar
set(d.h,'clim',clim)    
set(d.h,'Position',[0.1 0.1 0.8 .4])


for t = t0 : dt : tend
    c = fvcurtain(c,ncfil1,parname,t);
    %c = fvcurtain_vec(c,ncfil,t);
    title(num2str(t));
    
    set(gca,'Ylim',[-5 1.5]);
    shading flat

    d = fvcurtain(d,ncfil2,parname,t);
    %c = fvcurtain_vec(c,ncfil,t);
    title(num2str(t));
    
    set(gca,'Ylim',[-5 1.5]);
    shading flat
    
end





% 
% clear
% close all
% %% User input
% ncfil = '../Output/Elliptic_Basin.nc';
% geofil = '../Input/log/Elliptic_Basin_geo.nc';
% parname = 'TEMP';
% curt_pline = [-395,5;395,5];
% clim = [10.0 20.0];
% t0 = 1;
% dt = 5;
% tend = 10000;
% %%
% c = struct();
% c.f = figure;
% c.AspectRatio = [10. 1 1];
% c.VecScale = 20.;
% c.Xinc = 1;
% c.Zinc = 1;
% %%
% [curt_idx2, curt_coords, curt_chain] = fv_get_curtain_ids(curt_pline,geofil);
% c.idx2 = curt_idx2;
% c.coords = curt_coords;
% c.chain = curt_chain;
% c = fvcurtain(c,ncfil,parname,t0);
% c = fvcurtain_vec(c,ncfil,t0);
% colorbar
% set(c.h,'clim',clim)    
% %%
% for t = t0 : dt : tend
%     c = fvcurtain(c,ncfil,parname,t);
%     c = fvcurtain_vec(c,ncfil,t);
% end