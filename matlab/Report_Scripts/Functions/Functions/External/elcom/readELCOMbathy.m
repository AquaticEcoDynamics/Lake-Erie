function [bathStruct] = readELCOMbathy(filename)
% function [bathStruct] = readELCOMbathy(filename)
%
% Inputs:
%		filename   : filename of bathymetry file
% Outputs
%		bathStruct : a matlab structure that contains all the
%			data in the file to rewrite this file use
%			writeELCOMbathy
%
% Uses:
%		line2strs.m
%		isF90comment.m
%
% Written by C. Dallimore 31 August 04
%

% Open file
fid = fopen(filename,'r');

line_count = 0;
x_count = 0;
y_count = 0;
z_count = 0;
bathStruct.dx = [];
bathStruct.dy = [];

% We read the hearder first as some bathy files are large...
% Everything before "BATHYMETRY DATA" is the header
end_header = 'BATHYMETRY DATA';
% Read file until end
eof = 0;

while (~eof)

  % grab a line from the file
  oneline = fgetl(fid);
  % incrament the line number
  line_count = line_count +1;

  % make sure we have data and it's not the end of the header
  if (isempty(oneline) | findstr(oneline,end_header))
    break;
  end

  % Skip all comments lines
  if (isF90comment(oneline))
    continue;
  end

  % Break each line up into strings
  words=line2strs(oneline);

  % each line should have at least two words
  if (length(words) > 1)
    word1 = char(words(1));
    word2 = char(words(2));
  else
    fprintf(2,'Could not find header on line: %d\n', line_count);
    continue;
  end
  % Fist word keyword, second variable string
  if (~isempty(findstr(word1,'FILE')))
    bathStruct.file = word2;
  elseif (~isempty(findstr(word1,'VERSION')))
    bathStruct.version = word2;
  % Second word keyword first word variable string
  elseif (~isempty(findstr(word2,'TITLE')))
    bathStruct.title = word1;
  elseif (~isempty(findstr(word2,'ANALYST')))
    bathStruct.analyst = word1;
  elseif (~isempty(findstr(word2,'ORGANIZATION')))
    bathStruct.organization = word1;
  elseif (~isempty(findstr(word2,'COMMENT')))
    bathStruct.comment = word1;
  elseif (~isempty(findstr(word2,'overwrite')))
    bathStruct.overwrite = word1;
  % Second word keyword first word number
  elseif (~isempty(findstr(word2,'x_rows')))
    bathStruct.x_rows = str2num(word1);
  elseif (~isempty(findstr(word2,'y_columns')))
    bathStruct.y_columns = str2num(word1);
  elseif (~isempty(findstr(word2,'z_layers')))
    bathStruct.z_layers = str2num(word1);
  elseif (~isempty(findstr(word2,'n_max')))
    bathStruct.n_max = str2num(word1);
  elseif (~isempty(findstr(word2,'land_value')))
    bathStruct.land_value = str2num(word1);
  elseif (~isempty(findstr(word2,'open_value')))
    bathStruct.open_value = str2num(word1);
  elseif (~isempty(findstr(word2,'north_x')))
    bathStruct.north_x = str2num(word1);
  elseif (~isempty(findstr(word2,'north_y')))
    bathStruct.north_y = str2num(word1);
  elseif (~isempty(findstr(word2,'true_north_x')))
    bathStruct.true_north_x = str2num(word1);
  elseif (~isempty(findstr(word2,'true_north_y')))
    bathStruct.true_north_y = str2num(word1);
  elseif (~isempty(findstr(word2,'x_grid')))
    bathStruct.x_grid = str2num(word1);
  elseif (~isempty(findstr(word2,'y_grid')))
    bathStruct.y_grid = str2num(word1);
  elseif (~isempty(findstr(word2,'dz')))
    z_count = z_count + 1;
    bathStruct.dz(z_count) = str2num(word1);
  elseif (~isempty(findstr(word2,'dx')))
    x_count = x_count + 1;
    bathStruct.dx(x_count) = str2num(word1);
  elseif (~isempty(findstr(word2,'dy')))
    y_count = y_count + 1;
    bathStruct.dy(y_count) = str2num(word1);
  elseif (~isempty(findstr(word2,'latitude')))
    bathStruct.latitude0 = str2num(word1);
  elseif (~isempty(findstr(word2,'longitude')))
    bathStruct.longitude0 = str2num(word1);
  elseif (~isempty(findstr(word2,'altitude')))
    bathStruct.altitude = str2num(word1);
  else
    fprintf(2,'Unreconised header line: %d\n', line_count);
  end
