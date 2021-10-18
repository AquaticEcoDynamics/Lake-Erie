clear all; close all;

addpath(genpath('Functions'));

existing = dir('v10_files\*.csv');

[XX1,YY1,nodeID1,faces1,oldX,oldY,~,oldID] = tfv_get_node_from_2dm('Erie_v5_Substrates_NS.2dm');

[XX,YY,nodeID,faces,newX,newY,~,newID] = tfv_get_node_from_2dm('Erie_V6_Substrates.2dm');

vert(:,1) = XX;
vert(:,2) = YY;
vert1(:,1) = XX1;
vert1(:,2) = YY1;
for i = 1:length(existing)
    filename = ['v10_files\',existing(i).name];
    
    [headers,data] = load_IC_file(filename);
    
    newfile = regexprep(filename,'.csv','_v11.csv');
    
    newfile = regexprep(newfile,'v10_files','v11_files');
    
    data2 = interp_data(data,oldX,oldY,newX,newY,newID);
    
    
    

    
    write_IC(headers,data2,newfile);

    [headers,data3] = load_IC_file(newfile);

    
        cdata = data3(:,6);
    fig.ax = patch('faces',faces','vertices',vert,'FaceVertexCData',cdata);shading flat
    axis equal
    
    set(gca,'Color','None',...
        'box','on');
    
    
    figure
          cdata1 = data(:,6);
    fig.ax = patch('faces',faces1','vertices',vert1,'FaceVertexCData',cdata1);shading flat
    axis equal
    
    set(gca,'Color','None',...
        'box','on');  
    
    stop
    
    
end