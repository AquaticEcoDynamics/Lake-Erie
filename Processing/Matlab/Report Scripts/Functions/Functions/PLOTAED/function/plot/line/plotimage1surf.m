function [H,newMap] = plotImageSurf(X,R,dim)
%
% Function to use the surf command to plot and image.
%
% This allows us to use the Z dimension
%
%
% Usage: H = plotImageSurf(filename) where filename is the name of the
% image.
warning off
% Read the raw data


% Turn from unit8 to double
% X1 = double(X);


% Get the map info

[X,map] = rgb2ind(X,256);
X = double(X);

% Turn the right way up
%X = flipud(X);
% make a Z level at 0
Zlayer = zeros(size(X));
Zlayer = Zlayer-0.0001;
% Get map range
 maxMap = max(max(map));
 newMap = map./maxMap;
% Get plot Limits
[XX,YY] = size(X);
% Co-Ord stuff
siz = size(X);
XX1 = R(3,2):R(1,2):R(3,2) + (R(1,2)* siz(1));
YY1 = R(3,1):R(2,1):R(3,1) + (R(2,1)* siz(2));
newX = XX1(1:end-1);
newY = YY1(1:end-1);
[YYY,XXX] = meshgrid(newX',newY');
if strcmp(dim,'2d') >0
    H = pcolor(XXX,YYY,X');
    shading flat
    colormap(newMap)
    axis off;
    set(H,'edgecolor','none')
    set(H,'LineStyle','none')

% Change the LineStyle prop

else
    warning off
    mapbase(X,R);hold on
    hold on
    H = surf(XXX,YYY,Zlayer',X','facecolor','texture','edgecolor','none');
 	colormap(newMap);
    zlim([-1 1])
    view(3);
    axis off;
end
 freezeColors

warning on

