function [oxy_metrics] = calcSwanOxyMetrics(simfile,curtainfile)
% function [oxy_metrics] = calcSwanOxyMetrics(simfile,curtainfile)
%
% Inputs:
%		simfile   : filename of TUFLOW_FV netcdf simulation file
%       curtainfile  : filename of text file containing x,y points for the
%       thalwig location
%  
% Outputs
%		oxy_metrics   : contains time series and bulk normalised parameters
%		used to decribe metrics to measure efficiency of oxygenation plants
%		in the Swan river at Guildford and Caversham
%
% Uses
%       tfv_readnetcdf
%
%
% Written by L. Bruce 12 February 2013 specifically for Swan River data


%First extract simulated time domain data from file
%Get date time series converted to MATLAB dates
ncid = netcdf.open(simfile,'NC_NOWRITE');
time_id = netcdf.inqVarID(ncid,'ResTime');
time_units = netcdf.getAtt(ncid,time_id,'long_name');
time_datum = datenum(time_units(end-18:end),'dd/mm/yyyy HH:MM:SS');
time_hours = netcdf.getVar(ncid,time_id);
sim_time = time_datum + time_hours/24;

%Next read in simulation oxygen data
disp('Loading WQ_AED_OXYGEN_OXY');
oxyData = tfv_readnetcdf(simfile,'names',{'WQ_AED_OXYGEN_OXY'});
oxy = oxyData.WQ_AED_OXYGEN_OXY;

%Next read in simulation tracer data
disp('Loading TRACE_1');
traceData = tfv_readnetcdf(simfile,'names',{'TRACE_1'});
trace = traceData.TRACE_1;

%Simulaton depths and cell geometry data
disp('Loading layerface_Z');
simDepths = tfv_readnetcdf(simfile,'names',{'layerface_Z'});
simGeo = tfv_readnetcdf(simfile,'timestep',1);
A_estuary = sum(simGeo.cell_A);

%Bottom indexes
bot_indx = cumsum(str2num(int2str(simGeo.NL)));
%Surface indexes
surf_indx = [1 bot_indx(1:end-1)' + 1];

%Determine distance matrix for each cell (distance from Narrows Bridge)
%Get distance from estuary mouth from curtainxy
curtain_xy = load(curtainfile);

curt_x = double(curtain_xy(:,1));
curt_y = double(curtain_xy(:,2));

%Get array of distance from estuary mouth
L_est_xy = cumsum(sqrt((curt_x(2:end) - curt_x(1:end-1)).^2 + ...
                       (curt_y(2:end) - curt_y(1:end-1)).^2));
L_est_xy = [0; L_est_xy];
 
%--% Search each 2D cell routine
for ii = 1:length(simGeo.cell_X)
    pnt_x = simGeo.cell_X(ii);
    pnt_y = simGeo.cell_Y(ii);
    %Find point on thalweg closest to cell
    [~, pt_id] = min(sqrt((curt_x - pnt_x).^2 + (curt_y - pnt_y).^2));
    %Distance of cell from down stream boundary (Narrows)
    cell_L_est(ii) = L_est_xy(pt_id);
end

%Get start and finish indexes for oxyplant region at this stage 19-26km
L_oxy_start_i = find(cell_L_est>=19000,1,'first');
L_oxy_end_i = find(cell_L_est>26000,1,'first');
%Get area of oxyplant
A_oxy_plant = sum(simGeo.cell_A(L_oxy_start_i:L_oxy_end_i));

%Determine L for each 3D cell
for ii = 1:length(simGeo.idx2)
    cell3D_L_est(ii) = cell_L_est(simGeo.idx2(ii));
end


%Tracer metrics
%1) For each time determine index of cells <5 (5% of oxy inflows)
%2) Find minimum and maximum dist_x for these cells
%3) Calculate upstream, downstream and full range as time series

for time_i = 1:length(sim_time)
    trace_gt_5_i = find(trace(:,time_i) >= 5.0);
    if isempty(trace_gt_5_i)
        %Distance from narrows that 5% tracer reaches downstream of plant
        L_trace5_ds(time_i) = 0.0;
        %Distance from narrows that 5% tracer reaches upstream of plant
        L_trace5_us(time_i) = 0.0;
        %Range of tracer >5%
        L_trace5_range(time_i) = 0.0;
    else
        %Distance from narrows that 5% tracer reaches downstream of plant
        L_trace5_ds(time_i) = cell3D_L_est(min(trace_gt_5_i));
        %Distance from narrows that 5% tracer reaches upstream of plant
        L_trace5_us(time_i) = cell3D_L_est(max(trace_gt_5_i));
        %Range of tracer >5%
        L_trace5_range(time_i) = L_trace5_us(time_i) - L_trace5_ds(time_i);
    end
