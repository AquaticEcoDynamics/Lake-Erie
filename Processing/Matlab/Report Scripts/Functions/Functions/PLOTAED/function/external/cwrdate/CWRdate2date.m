function [year,month,day,hour,minute,second] = jd2date(CWRDate);

% Converts CWR date format to date
%
% USAGE
% 	[year,month,days,hour,minute,second] = CWRdate2matlab(CWRDate);
%
% Chris Dallimore 27 July 04;


monthStartNoLeap = cumsum([ 0 31 28 31 30 31 30 31 31 30 31 30]);
monthStartLeap   = cumsum([ 0 31 29 31 30 31 30 31 31 30 31 30]);
monthEndNoLeap   = cumsum([31 28 31 30 31 30 31 31 30 31 30 31]);
monthEndLeap     = cumsum([31 29 31 30 31 30 31 31 30 31 30 31]);
month = [1:12];

if ~isnan(CWRDate)
  year   = floor(CWRDate/1000);
  day    = floor(CWRDate - year*1000. );
  time   = (CWRDate - floor(CWRDate))*86400;
  hour   = floor(time/3600);
  minute = floor((time-(hour*3600))/60);
  second = round(time-(hour*3600)-(minute*60));
  if (second >= 60)
    second = second-60;
    minute   = minute+1;
  end;
  if (minute >= 60)
    minute = minute-60;
    hour   = hour+1;
  end;
  if (hour >= 24)
    hour = hour-24;
    day  = day+1.0;
  end;

% Check for leap year and set month start and end
  if mod(year,4) == 0 & mod(year,100) ~=0 
    leapYear=1;
    monthStart = monthStartLeap;
                monthEnd = monthEndLeap;
  else
    leapYear=0;
                monthStart = monthStartNoLeap;
                monthEnd = monthEndNoLeap;
  end
        % Check for excess days.
        % NB this is a hack for elcom txtfiles where JD continues
        % through years
        nYearAdd = floor(day/(monthEnd(12)+1));
        year = year +nYearAdd;
        day = day - nYearAdd*monthEnd(12);
        month = find(monthStart < day & monthEnd >= day);
        day = day-monthStart(month);

else
        year   = NaN;
        month  = NaN;
        day    = NaN;
        hour   = NaN;
        minute = NaN;
        second = NaN;
end



