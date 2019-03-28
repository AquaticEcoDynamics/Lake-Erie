function plot_BC(filename,outdir)
%A simple function to load and plot a BC file.

%filename='BCs/lock1_inf_obs.csv';
%outdir = 'BCs/Images/Obs/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

data = tfv_readBCfile(filename);

vars = fieldnames(data);

for i = 1:length(vars)
    if strcmpi(vars{i},'Date') == 0
        
        
        xdata = data.ISOTime;
        ydata = data.(vars{i});
        
        opts.xlabel = 'Date';
        opts.ylabel = vars{i};
        
        opts.xlim = [min(data.ISOTime) max(data.ISOTime)];
        
        opts.title =[];
        
        opts.ylim = [];
        
        opts.savename = [outdir,vars{i},'.png'];
        
        plotbb(xdata,ydata,opts);
        
    end
end
