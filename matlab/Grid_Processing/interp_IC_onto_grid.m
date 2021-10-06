clear all; close all;

addpath(genpath('Functions'));

existing = dir('v10_files\*.csv');

[~,~,~,~,oldX,oldY,oldID] = tfv_get_node_from_2dm('Erie_v5_Substrates_NS.2dm');

[~,~,~,~,newX,newY,newID] = tfv_get_node_from_2dm('Erie_V6_Substrates.2dm');

for i = 1:length(existing)
    filename = ['v10_files\',existing(i).name];
    
    [headers,data] = load_IC_file(filename);
    
    newfile = regexprep(filename,'.csv','_v11.csv');
    
    newfile = regexprep(newfile,'v10_files','v11_files');
    
    data2 = interp_data(data,oldX,oldY,newX,newY,newID);
    
    write_IC(headers,data2,newfile);
end