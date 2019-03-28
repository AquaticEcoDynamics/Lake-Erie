function h1 = mapbase(varargin)
% mapbase - Display a 3D-cube in the current axes
%
%   mapbase(X,R,ALPHA,COLOR) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES : 3-elements vector that defines the length of cube edges
%   * ORIGIN: 3-elements vector that defines the start point of the cube
%   * ALPHA : scalar that defines the transparency of the cube faces (from 0
%             to 1)
%   * COLOR : 3-elements vector that defines the faces color of the cube
%
% Example:
%   >> mapbase(X,R,.8,[1 0 0]);

warning off
% Default input arguments
inArgs = { ...
  [10 56 100] , ... % Default edge sizes (x,y and z)
  [10 10  10] , ... % Default coordinates of the origin point of the cube
  1          , ... % Default alpha value for the cube's faces
  [.4 .4 .4]       ... % Default Color for the cube
  };

% Replace default input arguments by input values
inArgs(1:nargin) = varargin;

% Create all variables
[X,R,alpha,clr] = deal(inArgs{:});

X = im2double(X);





siz = size(X);
XX = R(3,2):R(1,2):R(3,2) + (R(1,2)* siz(1));
YY = R(3,1):R(2,1):R(3,1) + (R(2,1)* siz(2));
XLength = (XX(1) - XX(end))*-1;
YLength = YY(end) - YY(1);


edges = [YLength XLength .1];
origin = [YY(1) XX(1) -.12];


XYZ = { ...
  [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
  [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
  [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
  [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
  [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
  [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
  };

XYZ = mat2cell(...
  cellfun( @(x,y,z) x*y+z , ...
    XYZ , ...
    repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...
    repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
    'UniformOutput',false), ...
  6,[1 1 1]);


cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
  repmat({clr},6,1),...
  repmat({'FaceAlpha'},6,1),...
  repmat({alpha},6,1)...
  );hold on


freezeColors
hold on

newX = XX(1:end-1);
newY = YY(1:end-1);

[YYY,XXX] = meshgrid(newX,newY);
ZZZ(1:(length(YY)-1),1:(length(XX)-1)) = -0.02;
%X(:,:,1)' 'edgecolor','flat'
h1 = surf(XXX,YYY,ZZZ,X(:,:,1)');
set(h1,'edgecolor','flat','facecolor','flat')
colormap(gray)
axis xy
axis off
