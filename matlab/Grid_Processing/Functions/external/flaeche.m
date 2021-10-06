function [A,uA]=flaeche(x,y,ux,uy)
% function [A,uA]=flaeche(x,y,ux,uy)
%
% calculates area A and its standard uncertainty uA for any arbitrary 
% polygon in a plane given by coordinates x and y and their respective 
% standard uncertainties ux and uy. 
% inputs are assumed to be VECTORS, x, ux, y and uy all should have the
% same size. The uncertainties are assumed to be uncorrelated.
%
% Physikalisch-Technische Bundesanstalt
% Bundesallee 100
% 38116 Braunschweig
% Germany
% 
% algorithm (published, in German): 
% M. Krystek, "Numerische Berechnung des Flächeninhaltes ebener
%              geschlossener Konturen" 
%             tm – Technisches Messen 78 (2011) 2 , pp96-103
%             DOI 10.1524/teme.2011.0059
%
% Matlab version: M. Anton 2010-10-29

yy=y(:);
xx=x(:);
if nargin<4,uy=zeros(size(yy));end
if nargin<3,ux=zeros(size(xx));end
ux2=ux(:).^2;
uy2=uy(:).^2;

i=1:length(xx);
ip=[i(2:end),i(1)];
im=[i(end),i(1:end-1)];
A=0.5*abs(yy'*(xx(ip)-xx(im)));
ak2=0.25*(yy(ip)-yy(im)).^2;
bk2=0.25*(xx(ip)-xx(ip)).^2;
uA=sqrt(sum(ak2.*ux2+bk2.*uy2));