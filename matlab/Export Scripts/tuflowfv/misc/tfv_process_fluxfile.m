function flux = tfv_process_fluxfile(filename,matfile,varlist)


fid = fopen(filename,'rt');

headers = strsplit(fgetl(fid),',');

num_cols = length(headers);

frewind(fid)
x  = num_cols;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

% Dates are the first column.
%disp('************** Processing Dates... *********************************');
mDates = datenum(datacell{:,1},'dd/mm/yyyy HH:MM:SS');
%disp('************** Finished Dates...   *********************************');


nodestrings = {};
for i = 1:length(headers)
    tt = strsplit(headers{i},'_');
    nodestrings(i) = tt(1);
end

uni_NS = unique(nodestrings,'stable');

data = [];

inc = 2;

for i = 2:length(uni_NS)
    for j = 1:length(varlist)
        data.(uni_NS{i}).(varlist{j}) = str2double(datacell{inc});
        inc = inc + 1;
        data.(uni_NS{i}).mDate = mDates;
    end
end


flux = data;

