function EPA = processEPA(fullpath,userdata);
% Function to.....
direct = [fullpath.datapth,'/',cell2mat(userdata.simulation(1).project),'/raw/EPA/'];
comp = [fullpath.datapth,'/',cell2mat(userdata.simulation(1).project),'/sheets/config/EPAConversion.xls'];
fil = dir([direct,'*.xls']);
int = 1;
for ii = 1:length(fil)
    
    filename = fil(ii).name;
    if strncmp(fil(ii).name,'.',1) <1
        Final(int).data = importEPA([direct,filename],comp);
        int = int+1;
    end
end

for mm = 1:length(Final)
    mynames = fieldnames(Final(mm).data);
    for kk = 1:length(mynames)
        EPA.([mynames{kk}]).val = [];
        EPA.([mynames{kk}]).Date = [];
        EPA.([mynames{kk}]).Site = [];    
    end
end
for ii = 1:length(Final)
    names = fieldnames(Final(ii).data);
    for kk = 1:length(names)
        isdup = 0;
        if strcmp(names{kk},'Date') < 1 && strcmp(names{kk},'Site') < 1
            chx = regexp(names{kk},'_','start');
            if ~isempty(chx)
                if strncmp(names{kk},'PATH',4) < 1
                    sp = strsplit('_',names{kk});
                    main = sp(1);
                    %ss = find(isnan(Final(ii).data.([cell2mat(main)]))) > 0;
                    %Final(ii).data.([cell2mat(main)])(ss) = Final(ii).data.([names{kk}])(ss);
                    isdup = 1;
                    EPA.([main{1}]).val = [EPA.([main{1}]).val;Final(ii).data.([names{kk}])];
                    EPA.([main{1}]).Date = [EPA.([main{1}]).Date;Final(ii).data.Date];
                    EPA.([main{1}]).Site = [EPA.([main{1}]).Site;Final(ii).data.Site];
                end
            end
            if isdup ==0
                EPA.([names{kk}]).val = [EPA.([names{kk}]).val;Final(ii).data.([names{kk}])];
                EPA.([names{kk}]).Date = [EPA.([names{kk}]).Date;Final(ii).data.Date];
                EPA.([names{kk}]).Site = [EPA.([names{kk}]).Site;Final(ii).data.Site];
            end
        end
    end
end

outname = [fullpath.datapth,'/',cell2mat(userdata.simulation(1).project),'/mat/EPA.mat'];
save(outname,'EPA')








