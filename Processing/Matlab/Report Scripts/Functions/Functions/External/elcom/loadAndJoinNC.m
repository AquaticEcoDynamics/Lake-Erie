function [d1] = loadAndJoinNC(varargin)% function [data] = loadAndJoinNC(filename1,filename2,filename3, ...,namelist)%% Load and Join two or more ELCOM netcdf files% Inputs:%		filenames   : filenames of ncfiles%   namelist    : a cell array of strings giving%                     variables to load%                     eg: {'TEMPERATURE','TRACER_1'}% Outputs%   data        : a matlab structure of combined netcdf data%% Uses:%		nldnc.m%% Written by C. Dallimore 25 Jan 04%if (nargin < 2)  error('Too few input arguments');enddontJoin = {'X','Y','Z','S','Zhts','S_HEIGHT','BATHY','Bathym', ...      'DX','DY','BTM_CD','DX_i','DY_j','latitude','longitude' ...      'Xway_pts','Yway_pts','DZ','Iway_pts','Jway_pts', ...      'DXway_pts','DYway_pts','utm_x','utm_y','utm_zone1','utm_zone2' ...      };% check for namelistif iscellstr(varargin{nargin})  nfiles = nargin -1;  namelist = varargin{nargin};else  nfiles = nargin;  namelist = [];endfor i = 1:nfiles  disp (['Loading file: ',varargin{i}]);  if i == 1    d1 = nldnc (varargin{i},namelist);    fields = fieldnames(d1);  else    d2 = nldnc (varargin{i},namelist);    fields2 = fieldnames(d2)    if length(fields) ~=length(fields2)      error('Files incompatible: netcdf files must have same fields');    end    if ~all(strcmp(fields,fields))      error('Files incompatible: netcdf files must have same fields');    end    % Find pts with T before T already loaded and cat to start    %keyboard    pts = find (d2.T < min(d1.T));    if ~isempty(pts)      for n = 1:length(fields)        f = char(fields(n));        if (~any(strcmp(f,dontJoin)))          % Profiles variables need to be horizontally cated          if strmatch('Locn',f) == 1            cmd = ['d1.',f,' = horzcat(d2.',f,'(:,pts),d1.',f,');'];          else            cmd = ['d1.',f,' = vertcat(d2.',f,'(pts,:,:),d1.',f,');'];          end          eval (cmd);        end      end    end    % Find pts with T after T already loaded and cat to end    pts = find (d2.T > max(d1.T));    disp(pts)    if ~isempty(pts)      for n = 1:length(fields)        f = char(fields(n));        if (~any(strcmp(f,dontJoin)))          % Profiles variables need to be horizontally cated          if strmatch('Locn',f) == 1            disp(size(d1.Locn_2_2130_TEMPERATURE))            disp(size(d2.Locn_2_2130_TEMPERATURE))            cmd = ['d1.',f,' = vertcat(d1.',f,'(:,:),d2.',f,'(:,:));'];          else            cmd = ['d1.',f,' = vertcat(d1.',f,',d2.',f,'(pts,:,:));'];          end          disp(cmd)          eval (cmd);        end      end    end    clear d2;  endend