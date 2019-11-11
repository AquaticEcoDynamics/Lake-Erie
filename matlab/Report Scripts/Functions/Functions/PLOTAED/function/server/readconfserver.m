function server = readconfSERVER(fullpath)
% Function to read the server spreadsheet and create a structured type called
% server
warning off

[num,str] = xlsread([fullpath.confpth,'/server/server.xls']);

for ii = 2:length(str)
    server.([str{ii,1}]).windows = str{ii,2};
    server.([str{ii,1}]).apple = str{ii,3};
    server.([str{ii,1}]).linux = str{ii,4};
end

warning on
