function data = tfv_readBCfile(filename)
%--% a simple function to read in a TuflowFV BC file and return a
%structured type 'data', justing the headers as variable names.
%
% Created by Brendan Busch

if ~exist(filename,'file')
    disp('File Not Found');
    return
end

data = [];

fid = fopen(filename,'rt');

sLine = fgetl(fid);

headers = regexp(sLine,',','split');
headers = regexprep(headers,'\s','');
EOF = 0;
inc = 1;
while ~EOF
    
    sLine = fgetl(fid);
    
    if sLine == -1
        EOF = 1;
    else
        dataline = regexp(sLine,',','split');
        
        for ii = 1:length(headers);
            
            if strcmpi(headers{ii},'ISOTime')
                data.Date(inc,1) = datenum(dataline{ii},...
                                        'dd/mm/yyyy HH:MM');
            else
                data.(headers{ii})(inc,1) = str2double(dataline{ii});
            end
        end
        inc = inc + 1;
    end
end

    
    