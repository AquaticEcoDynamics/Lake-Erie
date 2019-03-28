function data = importDWLBCcsv(filename)
% A simple function to import in the Data.RiverMurray (DWLBC) spreadsheets.
% The original import function used xlsread which is too slow.
% Written by Brendan Busch

%filename = 'E:\Studysites\RiverMurray\CEWH_2014\Data\DWLBC\brendan-busch/A4260902_Data_Water_Temperature.csv';

warning('off');  % Odd warning on date conversion
disp('****************************************************************');
% Get header information (Site and variable name);
tic;
fid= fopen(filename,'rt');

header1 = fgetl(fid);

temp = regexp(header1,',','split');

data.site = regexprep(temp{2},'"','');

header2 = fgetl(fid);

temp = regexp(header2,',','split');

var = regexprep(temp{2},'"','');

% Convert Variable name

switch var
    case 'Water Temp. (Deg.C)'
        varname = 'Temp';
        disp('Importing Tempertaure');
        
        dateformat = 'dd/mm/yyyy HH:MM';
        
    case 'EC corrected (uS/cm)'
        varname = 'Conductivity';
        disp('Importing Conductivity');
        
        dateformat = 'dd/mm/yyyy HH:MM';
    case 'Level (m)'
        varname = 'Level';
        disp('Importing Level');
        
        dateformat = 'dd/mm/yyyy HH:MM';
    case 'Tide/Estuary Lev (m)'  
        varname = 'Level';
        disp('Importing Tide');
        dateformat = 'HH:MM:SS dd/mm/yyyy';
        
    otherwise
        varname = 'Unknown';
        disp('Variable Unknown');
        dateformat = 'dd/mm/yyyy HH:MM';
end

    junk = fgetl(fid);

inc = 1;
% Now import in the data....
while ~feof(fid)
    
    line = fgetl(fid);
    
    temp = regexp(line,',','split');
    
    data.Date(inc,1) = datenum(temp{1},dateformat);
    data.(varname)(inc,1) = str2double(temp{2});
    
    inc = inc + 1;
    
end

totaltime = toc;

disp([num2str(inc-1),' Total Records Imported']);
disp(['Total Time: ',num2str(totaltime / 60),' minutes']);
disp('****************************************************************');



