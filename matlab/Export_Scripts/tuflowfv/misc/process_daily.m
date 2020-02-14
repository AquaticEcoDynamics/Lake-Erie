function [xdata_d,ydata_d] = process_daily(xdata,ydata)

xdata_d = unique(floor(xdata));

for i = 1:length(xdata_d)
    ss = find(floor(xdata) == xdata_d(i));
    ydata_d(i) = mean(ydata(ss));
end