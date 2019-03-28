function plotvalidationdata(val,site,variableID,group,userdata,actsite)
% Function to ...
 figure('visible',userdata.defaults.line.show{1});
 %set(gcf,'visible',userdata.defaults.line.show{1})
 set(gca,'fontname','calibri','box','off')
for ii = 1:length(group)

    siteID = group(ii);
    dwlID = site.([cell2mat(userdata.simulation(1).project)]).DWL{siteID};
    epaID = site.([cell2mat(userdata.simulation(1).project)]).EPA{siteID};
    wsID = site.(cell2mat(userdata.simulation(1).project)).Waterscope{siteID};
	olID = site.(cell2mat(userdata.simulation(1).project)).Waterscope{siteID};
    rmID = site.(cell2mat(userdata.simulation(1).project)).DataRiverMurray{siteID};
    
    % DWL
    if isfield(val,'DWL') > 0
    if strmatch(([dwlID]),fieldnames(val.DWL)) > 0
        if strmatch(lower(variableID),lower(fieldnames(val.DWL.([dwlID])))) > 0
            dwlData = val.DWL.([dwlID]).(upper(([variableID]))).val;
            dwlDate = val.DWL.([dwlID]).(upper(([variableID]))).Date;
            plot(dwlDate,dwlData,':b','displayname',...
			'DWL Field Data');hold on;
                %['DWL Field Data ' site.([cell2mat(userdata.simulation(1).project)]).name{actsite}]);hold on
        end
        clear DWL
    end
    end
    
    % Online Monitoring Data
    if strmatch(olID,char(fieldnames(val.OL)),'exact') > 0
        if strmatch(variableID,char(fieldnames(val.OL.(olID))),'exact') > 0
            o1 = plot(val.OL.(olID).Time,val.OL.(olID).(variableID),'.','displayname',...
			'Online Monitoring');hold on
        set(o1,'color',[0.6 0.6 0.6]);
                %['Online Monitoring ' wsID]);hold on
        end
    end
    
    % EPA
    
    if strmatch(variableID,fieldnames(val.EPA)) > 0
        ss = find(strcmp(val.EPA.([variableID]).Site,epaID)) > 0;
        if ~isempty(ss)
            scatter(val.EPA.([variableID]).Date(~isnan(val.EPA.([variableID]).val(ss))),...
                val.EPA.([variableID]).val(~isnan(val.EPA.([variableID]).val(ss))),...
                '+g','displayname',...
				'EPA Field Data');hold on
                %['EPA Field Data ' epaID]);hold on
        end
    end
    % RM
    if strmatch(rmID,fieldnames(val.RM),'exact') > 0
        if strmatch(variableID,fieldnames(val.RM.([rmID]))) > 0
            plot(val.RM.([rmID]).Dates,val.RM.([rmID]).([variableID]),'+r','displayname',...
				'RM Field Data');hold on
                %['River Murray Field Data ' rmID]);hold on
        end
    end
    % WS
    if strmatch(wsID,char(fieldnames(val.WS)),'exact') > 0
        if strmatch(variableID,char(fieldnames(val.WS.(wsID))),'exact') > 0
            plot(val.WS.(wsID).(variableID).Time,val.WS.(wsID).(variableID).Value,'+b','displayname',...
				'Waterscope');hold on
                %['Waterscope Field Data ' wsID]);hold on
        end
    end
	
	    % Online
    
end