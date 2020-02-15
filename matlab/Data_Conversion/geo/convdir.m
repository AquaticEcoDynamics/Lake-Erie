% Convert nautical directions to cartesian directions and vice-versa
%
% dir2 = convdir(dir1,'wind')
% dir2 = convdir(dir1,'wave')
% dir2 = convdir(dir1,'current')
%
function dir2 = convdir(dir1,varargin)

if nargin==1
    error('Please specify direction convention')
elseif nargin==2
    if strcmp(varargin{1},'wind')
        curr = false;
    elseif strcmp(varargin{1},'wave')
        curr = false;
    elseif strcmp(varargin{1},'current')
        curr = true;
    else
        error('Optional argument should be either ''wind'', ''wave'' or ''current''')
    end
else
    error('Expecting only 1 optional argument')
end
    
if ~curr % wind convention
    dir2 = 270 - dir1;
else % current
    dir2 = 90 - dir1;
end
    
dir2 = dir2 .* ((dir2>=0) & (dir2<=360)) ...
    + (dir2+360) .* (dir2<0) + (dir2-360) .* (dir2>360);