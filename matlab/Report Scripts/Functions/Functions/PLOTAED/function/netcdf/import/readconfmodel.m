function model = readconfMODEL(fullpath)
% function to .....

warning off

[num,str] = xlsread([fullpath.confpth,'/model/model.xls']);

[l,w] = size(str);

for ii = 2:w
    model.rotation.([str{2,ii}]) = num(ii-1);
end

warning on