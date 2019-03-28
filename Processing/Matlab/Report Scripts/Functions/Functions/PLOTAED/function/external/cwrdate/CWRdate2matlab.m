function [matlabdate] = CWRdate2matlab(CWRDate);

% Converts CWR date format to matlab date format
%
% USAGE
% 	[matlabdate] = CWRdate2matlab(CWRDate);
%
% Uses:
%		CWRdate2date.m
%
% Chris Dallimore 27 July 04;

matlabdate=CWRDate*0;

for i = 1:length(CWRDate)
  [year,month,days,hour,minute,second] = CWRdate2date(CWRDate(i));
  if ~isnan(year)
    matlabdate(i)=datenum(year,month,days,hour,minute,second);
  else
    matlabdate(i)=NaN;
  end
end

return;
