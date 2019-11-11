function fig = tfv_curtainplot_vs_fld(fld_dist,fld_data,tfv_dist,tfv_data)
% function fig = tfv_curtainplot_vs_fld(fld_dist,fld_data,tfv_dist,tfv_data)
%
% Inputs:
%       fld_dist     : distace downstream for each field station
%       fld_data       : matrix of field data and distance upstream
%       tfv_dist      : distance downstream for each tfv cell
%       tfv_data       : matrix of tfv output from TUFLOW model for
%       variable varname
%
% Outputs:
%
% Uses:
%     plot.m
%     fillyy.m
%
% Written by L. Bruce 11th August 2015
% Based on:
%MCMCPREDPLOT - predictive plot for mcmc results
%Written by Mr MATLAB MCMC
% $Revision: 1.4 $  $Date: 2007/08/22 16:10:58 $

%Set sizes for plots
[num_ts , num_cells] = size(tfv_data);

%Set limits for predictive plot as 2.5%, 50.0% and 97.5%
%pred_lims = [0.025,0.5,0.975];
pred_lims = [0.05,0.1,0.25,0.5,0.75,0.9,0.95];
num_lims = length(pred_lims);
nn = (num_lims+1)/2;

    %Get curtain series of predictive limits for variable varname
    for cell_i = 1:num_cells
       pred_lim_ts(:,cell_i) = plims(tfv_data(:,cell_i),pred_lims);
    end
    
    %Plot TUFLOW output for time period across curtain
    dimc = [0.9 0.9 0.9]; % dimmest (lightest) color
    fig = fillyy(tfv_dist,pred_lim_ts(1,:),pred_lim_ts(2*nn-1,:),dimc);
    hold on
    for plim_i=2:(nn-1)
      fillyy(tfv_dist,pred_lim_ts(plim_i,:),pred_lim_ts(2*nn-plim_i,:),dimc.*0.9.^(plim_i-1));
    end
    plot(tfv_dist,pred_lim_ts(nn,:),'-k');

    %Add field data as stars
    plot(fld_dist,fld_data,'*')

