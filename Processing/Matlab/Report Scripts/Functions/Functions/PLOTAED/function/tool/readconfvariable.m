function var = readconfVARIABLE(fullpath)
% Function to .......

warning off

[num,str] = xlsread([fullpath.confpth,'/variable/variablenames.xls']);

[l,w] = size(str);

for ii = 2:l
    for jj = 2:w
        eval(['var.',str{ii,1},'.',str{1,jj},'=''',str{ii,jj},''';']);
    end
end

warning on