function DateNumber = x2mdate(ExcelDateNumber, Convention)
%X2MDATE Excel Serial Date Number Form to MATLAB Serial Date Number Form
%
%   DateNumber = x2mdate(ExcelDateNumber, Convention)
%
%   Summary: This function converts serial date numbers from the Excel serial
%            date number format to the MATLAB serial date number format.
%
%   Inputs: ExcelDateNumber - Nx1 or 1xN vector of serial date numbers in
%           Excel serial date number form
%           Convention - Nx1 or 1xN vector or scalar flag value indicating
%              which date convention was used in Excel to convert the date
%              strings to serial date numbers; possible values are:
%              a) Convention = 0 - 1900 date system in which a serial date
%                 number of one corresponds to the date 31-Dec-1899 (default)
%              b) Convention = 1 - 1904 date system in which a serial date
%                 number of zero corresponds to the date 1-Jan-1904
%
%   Outputs: Nx1 or 1xN vector of serial date numbers in MATLAB serial date
%            number form
%
%   Example: StartDate = 35746
%            Convention = 0;
%
%            EndDate = x2mdate(StartDate, Convention);
% 
%            returns:
%
%            EndDate = 729706
%
%   See also M2XDATE.

%   Copyright 1995-2006 The MathWorks, Inc.
%$Revision: 1.10.2.4 $   $Date: 2010/10/08 16:42:58 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Convert date strings to serial date numbers if necessary
if (any(ischar(ExcelDateNumber)))
     ExcelDateNumber = datenum(ExcelDateNumber);
end


%Check the number of arguments in and set defaults
if (nargin < 2)
     Convention = zeros(size(ExcelDateNumber));
end


%Make sure input date numbers are both numeric and positive
if (ExcelDateNumber <= 0)
     error(message('finance:x2mdate:invalidInputs'))
end


%Do any needed scalar expansion on the convention flag and parse
if ((size(Convention) ~= size(ExcelDateNumber)) & (max(size(Convention)) ~= 1))
     error(message('finance:x2mdate:invalidConventionFlagSize'))
elseif (length(Convention(:)) == 1)
     Convention = Convention * ones(size(ExcelDateNumber));
end

if (any(Convention ~= 0 & Convention ~= 1))
     error(message('finance:x2mdate:invalidConventionFlag'))
end


%Get the shape of the input for later reshaping of the output
[RowSize, ColumnSize] = size(ExcelDateNumber);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set conversion factor for both date systems
%1900 date system
X2MATLAB1900 = 693960;


%1904 date system
X2MATLAB1904 = 695422;


%Convert to the MATLAB serial datenumber format
X1900Ind = find(Convention == 0);
if (~isempty(X1900Ind))
     Temp(X1900Ind) = ExcelDateNumber(X1900Ind) + X2MATLAB1900;
end

X1904Ind = find(Convention == 1);
if (~isempty(X1904Ind))
     Temp(X1904Ind) = ExcelDateNumber(X1904Ind) + X2MATLAB1904;
end


%Reshape the output
DateNumber = reshape(Temp, RowSize, ColumnSize);

%end of XDATE2MDATE function

