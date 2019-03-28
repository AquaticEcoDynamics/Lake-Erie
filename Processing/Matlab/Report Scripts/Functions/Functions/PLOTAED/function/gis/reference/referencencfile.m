function reference = referenceNCfile(modelpath,gis,userdata,model)
% Function to both reference and rotation the NC data.
for ii = 1:length(modelpath)
    %     info = nldnc(modelpath{ii},{'X','Y'});
    %
    %     gridX = info.Y +  gis.([cell2mat(userdata.simulation(ii).grid)]).X;
    %     gridY =  gis.([cell2mat(userdata.simulation(ii).grid)]).Y - info.X;
    %
    %     [CX CY] = meshgrid(gridX,gridY);
    %
    %     rot = model.rotation.([cell2mat(userdata.simulation(ii).grid)]);
    %     if rot > 0
    %         offset_d=230;
    %         offset_l=130;
    %
    %         xo = gis.([cell2mat(userdata.simulation(ii).grid)]).X  - offset_d*50*sin(rot*pi/180) + offset_l*50*cos(rot*pi/180);
    %         yo = gis.([cell2mat(userdata.simulation(ii).grid)]).Y + offset_d*50*cos(rot*pi/180) + offset_l*50*sin(rot*pi/180);
    %         % equation for angles with lisflood axis
    %         dists      = sqrt(CX.^2 + CY.^2);
    %         ang_lflood = atan(CY./CX);
    %         %adding the rotation;
    %         ang_georef = ang_lflood + rot*pi/180;
    %         reference(ii).X       = xo + dists.*cos(ang_georef);
    %         reference(ii).Y       = yo + dists.*sin(ang_georef);
    %
    %     else
    %
    %         reference(ii).X = CX;
    %         reference(ii).Y = CY;
    %     end
    netcdf_style = 'elcd';
    switch lower(netcdf_style)
        case 'elcd'
            info = nldnc(modelpath{ii},{'X','Y'})
            
            %         data.bathData = info.BATHY;
            %         data.bathData(data.bathData > 800) = NaN;
            %
            %         data.bathData = data.bathData';
            rot = model.rotation.([cell2mat(userdata.simulation(ii).grid)]);
            if rot > 0
                offset_d=230;
                offset_l=130;
                
                gridX = info.Y;
                gridY = info.X;
                spaceY = diff(gridY);
                spaceY = flipud(spaceY);
                newGridY = zeros(length(spaceY)+1,1);
                newGridY(1) = gridY(end) - gridY(end-1);
                for jj = 1:length(spaceY)
                    newGridY(jj+1) = newGridY(jj) + spaceY(jj);
                end
                gridY = flipud(newGridY);
                
                [CX CY] = meshgrid(gridX,gridY);
                
                xo = gis.([cell2mat(userdata.simulation(ii).grid)]).X  - offset_d*50*sin(rot*pi/180) + offset_l*50*cos(rot*pi/180);
                yo = gis.([cell2mat(userdata.simulation(ii).grid)]).Y + offset_d*50*cos(rot*pi/180) + offset_l*50*sin(rot*pi/180);
                % equation for angles with lisflood axis
                dists      = sqrt(CX.^2 + CY.^2);
                ang_lflood = atan(CY./CX);
                %adding the rotation;
                ang_georef = ang_lflood + rot*pi/180;
                reference(ii).X       = xo + dists.*cos(ang_georef);
                reference(ii).Y       = yo + dists.*sin(ang_georef);
            else
                gridX = info.Y +  gis.([cell2mat(userdata.simulation(ii).grid)]).X;
                gridY =  gis.([cell2mat(userdata.simulation(ii).grid)]).Y - info.X;
                
                [CX CY] = meshgrid(gridX,gridY);
                
                
                reference(ii).X = CX;
                reference(ii).Y = CY;
            end
            clear CX CY
            
        case 'getm'
            
            
        case 'tuflow'
            
        otherwise
            disp('Model Not know: ELCD, GETM & TUFLOW are the only choices');
            
    end
    clear CX CY
    
end






end