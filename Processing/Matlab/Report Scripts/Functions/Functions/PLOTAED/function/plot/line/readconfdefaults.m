function opts = readconfDEFAULTS(fullpath)
% Function to read the defaults spreadsheet and create a structured type
% called opts
warning off
[num,str,raw] = xlsread([fullpath.confpth,'/plot/defaults.xls']);

% Title
opts.title.fontname = str(2,3);
opts.title.fontsize = num(1);
opts.title.fontweight = str(4,3);
opts.title.location = str(5,3);
opts.title.show = str(6,3);
% Colorbar
opts.colorbar.fontname = str(7,3);
opts.colorbar.fontsize = num(6);
opts.colorbar.fontweight = str(9,3);
opts.colorbar.location = str(10,3);
opts.colorbar.side = str(11,3);

%xaxis
opts.xaxis.fontname = str(12,3);
opts.xaxis.fontsize = num(11);
opts.xaxis.fontweight = str(14,3);
opts.xaxis.alignment = str(15,3);
opts.xaxis.color = str(16,3);
%yaxis
opts.yaxis.fontname = str(17,3);
opts.yaxis.fontsize = num(16);
opts.yaxis.fontweight = str(19,3);
opts.yaxis.alignment = str(20,3);
opts.yaxis.color = str(21,3);
% datetick
opts.datetick.format = str(22,3);
opts.datestamp.format = str(23,3);
opts.datestamp.location = str(24,3);
opts.line.height = num(23);
opts.line.width = num(24);
opts.sheet.height = num(25);
opts.sheet.width = num(26);
opts.line.joined = num(27);
opts.line.smoothdefault = num(28);

warning on









