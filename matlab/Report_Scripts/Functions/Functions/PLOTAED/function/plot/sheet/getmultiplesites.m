function group = getmultiplesites(site,userdata,siteID)
% Function to ...
%group(1) = siteID;
% ss = find((site.([cell2mat(userdata.simulation(1).project)]).group) == siteID);
% if length(ss) > 0
%     group = site.([cell2mat(userdata.simulation(1).project)]).ID(ss);
% end
group = [];
ss = find(site.(cell2mat(userdata.simulation(1).project)).group == siteID);

if length(ss) > 0
    eval(['group = site.',[cell2mat(userdata.simulation(1).project)],'.ID(ss);']);
end

