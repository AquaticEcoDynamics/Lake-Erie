function site = readconfSITE(fullpath)
% Function to ...
warning off
getdir = dir([fullpath.confpth,'/site/']);
for ii = 1:length(getdir)
    if strncmp(getdir(ii).name,'.',1) < 1
        dirname = getdir(ii).name;
        fulldir = [fullpath.confpth,'/site/',dirname,'/site.xls'];
        [num,str,raw] = xlsread(fulldir);
        [l,w] = size(str);
        site.([dirname]).ID = num(:,1);
        site.([dirname]).group = num(:,2);
        
        site.([dirname]).name = str(2:end,3);
        site.([dirname]).region = str(2:end,4);
        site.([dirname]).DataRiverMurray = str(2:end,5);
        site.([dirname]).Waterscope = str(2:end,6);
        site.([dirname]).EPA = str(2:end,7);
        site.([dirname]).DWL = str(2:end,8);

        for jj = 9:w
            site.([dirname]).Datablock.([str{1,jj}]) = num(:,jj);
        end
    end
end
warning on
