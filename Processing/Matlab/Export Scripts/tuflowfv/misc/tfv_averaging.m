function [xdata1,ydata1] = tfv_averaging(xdata,ydata,def)
% A simple function to either smooth or apply a daily averaging to the data

if isfield(def,'dailyave')
    
    if def.dailyave == 1
        xdata
        mVec = datevec(xdata);
        
        inc = 1;
        
        u_years = unique(mVec(:,1));
        u_months = unique(mVec(:,2));
        u_days = unique(mVec(:,3));
        for i = 1:length(u_years)
            
            for j = 1:length(u_months)
                
                for k = 1:length(u_days);
                    
                    ss = find(mVec(:,1) == u_years(i) & ...
                        mVec(:,2) == u_months(j) & ...
                        mVec(:,3) == u_days(k));
                    
                    
                    if ~isempty(ss)
                        
                        xdata1(inc,1) = datenum(u_years(i),u_months(j),u_days(k));
                        ydata1(inc,1) = sum(ydata(ss)) / length(ss);
                        inc = inc + 1;
                    end
                    
                    
                    
                    
                end
                
            end
        end
        ydata1 = smooth(ydata1,def.smoothfactor);
    else
        xdata1 = xdata;
        ydata1 = smooth(ydata,def.smoothfactor);
        
    end
    
else
    xdata1 = xdata;
    ydata1 = smooth(ydata,def.smoothfactor);
    
end








