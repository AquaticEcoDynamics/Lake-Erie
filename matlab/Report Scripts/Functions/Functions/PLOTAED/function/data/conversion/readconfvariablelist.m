function varlist = readconfVARIABLELIST(fullpath)
% Function to ...

warning off

[num,str] = xlsread([fullpath.confpth,'/variable/variablelist.xls']);

[l,w] = size(str);

for ii = 2:l
    varlist.([str{ii,1}])  = str(ii,2);
end

disp('Variables to plot ------')
disp(varlist)