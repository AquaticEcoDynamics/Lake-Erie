function tfv_export_conc(filename,plotdate,plotdata,mod,def)

xl = def.datearray(1);




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


sss = find(plotdate(:,1) >= datenum(2016,07,01));
ttt = find(plotdate(:,1) < datenum(2016,07,01));

pdate(:,1) = plotdate(sss,1);
pdata(:,1) = plotdata(sss,1);
pdata(:,2) = plotdata(ttt,2);
pdata(:,3) = plotdata(ttt,3);

% plotdate(1:sss(1)) = plotdate(sss);
% plotdata(1:sss(1),1) = plotdata(sss,1);

for iii = 1:length(pdate(:,1))
    
    fprintf(fid,'%s,',datestr(pdate(iii,1),'dd/mm/yyyy HH:MM:SS'));
    
    for jjj = 1:y
        if jjj == y
        fprintf(fid,'%10.6f\n',pdata(iii,jjj));
        else
          fprintf(fid,'%10.6f,',pdata(iii,jjj));
        end
    end
    
    %fprintf(fid,'\n');
end

fprintf(fid,'\n');fprintf(fid,'\n');fprintf(fid,'\n');
fprintf(fid,'Median,')
for i = 1:y
    fprintf(fid,'%10.6f,',median(pdata(:,i)));
end
fprintf(fid,'\n');fprintf(fid,'\n');fprintf(fid,'\n');
fprintf(fid,'Mean,')
for i = 1:y
    fprintf(fid,'%10.6f,',mean(pdata(:,i)));
end



fclose(fid);