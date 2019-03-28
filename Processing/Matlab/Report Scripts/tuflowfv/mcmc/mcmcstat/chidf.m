function p=chidf(x,df,nc)
%CHIDF  Chi squared cumulative distribution function
%  CHIDF(x,df,nc) x quantile, df degrees of freedon, nc noncentrality

% Marko Laine <marko.laine@fmi.fi>
% $Revision: 1.6 $  $Date: 2012/09/27 11:47:34 $
if nargin<3,nc=0;end
p=distribs('chidf',x,df,nc);

