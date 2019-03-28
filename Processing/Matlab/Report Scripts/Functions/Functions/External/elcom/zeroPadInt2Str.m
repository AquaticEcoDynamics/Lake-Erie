function [outStr] = zeroPadInt2Str(intIn,strlen)
% function [outStr] = zeroPadInt2Str(intIn,strlen)
%
% Converts a string to an integer but pads the start of the string with zeros
%
% Inputs:
%   intIn      : the integr to convert
%   strlen     : the length of the output string
%
% Outputs
%		outSTr     : the string with padded zeros
%
% Uses:
%
% Written by C. Dallimore 5 Dec 06

if nargin < 1
  error('Syntax: zeroPadInt2Str(intIn,strlen)\n')
end

tmpStr = int2str(intIn);
if length(tmpStr) > strlen
  error('strlen is smaller than number of digits in intIn')
end
for i=1:strlen
  outStr(i:i) = '0';
end
outStr(strlen-length(tmpStr)+1:strlen)=tmpStr;

