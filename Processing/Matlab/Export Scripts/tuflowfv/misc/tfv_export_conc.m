function tfv_export_conc(filename,plotdate,plotdata,mod)

mod

fid = fopen(filename,'wt');

disp(filename);

[~,y] = size(plotdata);

fprintf(fid,'Date,');

for i = 1:length(mod)
    if i ==length(mod)
        fprintf(fid,'%s\n',mod(i).legend);
    else
        fprintf(fid,'%s,',mod(i).legend);
    end
end


for iii = 1:length(plotdate(:,1))
    
    fprintf(fid,'%s,',datestr(plotdate(iii,1),'dd/mm/yyyy HH:MM:SS'));
    
    for jjj = 1:y
        if jjj == y
        fprintf(fid,'%10.6f\n',plotdata(iii,jjj));
        else
          fprintf(fid,'%10.6f,',plotdata(iii,jjj));
        end
    end
    
    %fprintf(fid,'\n');
end

fprintf(fid,'\n');fprintf(fid,'\n');fprintf(fid,'\n');
fprintf(fid,'Median,')
for i = 1:y
    fprintf(fid,'%10.6f,',median(plotdata(:,i)));
end
fprintf(fid,'\n');fprintf(fid,'\n');fprintf(fid,'\n');
fprintf(fid,'Mean,')
for i = 1:y
    fprintf(fid,'%10.6f,',mean(plotdata(:,i)));
end



fclose(fid);