function [H ]= pcolor_CD(x_in,y_in,data_in,dx1,dy1);
%
% Plots a pcolor plot but shows full matrix
% NB: Default pcolor does not show last row or column
% Assumes x and y are cell centered values
%
% Calling
%  H = pcolor_flat (data)
%         plots data against index
%  H = pcolor_flat (x,y,data)
%         plots data against x and y
%         assumes dx(1) = x(2)-x(1)
%  H = pcolor_flat (x,y,data,dx1,dy1)
%         plots data against x and y
%         dx1 and dy1 specify grid spacings
%         of first column and first matrix
%
% Written by C Dallimore 10/2/04
%
if nargin == 1
  data = x_in;
  [ny, nx] = size(data);
  x = [1:nx]-0.5;
  y = [1:ny]-0.5;
  dx1 = 1;
  dy1 = 1;
elseif nargin == 3
  x = x_in;
  y = y_in;
  data = data_in;
  dx1 = x(2)-x(1);
  dy1 = y(2)-y(1);
elseif nargin == 5
  x = x_in;
  y = y_in;
  data = data_in;
else
   error('Incorrrect number of input arguments!')
end;

% Get location of grid faces
nx = length(x);
ny = length(y);

x_new = zeros(nx+1,1);
y_new = zeros(ny+1,1);

x_new(1) = x(1)-0.5*dx1;
for i = 1:nx
    x_new(i+1) = 2*x(i)-x_new(i);
end
y_new(1) = y(1)-0.5*dy1;
for i = 1:ny
    y_new(i+1) = 2*y(i)-y_new(i);
end

% Add extra column and row to matrix
data_new = zeros (ny+1,nx+1);
data_new (1:ny,1:nx) = data;

% Plot data
H = pcolor (x_new,y_new,data_new);
% Default shading flat
shading flat

return;

