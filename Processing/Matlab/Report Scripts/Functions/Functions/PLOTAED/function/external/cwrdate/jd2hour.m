function [year,day,hour] = jd2hour(jd);

% USAGE
% 	[year,day,hour] = jd2hour(jd);
%
% Convert a time in decimal Julian days to
% a 24 hour time. Can enter either 5 digit
% or 3 digit jd. Year returned either as 
% empty or 2 digit number, day as 1-3 digit
% number and hour as 3-4 digit number.
%
% Jason Antenucci 11/6/99

if jd > 1000
	year=floor(jd/1000);
	day=floor(jd-(year*1000));
else 
	year=[];
	day=floor(jd);
end

decimal_time = jd-floor(jd);
base_hour = floor(decimal_time*24);
minutes = round(60*(decimal_time*24 - base_hour));
index=find(minutes==60);
base_hour(index) = base_hour(index) + 1;
minutes(index) = 0;
hour = (base_hour*100) + minutes;

return
