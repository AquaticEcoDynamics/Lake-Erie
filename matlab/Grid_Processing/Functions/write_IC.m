function write_IC(headers,data2,filename)
disp(['Writing: ',filename]);

fid = fopen(filename,'wt');

for i = 1:length(headers)
    if i == length(headers)
        fprintf(fid,'%s\n',headers{i});
    else
        fprintf(fid,'%s,',headers{i});
    end
end

for j = 1:length(data2)
    for i = 1:length(headers)
        
        if i == 1
            fprintf(fid,'%d,',data2(j,i));
        else
            if i == length(headers)
                fprintf(fid,'%4.4f\n',data2(j,i));
            else
                fprintf(fid,'%4.4f,',data2(j,i));
            end
        end
    end
end
fclose(fid);
