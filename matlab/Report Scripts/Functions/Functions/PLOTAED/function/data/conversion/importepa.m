function EPA = importEPA(filename,comp)
% Function to ...
warning off
[num,str] = xlsread(filename);
[compN,compS] = xlsread(comp);

varname = compS(:,1);
aedname = compS(:,2);
if strcmp('fielddata.xls',filename(end-12:end)) > 0
    varlist = str(1,3:end);
else
    varlist = str(1,5:end);
end
EPA.Site = (str(3:end,1));
EPA.Date = datenum(str(3:end,2),'dd/mm/yyyy HH:MM');
for ii = 1:length(varlist)
    matc = strmatch(varlist(ii),varname);
    if ~isempty(matc)
            EPA.([aedname{matc(1)}]) = num(:,ii)*compN(matc(1));
    end
end
        
    