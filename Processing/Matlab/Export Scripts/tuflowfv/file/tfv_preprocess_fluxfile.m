function tfv_preprocess_fluxfile(filename,fileout)

fid = fopen(filename,'rt');
fid1 = fopen(fileout,'wt');
inc = 1;
while ~feof(fid)
    line = fgetl(fid);
    if size(line,2) > 2000
        fprintf(fid1,'%s\n',line);
        inc = inc + 1;
    end
end
fclose(fid);
fclose(fid1);