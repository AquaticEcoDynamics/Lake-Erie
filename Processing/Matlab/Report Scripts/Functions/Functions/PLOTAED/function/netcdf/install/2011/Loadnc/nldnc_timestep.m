function [data] = nldnc_timestep(ncobj,varNameCell,t)
% function [data] = nldnc_timestep(ncobj,varName,t)
%
% Inputs:
%		ncobj   :  a netcdf file object created  with command
%                 netcdf(filename, 'nowrite')
%              where filename is the name of the file from dbconv
%   varName :  variable name to load eg: 'TEMPERATURE'
%              if varName is a cellstr more thane one variable is loaded
%   t       :  timestep to load
% Outputs
%		data    : a matlab structure that contains the data from the timestep
%             and the relevant dimensions.
%
% Uses:
%
% Written by C. Dallimore 19 Jan 06
%


if ~iscell(varNameCell)
	varNameCell = {varNameCell};
end
variables = var(ncobj)

for j = 1:length(varNameCell)
	varName = varNameCell{j};
	% Get variable object

	ncVariable = [];
	for ii = 1:length(variables)
        disp(varName)
        disp(cellstr(name(variables{ii})))
		if strcmp(varName,cellstr(name(variables{ii})))
			ncVariable = variables{ii};
		end
	end

	if isempty(ncVariable)
		disp ('Variable not found.  Valid variables are')
		for i = 1:length(variables)
			self = variables{i};
			theNCid = ncid(self);
			theVarid = varid(self);
			[dimName, dimSize] = ncmex('varinq', theNCid, theVarid);
			disp(['  ',dimName])
		end
		continue
	end

	% Get dimensions of variable
	vardims = dim(ncVariable);

	%varcmd = sprintf('data.data = ncVariable (',char(varName))
	varcmd = ['data.',varName,' = ncVariable ('];
	for i = 1:length(vardims)

		self = vardims{i};
		theNCid = ncid(self);
		theDimid = dimid(self);
		[dimName, dimSize] = ncmex('diminq', theNCid, theDimid);
		for ii = 1:length(variables)
			if strcmp(dimName,cellstr(name(variables{ii})))
				dimVar = variables{ii};
			end
		end

		if (strcmp(dimName,'T'))
			if (t > dimSize)
				data = [];
				disp ('Timestep out of range')
				return
			end
			cmd = sprintf('data.%s = dimVar (t);',char(dimName));
			eval(cmd);
			dimName = 'Ordinal_Dates';
			for ii = 1:length(variables)
				if strcmp(dimName,cellstr(name(variables{ii})))
					dimVar = variables{ii};
				end
			end
			cmd = sprintf('data.%s = dimVar (t);',char(dimName));
			eval(cmd);

			tindex = i;
			varcmd = [varcmd,'t'];
		else
			cmd = sprintf('data.%s = dimVar (:);',char(dimName));
			eval(cmd);
			varcmd = [varcmd,':'];
		end
		if i ~= length(vardims)
			varcmd = [varcmd,','];
		else
			varcmd = [varcmd,');'];
		end
	end
	eval(varcmd);
	eval(['pts = find(data.',varName,' < -9.9e+16);']);
	eval(['data.',varName,'(pts) = NaN;']);
end

% Check for Free Surface Height
ncname = 'FreeSurfHeights';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.FreeSurfHeights = ncVariable (t,:);
end

% Check for Bathym
ncname = 'Bathym';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.Bathym = ncVariable (:);
	eval(['pts = find(data.',ncname,' < -9.9e+16);']);
	eval(['data.',ncname,'(pts) = NaN;']);
end

% Check for DX and DY
ncname = 'DX';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.DX = ncVariable (:,:);
	eval(['pts = find(data.',ncname,' < -9.9e+16);']);
	eval(['data.',ncname,'(pts) = NaN;']);
end
ncname = 'DY';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.DY = ncVariable (:,:);
	eval(['pts = find(data.',ncname,' < -9.9e+16);']);
	eval(['data.',ncname,'(pts) = NaN;']);
end
ncname = 'DX_i';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.DX_i = ncVariable (:);
	eval(['pts = find(data.',ncname,' < -9.9e+16);']);
	eval(['data.',ncname,'(pts) = NaN;']);
end
ncname = 'DY_j';
ncVariable =[];
for ii = 1:length(variables)
	if strcmp(ncname,cellstr(name(variables{ii})))
		ncVariable = variables{ii};
	end
end
if ~isempty (ncVariable)
	data.DY_j = ncVariable (:);
	eval(['pts = find(data.',ncname,' < -9.9e+16);']);
	eval(['data.',ncname,'(pts) = NaN;']);
end
