function fieldloc = tfv_getfieldlocations(fielddata)
% Function to take the pre-processed field data locations and output a
% structured type "fieldloc" with the format:
% fieldloc.sitename.X / Y / Name

fieldloc = [];

sites = fieldnames(fielddata);

for ii = 1:length(sites)
    vars = fieldnames(fielddata.(sites{ii}));
    
    fieldloc.(sites{ii}).X = fielddata.(sites{ii}).(vars{1}).X;
    fieldloc.(sites{ii}).Y = fielddata.(sites{ii}).(vars{1}).Y;
    fieldloc.(sites{ii}).Name = fielddata.(sites{ii}).(vars{1}).Title;
end

    