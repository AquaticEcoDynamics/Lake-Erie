function [data] = tfv_readmesh(filename)
% Function to load in the 2dm data and store as structure

%--% Initialise structure
data = [];

fid = fopen(filename,'rt');

EOF = false;
ndInc = 1;
EQ = 1;
while ~EOF
    linestr = fgetl(fid);
    
    if linestr == -1
        EOF = true;
    else
        
        linespt = regexp(linestr,'\s','split');
        header = linespt{1};
        
        switch header
            
            case 'ND'
                data.ND(ndInc,1:3) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5})];
                ndInc = ndInc + 1;
            case 'E4Q'
                EQ = str2double(linespt{2});
                data.face(EQ,1:4) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5}) ...
                    str2double(linespt{6})];
            case 'E3T'
                EQ = str2double(linespt{2});
                data.face(EQ,1:4) = [str2double(linespt{3}) ...
                    str2double(linespt{4}) ...
                    str2double(linespt{5}) ...
                    str2double(linespt{3})];
            otherwise
                
                
        end
        clear linespt;
        
    end
    
    
end