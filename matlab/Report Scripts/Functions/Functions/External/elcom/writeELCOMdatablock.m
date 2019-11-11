function [] = writeELCOMbathy(filename,groups,sets)
% function [] = writeELCOMbathy(filename,bathStruct)
%
% Inputs:
%		filename   : filename of datablock file t write
%		groups     : a matlab structure that contains all the group data
%                    usually read from readELCOMdatablock
%		sets       : a matlab structure that contains all the group data
%                    usually read from readELCOMdatablock
%
% Written by C. Dallimore 31 August 04
%

% Open file
fid = fopen(filename,'w');
ngroups = length(groups);
nsets = length(sets);

fprintf(fid,'DATABLOCK DESCRIPTION FILE \n');
fprintf(fid,'1.1.a                   ! datablock version\n');
fprintf(fid,[num2str(ngroups),'                       ! number of output groups\n']);
fprintf(fid,[num2str(nsets),'                       ! number of output sets\n']);
for i = 1:ngroups
  fprintf(fid,['BEGIN GROUP_DESCRIPTION\n']);
  fprintf(fid,[num2str(groups(i).RefNum),'                     ! group reference number\n']);
  fprintf(fid,[groups(i).Label,'               ! user label\n']);
  fprintf(fid,[groups(i).filename,'           ! output filename\n']);
  fprintf(fid,[num2str(groups(i).setRefNum),'                  ! set reference number\n']);
  fprintf(fid,[num2str(groups(i).numDatatypes),'                  ! number of datatypes in group\n']);
  fprintf(fid,[num2str(groups(i).isTimeInterval),'                  ! is_interval? logical: true if time step interval is used for output\n']);
  fprintf(fid,[num2str(groups(i).timeInterval),'                  ! output interval\n']);
  fprintf(fid,[num2str(groups(i).startTime),'                  ! output start time\n']);
  fprintf(fid,[num2str(groups(i).endTime),'                  ! output end time, 0 indicates entire run\n']);
  fprintf(fid,[num2str(groups(i).timeListSize),'                  ! size of time list, non-zero only if is_interval = .FALSE.\n']);
end
for i = 1:nsets
  fprintf(fid,['BEGIN SET_DESCRIPTION\n']);
  fprintf(fid,[num2str(sets(i).RefNum),'                     ! set reference number\n'])        ;
  fprintf(fid,[sets(i).Label,'                ! user label\n'])                                 ;
  fprintf(fid,[sets(i).Type,'                ! type of set\n'])                                 ;
  fprintf(fid,[num2str(sets(i).numCells),'                       ! number of cells in set\n'])  ;
  fprintf(fid,[sets(i).SheetType,'                 ! sheet type\n'])                            ;
  fprintf(fid,[sets(i).SheetCalc,'                 ! sheet calc\n'])                            ;
  fprintf(fid,[num2str(sets(i).SheetVal),'                     ! sheet value\n'])               ;
  fprintf(fid,[sets(i).DynamicName1,'                    ! dynamic name #1\n'])                 ;
  fprintf(fid,[sets(i).DynamicCalc1,'                    ! dynamic calc #1\n'])                 ;
  fprintf(fid,[sets(i).DynamicDir1,'                    ! dynamic direction #1\n'])             ;
  fprintf(fid,[num2str(sets(i).DynamicValue1),'                     ! dynamic value #1\n'])     ;
  fprintf(fid,[sets(i).DynamicName2,'                    ! dynamic name #2\n'])                 ;
  fprintf(fid,[sets(i).DynamicCalc2,'                    ! dynamic calc #2\n'])                 ;
  fprintf(fid,[sets(i). DynamicDir2,'                    ! dynamic direction #2\n'])            ;
  fprintf(fid,[num2str(sets(i).DynamicValue2),'                     ! dynamic value #2\n'])     ;
end

for i = 1:ngroups
  fprintf(fid,['BEGIN GROUP_DATA_TYPES\n']);
  fprintf(fid,[num2str(groups(i).RefNum),'                     ! group reference number\n']);
  for j = 1:length(groups(i).dataTypes)
    fprintf(fid,[groups(i).dataTypes{j},'\n'])            ;
  end
end
for i = 1:ngroups
  fprintf(fid,['BEGIN GROUP_TIME_LIST\n']);
  fprintf(fid,[num2str(groups(i).RefNum),'                     ! group reference number\n']);
end
for i = 1:nsets
  fprintf(fid,['BEGIN SET_CELL_DATA\n']);
  fprintf(fid,[num2str(sets(i).RefNum),'                     ! set reference number\n'])        ;
  for j = 1:size(sets(i).locn,1)
    fprintf(fid,[num2str(sets(i).locn(j,:)),'\n'])            ;
  end
end


fclose(fid)


