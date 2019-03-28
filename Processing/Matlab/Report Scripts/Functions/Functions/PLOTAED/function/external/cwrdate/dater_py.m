function [datestr]=dater_py(CWRDay);

months=['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun';...
        'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'];

mdays=[0,31,28,31,30,31,30,31,31,30,31,30,31];

year=floor(floor(CWRDay)/1000)*1000;
cwrday=floor(CWRDay)-year;

cmdays=cumsum(mdays);
fd=find(cmdays>=cwrday);
month=months(fd(1)-1,:);
day=cwrday-cmdays(fd(1)-1);

datestr=[num2str(day),' ',month,' ',num2str(year/1000)];



