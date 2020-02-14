function [maxval, jday] = max_jday(x,jd,opt);

% USAGE:
% 	[maxval, jday] = max_jday(x,jd,opt);
%
% Will find the maximum value of a vector on a 
% particular day. If opt == -1, the minimum value
% on the day is found
%
% Jason Antenucci 4/11/98

n=ceil(jd(length(jd)))-floor(jd(1));
jday=floor(jd(1)):floor(jd(1))+n;

if nargin == 2 | opt ~= -1
	for i=1:n
		index=find(jd >= jday(i) & jd < jday(i)+1);
		maxval(i)=max(x(index));
	end
elseif opt == -1
	for i=1:n
		index=find(jd >= jday(i) & jd < jday(i)+1);
		maxval(i)=min(x(index));
	end
end	

jday(length(jday))=[];	% make same length as maxval array

return
