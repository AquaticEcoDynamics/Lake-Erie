function paths = readconfPATH(fullpath)
% Function to read the path spreadsheet and create a structured type called
% paths
warning off

[num,str] = xlsread([fullpath.confpth,'/project/paths.xls']);

for ii = 2:length(str)
    eval(['paths.',str{ii,1},'= ''',str{ii,2},''';']);
end
        
warning on
