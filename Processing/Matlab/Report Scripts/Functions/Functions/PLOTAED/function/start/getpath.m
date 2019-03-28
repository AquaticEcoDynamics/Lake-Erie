function fullpath = getpath
% The script to control the aed plotting routine
pth = pwd;
pth = strrep(pth,'\','/');
fullpath.confpth = strrep(pth,'runtime','configuration');
fullpath.functionpth = strrep(pth,'runtime','function');
fullpath.outputpth = strrep(pth,'runtime','output');
fullpath.datapth = strrep(pth,'runtime','data');


