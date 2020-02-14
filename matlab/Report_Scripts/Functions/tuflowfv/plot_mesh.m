clear all
close all

 data = tfv_plotmesh_noplot('../SMS/Swan_v9.2dm');



figure('Renderer','opengl',...
    'position',[1 1 872 563]);
set(gca,'fontsize',7,'Fontweight','bold');

pat = patch('faces',data.face,'Vertices',data.ND);
set(pat,'FaceColor','Interp',...
    'FaceVertexCData',data.ND(:,3),...
    'CDataMapping','scaled',...
    'EdgeColor','none',...
    'LineWidth',0.5);

set(gca,'Color','None',...
    'box','on');

colormap(flipud(winter));


set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.9,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit',...
    'LightPosition',[1 0 0])
axis equal
axis on
bd = colorbar;
set(bd,'position',[0.85 0.25 0.01 0.6]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');

xSize = 15;
ySize = 10;

set(gcf,'paperposition',[0 0 xSize ySize])
 print(gcf,'-depsc2','Images/Swan_Mesh.eps','-zbuffer','-r300')
 
 close
 
% figure('Renderer','painters',...
%     'position',[1 1 872 563]);
% 
% pat = patch('faces',data.face,'Vertices',data.ND);
% set(pat,'FaceColor','None',...
%     'FaceVertexCData',data.ND(:,3),...
%     'CDataMapping','scaled',...
%     'EdgeColor','K',...
%     'LineWidth',0.5);
% 
% set(gca,'Color','None',...
%     'box','off');
% 
% colormap(flipud(winter));
% 
% 
% set(findobj(gca,'type','surface'),...
%     'FaceLighting','phong',...
%     'AmbientStrength',.9,'DiffuseStrength',.8,...
%     'SpecularStrength',.9,'SpecularExponent',25,...
%     'BackFaceLighting','unlit',...
%     'LightPosition',[1 0 0])
% axis equal
% axis off
% %bd = colorbar;
% %set(bd,'position',[0.9 0.1 0.01 0.6]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperUnits', 'centimeters');
% 
% xSize = 15;
% ySize = 10;
% 
% set(gcf,'paperposition',[0 0 xSize ySize])
%  print(gcf,'-depsc2','Images/Swan_Mesh_1.eps','-painters','-r300')
%  
%  close
 
 
 close all