end

% keep a reference to the number of seen lines
header_lines = line_count;

%while (~eof)
%
%	% grab a line from the file
%	oneline = fgetl(fid);
%	% incrament the line number
%	line_count = line_count +1;
%
%	% Has a blank line snuck in?
%	if (isempty(oneline))
%		fprintf(2,'Empty Data line on: %d\n', line_count);
%		continue
%	end
%
%	% Skip all comments lines
%	if (isF90comment(oneline))
%		fprintf(2,'Commented line in Data (line on: %d).\n',...
%			line_count);
%		continue
%	end
%
%	% Might as well have a variable counter too
  data_count = 0;
  % We really should be in the data now...
  for i=1:bathStruct.x_rows
    %printf('Processing line: %d\n' i);
    for j=1:bathStruct.y_columns
      bathStruct.bathData(i,j) = fscanf(fid,'%f',1);
      data_count = data_count +1;
    end
    if (data_count ~= bathStruct.y_columns)
      fprintf(2, ...
    'Error: read %d columns, expecting %d on line: %d.\n',...
      data_count, bathStruct.y_columns, line_count);
    end
    line_count = line_count +1;
    data_count = 0;
  end
  lines_seen = line_count - header_lines;
  if (lines_seen ~= bathStruct.x_rows)
    fprintf(2, ...
    'Error: read %d rows, expecting %d.\n',...
    lines_seen, bathStruct.x_rows);
  end
%end

fclose(fid);

% generate dx and dy arrays if not plaid grid
if x_count == 0
  bathStruct.dx(1:bathStruct.x_rows) = bathStruct.x_grid;
end
if y_count == 0
  bathStruct.dy(1:bathStruct.y_columns) = bathStruct.y_grid;
end

% generate x and y arrays
bathStruct.x(1) = 0.5*(bathStruct.dx(1));
for i=2:bathStruct.x_rows
  bathStruct.x(i) = sum(bathStruct.dx(1:i)) - 0.5*bathStruct.dx(i);
end

bathStruct.y(1) = 0.5*(bathStruct.dy(1));
for j=2:bathStruct.y_columns
  bathStruct.y(j) = sum(bathStruct.dy(1:j)) - 0.5*bathStruct.dy(j);
end

% generate lon/lat and utm arrays
bathStruct.latitude = bathStruct.bathData*0;
bathStruct.longitude = bathStruct.bathData*0;
bathStruct.utm_x = bathStruct.bathData*0;
bathStruct.utm_y = bathStruct.bathData*0;
bathStruct.utmZone1 = bathStruct.bathData*0;
bathStruct.utmZone2 = bathStruct.bathData*0;

% Convert top left lat/lon to UTM coordinates
[utmx0, utmy0, utmZone0] = ll2utm (bathStruct.longitude0, bathStruct.latitude0);

% Get the angle of North clockwise from +ve x
beta = atan2(-1.0*bathStruct.north_y,bathStruct.north_x);

for i=1:bathStruct.x_rows
  for j=1:bathStruct.y_columns

    % Get UTM
    bathStruct.utm_x(i,j) = utmx0+(-1*sin(beta)*bathStruct.x(i)-cos(beta)*bathStruct.y(j));
    bathStruct.utm_y(i,j) = utmy0+(cos(beta)*bathStruct.x(i)-sin(beta)*bathStruct.y(j));

    % Convert to lat/lon
    % We are going to get into trouble here if we cross zones
    bathStruct.utmZone1(i,j) = utmZone0(1);
    bathStruct.utmZone2(i,j) = utmZone0(2);

    [bathStruct.longitude(i,j),bathStruct.latitude(i,j)] = ...
      utm2ll (bathStruct.utm_x(i,j), bathStruct.utm_y(i,j),utmZone0);

  end
end

function result = isF90comment(inputString)
firstword = sscanf(inputString,'%s');
if ~isempty(firstword)
  if firstword(1)=='!'
    result = 1==1;
    return;
  else
    result = 1==2;
    return;
  end
else
  result = 1==2;
  return;
end

% EOF
