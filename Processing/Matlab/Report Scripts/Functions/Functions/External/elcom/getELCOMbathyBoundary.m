function [iPt,jPt,xm,xp,ym,yp]= getELCOMbathyBoundary(bathStruct);

% function [iPt,jPt,xm,xp,ym,yp]= getELCOMbathyBoundary(bathStruct)
%
% funcion to get aal the cells in an ELCOM bathymetry that are land and have
%   a water boundary
%
% Inputs:
%		bathStruct : astructure from readELCOMbathy
%
% Outputs:  All outputs are vectors of the same length
%   iPt : the i location of the land cell
%   jPt : the j location of the land cell
%   xm  : is x negative face aboundary with water
%   xp  : is x positive face aboundary with water
%   ym  : is y negative face aboundary with water
%   yp  : is y positive face aboundary with water
%
% Uses:
%		nldnc_timestep.m
%
% Written by C. Dallimore 9 June 06
%
%
cnt = 0;
for i =1:bathStruct.x_rows
for j =1:bathStruct.y_columns

  thisCell = 0;
  if (bathStruct.bathData(i,j) == bathStruct.land_value | ...
      bathStruct.bathData(i,j) == bathStruct.open_value)

    % Negative x face is water
    if i ~= 1
      if (bathStruct.bathData(i-1,j) ~= bathStruct.land_value & ...
          bathStruct.bathData(i-1,j) ~= bathStruct.open_value)
        if ~thisCell
          thisCell = 1;
          cnt=cnt+1;
          iPt(cnt)=i;
          jPt(cnt)=j;
        end
        xm(cnt) = 1;
      else
        if thisCell
          xm(cnt) = 0;
        end
      end
    end

    % Positive x face is water
    if i ~= bathStruct.x_rows
      if (bathStruct.bathData(i+1,j) ~= bathStruct.land_value & ...
          bathStruct.bathData(i+1,j) ~= bathStruct.open_value)
        if ~thisCell
          thisCell = 1;
          cnt=cnt+1;
          iPt(cnt)=i;
          jPt(cnt)=j;
        end
        xp(cnt) = 1;
      else
        if thisCell
          xp(cnt) = 0;
        end
      end
    end

    % Negative x face is water
    if j ~= 1
      if (bathStruct.bathData(i,j-1) ~= bathStruct.land_value & ...
          bathStruct.bathData(i,j-1) ~= bathStruct.open_value)
        if ~thisCell
          thisCell = 1;
          cnt=cnt+1;
          iPt(cnt)=i;
          jPt(cnt)=j;
        end
        ym(cnt) = 1;
      else
        if thisCell
          ym(cnt) = 0;
        end
      end
    end

    % Negative x face is water
    if j ~= bathStruct.y_columns
      if (bathStruct.bathData(i,j+1) ~= bathStruct.land_value & ...
          bathStruct.bathData(i,j+1) ~= bathStruct.open_value)
        if ~thisCell
          thisCell = 1;
          cnt=cnt+1;
          iPt(cnt)=i;
          jPt(cnt)=j;
        end
        yp(cnt) = 1;
      else
        if thisCell;
          yp(cnt) = 0;
        end
      end
    end
  end
end
end

