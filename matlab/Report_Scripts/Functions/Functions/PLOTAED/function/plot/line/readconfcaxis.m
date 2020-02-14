function cax = readconfCAXIS(fullpath)
% Function to read the caxis spreadsheet and create a structured type called
% cax
warning off

[num,str] = xlsread([fullpath.confpth,'/variable/caxis.xls']);
count = 1;
headersall = unique(str(1,2:end));
for ii =1:length(headersall)
    if isempty(headersall{ii}) < 1
        headers(count) = headersall(ii);
        count = count + 1;
    end
end

vars = str(3:end,1);
[l,w] = size(headers);
for ii = 1:length(vars)
    for jj = 1:w
        cax.([vars{ii}]).([headers{jj}]).min = num(ii,(jj*2)-1);
        cax.([vars{ii}]).([headers{jj}]).max = num(ii,(jj*2));
    end
end
        
warning on
        