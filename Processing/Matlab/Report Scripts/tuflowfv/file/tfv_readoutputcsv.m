function data = tfv_readoutputcsv(filename)
%--% Function to import the MESH csv file to get date and time information
% which is missing from the netcdf file.
data = [];

fid = fopen(filename,'rt');

hLine = fgetl(fid);

headers = regexp(hLine,',','split');

var(1) = {'TIME'};
units(1) = {''};

for ii = 2:length(headers)
    
    full = regexp(headers{ii},'\s','split');
    
    var(ii) = full(1);
    
    units(ii) = regexprep(full(2),{'\s';'[';']'},'');
    
end

EOF = 0;
inc = 1;
while ~EOF
    sLine = fgetl(fid);
    if sLine == -1
        EOF = 1;
    else
        
        cLine = regexp(sLine,',','split');
        for ii = 1:length(var)
            if ii == 1
                data.TIME(inc) = datenum(cLine{1},'dd/mm/yyyy HH:MM:SS');
            else
                data.(var{ii})(inc) = str2num(cLine{ii});
            end
        end
        inc = inc + 1;
    end
end