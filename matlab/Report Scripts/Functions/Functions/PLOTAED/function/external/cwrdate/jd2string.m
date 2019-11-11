function [date_str,time_str] = jd2string(JD);

% USAGE
% 	[date_str,time_str] = jd2string(JD);
%
% uses jd2date
%
% Jason Antenucci 28/9/99

%[year,month,day,time] = jd2date(JD);
[year,month,day,hour,min] = jd2date(JD);
monStr = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
date_str = strcat([num2str(day),' ',char(monStr(month)),' ',num2str(year)]);
%if floor(time/100) < 10
%  hour_str = strcat('0',num2str(floor(time/100)));
%else
%  hour_str = num2str(floor(time/100));
%end
%if time-100*floor(time/100) < 10
%  min_str = strcat('0',num2str(time-100*floor(time/100)));
%else
%  min_str = num2str(time-100*floor(time/100));
%end
%time_str = strcat([hour_str,':',min_str]);
hour_str = num2str(hour);
if hour  < 10
  hour_str = strcat('0',hour_str);
end
min_str = num2str(min);
if min  < 10
  min_str = strcat('0',min_str);
end
time_str = strcat([hour_str,':',min_str]);


return;
