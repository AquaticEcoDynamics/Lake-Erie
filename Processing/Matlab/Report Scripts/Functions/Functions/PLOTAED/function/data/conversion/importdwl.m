function data = importDWL(filename)
% Function To......
fid = fopen(filename,'r');
a = textscan(fid,'%s %s',1,'delimiter',',');
site = a(2);
data.site = strrep(site{1},'"','');

a = textscan(fid,'%s %s',1,'delimiter',',');
variablename = a{2};
data.variablename = strrep(variablename{1},'"','');

a = textscan(fid,'%s',1);
textformat = [repmat('%s ',1,3)];
indata = textscan(fid,textformat,'delimiter',',','Headerlines',3);
fclose(fid);
data.time = indata{1};
data.val = indata{2};
data.qual = indata{3};

data.matlab =datenum([data.time], 'HH:MM:SS dd/mm/yyyy');

