function tfv_export_load(filename,plotdate,plotdata,mod)

fid = fopen(filename,'wt');

disp(filename);

[~,y] = size(plotdata);


fprintf(fid,'Month,Year,');
for i = 1:length(mod)
    if i ==length(mod)
        fprintf(fid,'%s\n',mod(i).name);
    else
        fprintf(fid,'%s,',mod(i).name);
    end
end

for iii = 1:length(plotdate(:,1))
    fprintf(fid,'%s,%s,',datestr(plotdate(iii,1),'mm'),datestr(plotdate(iii,1),'yyyy'));
    
    for jjj = 1:y
        if jjj == y
            fprintf(fid,'%10.6f\n',plotdata(iii,jjj));
        else
            fprintf(fid,'%10.6f,',plotdata(iii,jjj));
        end
    end
    
    %fprintf(fid,'\n');
    
end
fclose(fid);