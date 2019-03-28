function tfv_exportprocessedmodel_pt(datafile,outdir,depthname)
% Function to export the processed model data to the specified output
% directory.
% depthname can be either 'surface',or,'bottom'
% Written by Brendan Busch 03/12/2012


if ~exist(outdir,'dir')
    mkdir(outdir);
end

cell_id = fieldnames(datafile);

for ii = 1:length(cell_id)
    
    nCell = str2num(regexprep(cell_id{ii},'Cell',''));
    
    filename = [outdir,cell_id{ii},'_',depthname,'.csv'];
    
    vars = fieldnames(datafile.(cell_id{ii}));
    
    fid = fopen(filename,'wt');
    
    fprintf(fid,'Time,');
    
    for jj = 1:length(vars)
        if jj ~=length(vars)
            fprintf(fid,'%s,',vars{jj});
        else
            fprintf(fid,'%s\n',vars{jj});
        end
    end
    
    ptime = datafile.(cell_id{ii}).(vars{1}).Time;
    
    for jj = 1:length(ptime)
        
        fprintf(fid,'%s,',datestr(ptime(jj),'dd/mm/yyyy HH:MM:SS'));
        
        for kk = 1:length(vars)
            pval = datafile.(cell_id{ii}).(vars{kk}).(lower(depthname))(jj);
            if kk ~= length(vars)
                
                fprintf(fid,'%7.3f,',pval);
                
            else
                
                fprintf(fid,'%7.3f\n',pval);
            end
        end
    end
    fclose(fid);
end

        
        
