%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage:	    	JED=dat2jed(mn,dy,yr,hr,mt,se,basis_yr,leap)
%         	or, 	JED=dat2jed(mn,dy,yr,hr,mt,se,basis_yr)
%			or,		JED=dat2jed(mn,dy,yr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% given month, day, year, hour, minute, second, the 
% basis year, and whether or not it is a leap year 
% (leap=1 --> yes, leap=0 --> no), dat2jed returns
% the julian elapsed day for that basis year.
% mn, dy, hr, mt, and se can be vectors, but must be of the same length
%----
% leap can now be calculated automatically from yr 
% blaval 98/08/28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function JED=dat2jed(mn,dy,yr,hr,mt,se,b_yr,leap)

if nargin==3, 
  hr=0; mt=0; se=0; b_yr=yr(1,:);
end

if nargin<8,
  test=b_yr/4; test=test-floor(test);
  if test==0, leap=1, else leap=0, end
end

if ~leap, 
  lengths=cumsum([0 31 28 31 30 31 30 31 31 30 31 30])-1;
  tot_dys=365;
else, 	  
  lengths=cumsum([0 31 29 31 30 31 30 31 31 30 31 30])-1; 
  tot_dys=366;
end

year_adj=(yr-b_yr)*tot_dys;
time=(hr+(mt+se/60)/60)/24;
for ti=1:12,
   mn(find(mn==ti))=lengths(ti);
end
dat=mn+dy;
% old way, new way handles matrices
%for ti=1:length(mn(:)),
%  dat=lengths(mn(ti))+dy(ti)-1;
%end
JED=year_adj+dat+time;
