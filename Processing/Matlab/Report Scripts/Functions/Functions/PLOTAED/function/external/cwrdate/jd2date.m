function [year,month,days,hour,minute] = jd2date(JD);

% USAGE
% 	[year,month,day,hour,minute] = jd2date(JD);
%
% Adapted from OpCalendar, by Angelo Saggio
%
% Jason Antenucci 28/9/99

leap   = [0;31;60;91;121;152;182;213;244;274;305;335;366]+1;
nleap  = [0;31;59;90;120;151;181;212;243;273;304;334;365]+1;
month = [1:12];

jd     = floor(JD);
year   = floor(jd/1000);
days   = jd - year*1000;
flag   = rem(year,4);
time   = (JD - jd)*86400;
hour   = floor(time/3600);
minute = round((time-(hour*3600))/60);
if (minute == 60)
  minute = 0;
  hour   = hour+1;
end;
if (hour >= 24)
  hour = hour-24;
  days = days+1;
end;

time=(hour*100)+minute;

if (flag == 0)
  nleap = leap;
end;

p = find(nleap > days);
if (~isempty(p))
  p = p(1);
  days = 1+days-nleap(p-1);
  month=month(p-1);
else
  DATE = sprintf('   ERROR: JD %d doesn''t exit!',JD);
end;

return;
