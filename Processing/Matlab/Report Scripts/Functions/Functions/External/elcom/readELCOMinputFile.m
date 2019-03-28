function [data,data_type,bcset_no,n_data,file_type,ierr] = readELCOMinputFile(filename)

% function [data,data_type,bcset_no,n_data,file_type,ierr] = readELCOMinputFile(filename)
%
% funcion to read ELCOM input file
%
% Inputs:
%		filename  : filename string
% Outputs
%		data      : matrix of data (1st column is time or depth)
%               If file is a profile file then data is a
%					      struct array with fields:
%						         CWRdate
%						         n_depths
%						         data  (1st row is depth)
%		data_type : cell array of data_types in file
%		bcset_no  : bcset no for each header (For initial condition files
%				        this gives i,j location of profile)
%		n_data 	  : no of data columns specified in header
%		file_type : File type (one of 'BC','PROFILE','INITIAL')
%
% Uses:
%		readELCOMinputFileHeader.m
%		line2strs.m
%
% Written by C. Dallimore 27 July 04

% Open file
fileno = fopen(filename);
if (fileno == -1)
  disp('ERROR in readELCOMbcfile file not found');
  data = [];
  data_type = [];
  bcset_no = [];
  n_data = [];
  file_type = '';
  ierr = 1;
  return
end
ierr = 0;

% Read header
[data_type,bcset_no,n_data,file_type,ierr] = readELCOMinputFileHeader(fileno);
if (ierr ~= 0)
  data = [];
  disp (['Error reading file header for: ',filename])
  return
end

% Read data
if (strcmp(file_type,'PROFILE'))
  eof = 0;
  i=0;
  while (~eof)
    tmp_str=fgetl(fileno);
    if ischar(tmp_str) & ~strcmp(tmp_str,'EOF') & ~isempty(tmp_str)
      i = i+1;
      tmp_nos=sscanf(tmp_str,'%f');
      data(i).CWRdate = tmp_nos(1);
      data(i).n_depths = tmp_nos(2);
      tmparray=zeros(n_data,data(i).n_depths);
      for j = 1:n_data
        tmp_str=fgetl(fileno);
        str_arr = line2strs(tmp_str);
        for d = 1:data(i).n_depths;
          tmparray (j,d)=str2num(str_arr{d+1});
        end
      end
      data(i).data=tmparray;
    else
      eof = 1;
    end
  end
else
  data=fread(fileno);
  data=char(data');
  data=str2num(data);
end
fclose(fileno);
