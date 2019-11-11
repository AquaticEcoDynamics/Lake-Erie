function [groups,sets] = readELCOMdatablock(filename)
% function [groups,sets] = readELCOMdatablock(filename)
%
% Inputs:
%		filename   : filename of datblock file
% Outputs
%		groups     : a matlab structure that contains all group info in the file
%		sets       : a matlab structure that contains all group info in the file
%
% Uses:
%		line2strs.m
%
% Note:
%   No format checking of datblock file is done by this routine
%
% Written by C. Dallimore 28 April 06
% Debugging information added by T. Brown 22 June 06
%

% Debugging can be integer > 1
debug=0;

% Open file
fid = fopen(filename,'r');

% Read the header
header = fgetl(fid);

% Read the version
versionLine = fgetl(fid);
words=line2strs(versionLine);
dbVersion=char(words(1));

% Read the number of groups and sets in the file
oneline = fgetl(fid);
words=line2strs(oneline);
nGroups=str2num(char(words(1)));
oneline = fgetl(fid);
words=line2strs(oneline);
nSets=str2num(char(words(1)));

% Read groups info
for i = 1:nGroups

  if (debug >= 1)
    fprintf('Processing Group: %d\n', i);
  end

  %Header
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\theader line: %s\n', oneline);
  end

  % Reference number
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).RefNum=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tref number: %d\n', groups(i).RefNum);
  end

  % Label
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).Label= char(words(1));

  if (debug >= 2)
    fprintf('\tlabel: %s\n', groups(i).Label);
  end

  % filename
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).filename= char(words(1));

  if (debug >= 2)
    fprintf('\toutput file name: %s\n', groups(i).filename);
  end

  % Set Reference number
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).setRefNum=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tset ref number: %d\n', groups(i).setRefNum);
  end

  % number of data types
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).numDatatypes=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tnumber of data types: %d\n', ...
      groups(i).numDatatypes);
  end

  % Is groups a time interval type?
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).isTimeInterval=char(words(1));

  if (debug >= 2)
    fprintf('\ttime interval type: %s\n', ...
      groups(i).isTimeInterval);
  end

  % Read time interval
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).timeInterval=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\ttime interval: %d\n', ...
      groups(i).timeInterval);
  end

  % Read start time
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).startTime=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tstart time: %d\n', groups(i).startTime);
  end

  % Read end time
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).endTime=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tend time: %d\n', groups(i).endTime);
  end

  % get size of time list for time list output
  oneline = fgetl(fid);
  words=line2strs(oneline);
  groups(i).timeListSize=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tsize of time list: %d\n', groups(i).timeListSize);
  end

  % Do some sanity checks
  %
end

% Read Set info
for i = 1:nSets

  if (debug >= 1)
    fprintf('Processing Set: %d\n', i)
  end

  %Header
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\theader line: %s\n', oneline);
  end

  % Reference number
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).RefNum=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tref number: %d\n', sets(i).RefNum);
  end

  % Label
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).Label= char(words(1));

  if (debug >= 2)
    fprintf('\tlabel: %s\n', sets(i).Label);
  end

  % Type
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).Type= char(words(1));

  if (debug >= 2)
    fprintf('\ttype: %s\n', sets(i).Type);
  end

  % Number of Cells
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).numCells=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\tnumber of cells: %d\n', sets(i).numCells);
  end

  % Sheet Type
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).SheetType= char(words(1));

  if (debug >= 2)
    fprintf('\tsheet\ttype: %s\n', sets(i).SheetType);
  end

  % sheet calc
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).SheetCalc= char(words(1));

  if (debug >= 2)
    fprintf('\t\tcalc: %s\n', sets(i).SheetCalc);
  end

  % sheet value
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).SheetVal=str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\t\tvalue: %d\n', sets(i).SheetVal);
  end

  % dynamic name #1
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicName1= char(words(1));

  if (debug >= 2)
    fprintf('\tdynamic\tname #1: %s\n', sets(i).DynamicName1);
  end

  % dynamic calc #1
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicCalc1= char(words(1));

  if (debug >= 2)
    fprintf('\t\tcalc #1: %s\n', sets(i).DynamicCalc1);
  end

  % dynamic dir #1
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicDir1= char(words(1));

  if (debug >= 2)
    fprintf('\t\tdir #1: %s\n', sets(i).DynamicDir1);
  end

  % dynamic value #1
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicValue1= str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\t\tvalue #1\n', sets(i).DynamicValue1);
  end

  % dynamic name #2
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicName2= char(words(1));

  if (debug >= 2)
    fprintf('\tdynamic\tname #2: %s\n', sets(i).DynamicName2);
  end


  % dynamic calc #2
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicCalc2= char(words(1));

  if (debug >= 2)
    fprintf('\t\tcalc #2: %s\n', sets(i).DynamicCalc2);
  end


  % dynamic dir #2
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicDir2= char(words(1));

  if (debug >= 2)
    fprintf('\t\tdir #2: %s', sets(i).DynamicDir2);
  end


  % dynamic value #2
  oneline = fgetl(fid);
  words=line2strs(oneline);
  sets(i).DynamicValue2= str2num(char(words(1)));

  if (debug >= 2)
    fprintf('\t\tvalue #2\n', sets(i).DynamicValue2);
  end


end

% Read groups data types
for i = 1:nGroups

  if (debug >= 1)
    fprintf('Processing Data Types for Group: %d\n', i);
  end

  %Header
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\theader line: %s\n', oneline);
  end

  %Ref Num
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\tref number: %s\n', oneline);
  end

  for n = 1:groups(i).numDatatypes
    oneline = fgetl(fid);
    words=line2strs(oneline);
    groups(i).dataTypes{n}=char(words(1));

    if (debug >= 2)
      fprintf('\tdata type %d: %s\n', n, ...
        groups(i).dataTypes{n});
    end
  end
end

% Read groups time lists
% Note time lists not implemented in ELCOM yet so just read header and ref
for i = 1:nGroups

  if (debug >= 1)
    fprintf('Processing Time Group: %d\n', i);
  end

  %Header
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\theader line: %s\n', oneline);
  end

  %Ref Num
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\tref number: %s\n', oneline);
  end

end

% read sets of output cells
for i = 1:nSets

  if (debug >= 1)
    fprintf('Processing Output Cells for Set: %d\n', i);
  end

  %Header
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\theader line: %s\n', oneline);
  end

  %Ref Num
  oneline = fgetl(fid);

  if (debug >= 3)
    fprintf('\tref number: %s\n', oneline);
  end

  sets(i).locn = [];
  for n = 1:sets(i).numCells
    oneline = fgetl(fid);

    if (debug >= 3)
      fprintf('\tread line: %d\n', n);
    end

    words=line2strs(oneline);
    sets(i).locn(n,1)=str2num(char(words(1)));
    sets(i).locn(n,2)=str2num(char(words(2)));
    sets(i).locn(n,3)=str2num(char(words(3)));
    sets(i).locn(n,4)=str2num(char(words(4)));

    if (debug >= 3)
      fprintf('\tlocation: %d is: %d\t%d\t%d\t%d\n', ...
        n, sets(i).locn(n,1), sets(i).locn(n,2), ...
        sets(i).locn(n,3), sets(i).locn(n,4));
    end

  end
end
fclose(fid);
end

