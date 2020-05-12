clear all; close all;
load Lake_Erie_2013_20191126.mat;

addpath(genpath('geo'));

fd = fieldnames(LAKE_ERIE_2013);

erie_temp = [];

sites = fieldnames(LAKE_ERIE_2013.NYSDEC_OMNR_USGS);
for i = 1:length(sites)
    if isfield(LAKE_ERIE_2013.NYSDEC_OMNR_USGS.(sites{i}),'TOTAL_PHOSPHORUS')
        LAKE_ERIE_2013.NYSDEC_OMNR_USGS.(sites{i}).TOTAL_PHOSPHORUS.DATA = LAKE_ERIE_2013.NYSDEC_OMNR_USGS.(sites{i}).TOTAL_PHOSPHORUS.DATA/1000;
    end
end



[snum,sstr ] =xlsread('Conv.xlsx','A2:C10000');
oldN = sstr(:,1);
newN = sstr(:,2);
conv = snum(:,1);
agency = {'ECCC-WQ';'ECCC-CGM';'ECCC-PAR';'ECCC-HF';'OTHER'};% (NYSDEC, OMNR and USGS)
for i = [1 2 3 5]%1:length(fd)
    sites = fieldnames(LAKE_ERIE_2013.(fd{i}));
    for j = 1:length(sites)
        erie_temp.(sites{j}) = LAKE_ERIE_2013.(fd{i}).(sites{j});
        vars = fieldnames(erie_temp.(sites{j}));
        for k = 1:length(vars)
            erie_temp.(sites{j}).(vars{k}).source = agency{i};
        end
    end
    
    
end


sites = fieldnames(LAKE_ERIE_2013.ECCC_HYDRODYNAMIC.TEMPERATURE);
for j = 1:length(sites)
        erie_temp.(sites{j}).TEMP = LAKE_ERIE_2013.ECCC_HYDRODYNAMIC.TEMPERATURE.(sites{j});
        erie_temp.(sites{j}).TEMP.source = 'ECCC-HF';
        
        
end


% sites = fieldnames(LAKE_ERIE_2013.ECCC_HYDRODYNAMIC.VELOCITY);
% for j = 1:length(sites)
%     erie.(sites{j}).VELOCITY = LAKE_ERIE_2013.ECCC_HYDRODYNAMIC.VELOCITY.(sites{j});
% end




erie_mat = [];

sites = fieldnames(erie_temp);
for i = 1:length(sites)
    vars = fieldnames(erie_temp.(sites{i}));
    for j = 1:length(vars)
        if ~isfield(erie_temp.(sites{i}).(vars{j}),'time')
            erie_temp.(sites{i}).(vars{j}).Date(:,1) = datenum(erie_temp.(sites{i}).(vars{j}).DATE,'yyyy-mm-dd');
        else
            inc = 1;
            for bb = 1:length(erie_temp.(sites{i}).(vars{j}).time)
                for bdb = 1:size(erie_temp.(sites{i}).(vars{j}).data,2)
                    erie_temp.(sites{i}).(vars{j}).Date(inc,1) = datenum(2013,01,01) + erie_temp.(sites{i}).(vars{j}).time(bb);
                    erie_temp.(sites{i}).(vars{j}).DATA(inc,1) = erie_temp.(sites{i}).(vars{j}).data(bb,bdb);
                    erie_temp.(sites{i}).(vars{j}).DEPTH(inc,1) = erie_temp.(sites{i}).(vars{j}).depth(bdb);
                    inc = inc + 1;
                end
            end
            
        end
        erie_temp.(sites{i}).(vars{j}).Data(:,1) = erie_temp.(sites{i}).(vars{j}).DATA;
        
        if length(erie_temp.(sites{i}).(vars{j}).DEPTH) == length(erie_temp.(sites{i}).(vars{j}).DATA)
            erie_temp.(sites{i}).(vars{j}).Depth(:,1) = double(erie_temp.(sites{i}).(vars{j}).DEPTH);
        else
            erie_temp.(sites{i}).(vars{j}).Depth(1:length(erie_temp.(sites{i}).(vars{j}).DATA),1) = double(erie_temp.(sites{i}).(vars{j}).DEPTH);
        end
    end
end

sites = fieldnames(erie_temp);


for i = 1:length(sites)
    vars = fieldnames(erie_temp.(sites{i}));
    for j = 1:length(vars)
        for k = 1:length(erie_temp.(sites{i}).(vars{j}).Depth)
            if erie_temp.(sites{i}).(vars{j}).Depth(k) > 0
                erie_temp.(sites{i}).(vars{j}).Depth(k) = erie_temp.(sites{i}).(vars{j}).Depth(k) * -1;
            end
        end
    end
end




sites = fieldnames(erie_temp);
vars = [];
for i = 1:length(sites)
    vars = [vars;fieldnames(erie_temp.(sites{i}))];
end
uvars = unique(vars);

sites = fieldnames(erie_temp);

erie_mat = [];

for i = 1:length(sites)
    vars = fieldnames(erie_temp.(sites{i}));
    for j = 1:length(vars)
        
        ss = find(strcmpi(oldN,vars{j}) == 1);
        
        if ~isempty(ss)
                if strcmpi(newN(ss),'Ignore') == 0
                    erie_mat.(sites{i}).(newN{ss}) = erie_temp.(sites{i}).(vars{j});
                    erie_mat.(sites{i}).(newN{ss}).Data = erie_mat.(sites{i}).(newN{ss}).Data * conv(ss);
                end
        end
    end
end

sites = fieldnames(erie_mat);
for i = 1:length(sites)
    vars = fieldnames(erie_mat.(sites{i}));
    for j = 1:length(vars)
         erie_mat.(sites{i}).(vars{j}).Lat = erie_mat.(sites{i}).(vars{j}).Y;
         erie_mat.(sites{i}).(vars{j}).Lon = erie_mat.(sites{i}).(vars{j}).X;
         [erie_mat.(sites{i}).(vars{j}).X,erie_mat.(sites{i}).(vars{j}).Y] = ll2utm(erie_mat.(sites{i}).(vars{j}).Lon(1),erie_mat.(sites{i}).(vars{j}).Lat(1));
    end
end
         
         
        

%summerise_data(erie_mat,'New Images/','eriesites.shp')


save erie_mat.mat erie_mat -mat;
save ..\Compiled_Data_Import\erie_mat.mat erie_mat -mat;
  
