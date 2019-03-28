function modelpath = buildFilePath(fullpath,server,paths,userdata)
% Function to scroll through eash simulation requested and build the file
% path

comp = computer;

switch comp
    case 'PCWIN64'
        compType = 'windows';
    case 'MACI64'
        compType = 'apple';
    case 'MACI'
        compType = 'apple';
    otherwise
        compType = 'linux';
end

for ii = 1:length(userdata.simulation)
    proj = cell2mat(userdata.simulation(ii).project);
    startpath = server.([cell2mat(userdata.simulation(ii).server)]).([compType]);
    endpath = paths.([proj]);
    if strcmpi(userdata.type,'sheet') > 0
        modelpath(ii) = {[startpath,endpath,cell2mat(userdata.simulation(ii).folder),...
            '/ncfiles/sheet_',cell2mat(userdata.defaults.([lower(cell2mat(userdata.type))]).type),'.nc']};
    else
        modelpath(ii) = {[startpath,endpath,cell2mat(userdata.simulation(ii).folder),...
            '/ncfiles/curtain_lat.nc']};
    end
end