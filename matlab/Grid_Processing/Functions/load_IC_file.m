function [headers,data] = load_IC_file(filename)
% A function to load an existing IC file into a variable called data.

disp(['Losding: ',filename]);

fid = fopen(filename,'rt');

headers = strsplit(fgetl(fid),',');

textformat = [repmat('%s ',1,length(headers))];

fid= fopen(filename,'rt');

datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');

for i = 1:length(headers)
    data(:,i) = str2doubleq(datacell{i});
end

fclose(fid);