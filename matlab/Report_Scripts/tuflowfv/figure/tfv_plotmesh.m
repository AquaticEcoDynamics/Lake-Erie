function [data,pat] = tfv_plotmesh(filename)
% Function to load in the 2dm data and store as structure

%--% Initialise structure
data = [];

fid = fopen(filename,'rt');

EOF = false;
ndInc = 1;
EQ = 1;
while ~EOF
    linestr = fgetl(fid);
    
    if linestr == -1
        EOF = true;
    else
        
        linespt = regexp(linestr,'\s','split');
        header = linespt{1};
        
        switch header
            
            case 'ND'
                data.ND(ndInc,1:3) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5})];
                ndInc = ndInc + 1;
            case 'E4Q'
                EQ = str2double(linespt{2});
                data.face(EQ,1:4) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5}) ...
                    str2double(linespt{6})];
            case 'E3T'
                EQ = str2double(linespt{2});
                data.face(EQ,1:4) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5}) ...
                    str2double(linespt{3})];
            otherwise
                
                
        end
        clear linespt;
        
    end
    
    
end
figure('Renderer','painters',...
    'position',[1 1 872 563]);

pat = patch('faces',data.face,'Vertices',data.ND);
set(pat,'FaceColor','None',...
    'FaceVertexCData',data.ND(:,3),...
    'CDataMapping','scaled',...
    'EdgeColor','K',...
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
axis off
colorbar