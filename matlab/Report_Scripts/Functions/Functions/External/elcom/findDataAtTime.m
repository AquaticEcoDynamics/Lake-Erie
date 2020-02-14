function [dataAtTime] = findDataAtTime(time,dataArray,timeArray)
% function [dataAtTime] = findDataAtTime(time,dataArray,timeArray)
%
% Inputs:
%		time       : time that data is required
%   dataArray  : array of data values
%   timeArray  : array of time values
%
% Outputs
%		dataAtTime : data at time.  Value is interpolate linearly between two nearest points
%
% Uses:
%
% Written by C. Dallimore 9 Jun 06

if nargin ~= 3
	error('findDataAtTime requires 3 arguments')
end

if length(dataArray) ~= length(timeArray)
	error('timeArray and dataArray must be the same length')
end

dTime = abs(timeArray - time);
[tmp ii] = min(dTime);
if (time > timeArray(ii))
	if ii < length (dTime)
		dt= timeArray(ii+1)-timeArray(ii);
		dt1 = time -timeArray(ii);
		v1 = dataArray(ii);
		v2 = dataArray(ii+1);
		dataAtTime = v1 + dt1/dt*(v2-v1);
	else
		dataAtTime = dataArray(length (dTime));
	end
else
	if ii > 1
		dt = timeArray(ii)-timeArray(ii-1);
		dt1 = time -timeArray(ii-1);
		v1 = dataArray(ii-1);
		v2 = dataArray(ii);
		dataAtTime = v1 + dt1/dt*(v2-v1);
	else
		dataAtTime = dataArray(1);
	end
end