end


%Oxygen metrics
%1) For each time determine index of cells <2mg/m3 (62.5 mmol/m3) and index
%of cells < 4mg/m3 (125. mmol/m3)
%2) Find minimum and maximum dist_x for these cells
%3) Calculate upstream, downstream and full range as time series
for time_i = 1:length(sim_time)
    time_i
    if isempty(find(oxy(:,time_i) < 62.5, 1))
        %Distance from narrows that anoxia tracer reaches downstream of plant
        L_DO2_ds(time_i) = 0.0;
        %Distance from narrows that anoxia tracer reaches upstream of plant
        L_DO2_us(time_i) = 0.0;
        %Range of anoxia
        L_DO2_range(time_i) = 0.0;
    else
        %Distance from narrows that 5% tracer reaches downstream of plant
        L_DO2_ds(time_i) = cell3D_L_est(find(oxy(:,time_i) >= 5.0,1,'first'));
        %Distance from narrows that 5% tracer reaches upstream of plant
        L_DO2_us(time_i) = cell3D_L_est(find(oxy(:,time_i) >= 5.0,1,'last'));
        %Range of tracer >5%
        L_DO2_range(time_i) = L_DO2_us(time_i) - L_DO2_ds(time_i);
    end
    if isempty(find(oxy(:,time_i) < 125.0, 1))
        %Distance from narrows that 5% tracer reaches downstream of plant
        L_DO4_ds(time_i) = 0.0;
        %Distance from narrows that 5% tracer reaches upstream of plant
        L_DO4_us(time_i) = 0.0;
        %Range of tracer >5%
        L_DO4_range(time_i) = 0.0;
    else
        %Distance from narrows that 5% tracer reaches downstream of plant
        L_DO4_ds(time_i) = cell3D_L_est(find(oxy(:,time_i) >= 5.0,1,'first'));
        %Distance from narrows that 5% tracer reaches upstream of plant
        L_DO4_us(time_i) = cell3D_L_est(find(oxy(:,time_i) >= 5.0,1,'last'));
        %Range of tracer >5%
        L_DO4_range(time_i) = L_DO4_us(time_i) - L_DO4_ds(time_i);
    end
end

%Cut out other cells
cell_A_oxy = simGeo.cell_A;
cell_A_oxy(1:L_oxy_start_i-1) = 0.0;
cell_A_oxy(L_oxy_end_i+1:end) = 0.0;

for time_i = 1:length(sim_time)
    %Determine %cell area with anoxic and hypoxic bottom waters
    Apc_DO2(time_i) = sum(simGeo.cell_A(oxy(bot_indx,time_i) < 62.5))/A_estuary * 100;
    Apc_DO4(time_i) = sum(simGeo.cell_A(oxy(bot_indx,time_i) < 125.))/A_estuary * 100;
    
    %Determine %oxyplant area with anoxic and hypoxic bottom waters
    Apc_oxy_DO2(time_i) = sum(cell_A_oxy(oxy(bot_indx,time_i) < 62.5))/A_oxy_plant * 100;
    Apc_oxy_DO4(time_i) = sum(cell_A_oxy(oxy(bot_indx,time_i) < 125.))/A_oxy_plant * 100;

end

%Diagnostics and metrics saved
oxy_metrics.sim_time = sim_time;
oxy_metrics.oxy = oxy;
oxy_metrics.trace = trace;
oxy_metrics.simGeo = simGeo;
oxy_metrics.simDepths = simDepths;

oxy_metrics.L_trace5_ds = L_trace5_ds;
oxy_metrics.L_trace5_us = L_trace5_us;
oxy_metrics.L_trace5_range = L_trace5_range;

oxy_metrics.Apc_DO2 = Apc_DO2;
oxy_metrics.Apc_DO4 = Apc_DO4;
oxy_metrics.Apc_oxy_DO2 = Apc_oxy_DO2;
oxy_metrics.Apc_oxy_DO4 = Apc_oxy_DO4;


%Name of .mat file to save to
savefile = [simfile(1:end-3),'_oxy_metrics.mat'];
save(savefile,'oxy_metrics','-mat');