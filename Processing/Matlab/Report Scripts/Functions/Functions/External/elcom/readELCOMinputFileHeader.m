function [data_type,bcset_no,n_data,file_type,ierr] = readELCOMinputFileHeader(fileno)

% function [data_type,bcset_no,n_data] = readELCOMinputFileHeader(fileno)
%
% funcion to read header of open ELCOM bcfile
%
% Inputs:
%		fileno    : file id of openfile
% Outputs
%		data_type : cell array of data_types in file
%		bcset_no  : bcset no for each header (For initial condition files
%				    this gives i,j location of profile)
%		n_data 	  : no of data columns specified in header
%		file_type : File type (one of 'BC','PROFILE','INITIAL','UPDATE','INIT_HORIZ')
%		ierr	  : Error flag 1 if error 0 otherwise
%
% Uses:
%		line2strs.m
%
% Written by C. Dallimore 27 July 04
%

data_type = [];
bcset_no = [];
n_data = [];
file_type = '';

ierr = 0;

% rewind file to start
frewind(fileno)

% Assume normal bc file
file_type = 'BC';


% read comment lines
comment = 1;
while (comment == 1)
	header=fgetl(fileno);
	% Check for end of ile
	if (header == -1 )
		ierr = 1;
		return
	end
	if isempty(header)
		ierr = 1;
		return
	end

	if (header(1) ~= '!')
		comment = 0;
		% Get number of data columns
		% need to add check for horiz init file
		[n_data,cnt,msg]=sscanf(header,'%i,%s');
		if (cnt < 1)
			ierr = 1;
			return
		end
		n_data = floor(n_data);
	end
end

comment = 1;
while (comment == 1)
	header=fgetl(fileno);
	if (header == -1)
		ierr = 1
		return
	end
	if (header(1) ~= '!')
		comment = 0;
		% Get obsolete time type
		timestamp=header;
	end
end

comment = 1;
while (comment == 1)
	header=fgetl(fileno);
	if (header == -1)
		ierr = 1
		return
	end
	if (header(1) ~= '!')
		comment = 0;
		% If 1st word is a string then file is a horizontal file
		tmp = line2strs(header);
		if any(isletter(tmp{1}))
			file_type = 'INIT_HORIZ';
			bcset_no = 0;
			data_type = tmp;
			return
		else
			% Get bcset indexes (i,j) for profile initial conditions)
			[bcset_no,cnt,msg]=sscanf(header,'%i');
			if (cnt < 1)
				ierr = 1;
				return
			end
		end
	end
end

comment = 1;
while (comment == 1)
	header=fgetl(fileno);
	if (header == -1)
		ierr = 1
		return
	end
	if (header(1) ~= '!')
		comment = 0;
		% Get headers
		data_type = line2strs(header);
	end
end

% Check to see if file is an initial condition file
if (strcmp(data_type{1},'DEPTH'))
	file_type = 'INITIAL';
end

% Check to see if file is a profile bc file
if (strcmp(data_type{2},'DEPTH'))
	file_type = 'PROFILE';
end

% Check to see if file is a update bc file
if (strcmp(data_type{1},data_type{2}))
	file_type = 'UPDATE';
end


