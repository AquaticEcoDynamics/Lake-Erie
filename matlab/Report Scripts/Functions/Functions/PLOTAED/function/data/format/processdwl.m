function DWL = processDWL(fullpath,userdata)
%Function to ...

direct = [fullpath.datapth,'/',cell2mat(userdata.simulation(1).project),'/raw/DWL/'];
fil = dir(direct);
outname = [fullpath.datapth,'/',cell2mat(userdata.simulation(1).project),'/mat/DWL/'];
for ii = 1:length(fil)
    filename = fil(ii).name;
    if strncmp(fil(ii).name,'.',1) <1
        fullname = strsplit('_',fil(ii).name);
        val = strsplit('.',fullname{end});
        val = regexprep(val{1},'(\<[a-z])','${upper($1)}');
        if isempty(strmatch('Tide',fullname)) ||...
                isempty(strmatch('Stream',fullname{end-1})) 
            disp(filename)
            data = importDWL([direct,filename]);
            f = strrep(data.val,'""','NaN');
            DWL.([fullname{1}]).([val]).val = cellfun(@str2num,f);
            DWL.([fullname{1}]).([val]).Date = data.matlab;
            save([outname,fullname{1},'_',val,'.mat'],'DWL')
            clear DWL
        end
        clear data
    end
end

