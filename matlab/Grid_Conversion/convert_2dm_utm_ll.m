clear all; close all;

infile = 'Erie_v5_Substrates.2dm';
outfile = 'Erie_v5_Substrates_LL.2dm';


fid = fopen(infile,'rt');
fidout = fopen(outfile,'wt');

while ~feof(fid)
    line = fgetl(fid);
    sptl = strsplit(line,' ');
    if strcmpi(sptl{1},'ND') == 1
        
        X = str2num(sptl{3});
        Y = str2num(sptl{4});
        [lat,lon]=utm2ll(X,Y,17);
        
        fprintf(fidout,'ND %s %4.4f %4.4f %s\n',sptl{2},lon,lat,sptl{5});
        
    else
        fprintf(fidout,'%s\n',line);
    end
end
fclose(fid);
fclose(fidout);