function [CWRDate] = matlab2CWRdate(matlabdate);

% USAGE
% 	[CWRDate] = matlab2CWRdate(matlabdate);
%
% Chris Dallimore 27 July 04;

warning off
for i = 1:length(matlabdate)
	tmpStr = datestr(matlabdate(i),30);
	yr = str2num(tmpStr(1:4));
	mm = str2num(tmpStr(5:6));
	dd = str2num(tmpStr(7:8));
	HH = str2num(tmpStr(10:11));
	MM = str2num(tmpStr(12:13));
	SS = str2num(tmpStr(14:15));

	% Check for leap year
	if mod(yr,4) == 0 && mod(yr,100) ~=0
		leapYear=1;
		lengths=cumsum([0 31 29 31 30 31 30 31 31 30 31 30]);
	else
		leapYear=0;
		lengths=cumsum([0 31 28 31 30 31 30 31 31 30 31 30]);
	end

	% Get day in year
	yearDay = lengths(mm)+dd;

	% Get fraction of day
	fracDay = (HH+(MM+SS/60)/60)/24;

	% Get CWR Day
	CWRDate(i)=yr*1000+yearDay+fracDay;
end

return;
