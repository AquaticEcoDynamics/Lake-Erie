function nc = loadncfiles(modelpath,currentVariable,var,userdata,cax)
% Function to......
elcdVar(1) = {var.([currentVariable]).ELCD};
dep = var.([currentVariable]).Dependant;
if strcmp(dep,'None') < 1
    elcdVar(2) = {dep};
end

switch userdata.modeltype{1}
    case 'ELCD'
        nc(1:length(modelpath)) = struct('data',[]);
        
        for ii = 1:length(modelpath)
            disp(['Loading model ',cell2mat(userdata.simulation(ii).folder)])
            if exist(modelpath{ii},'file')
                nc(ii).data = nldnc(modelpath{ii},elcdVar);
                %nc(ii).data.matdate = CWRdate2matlab(nc(ii).data.Ordinal_Dates);
                years = floor(nc(ii).data.Ordinal_Dates/1000);
                days = nc(ii).data.Ordinal_Dates - (floor(nc(ii).data.Ordinal_Dates/1000) * 1000);
                nc(ii).data.matdate = datenum(years,1,days);
                if strcmpi(userdata.type,'sheet') > 0
                    hmin = cax.([currentVariable]).([userdata.defaults.sheet.region{1}]).min;
                    hmax = cax.([currentVariable]).([userdata.defaults.sheet.region{1}]).max;
                    if ~isnan(hmin)
                        nc(ii).data.hMin = hmin;
                        nc(ii).data.hMax = hmax;
                    else
                        nc(ii).data.hMin = min(min(min(nc(ii).data.([currentVariable]))));
                        nc(ii).data.hMax = max(max(max(nc(ii).data.([currentVariable]))));
                        if nc(ii).data.hMin == nc(ii).data.hMax
                            nc(ii).data.hMin = nc(ii).data.hMin - 0.1;
                        end
                    end
                end
            else
                error(['File ',modelpath{ii},' not found']);
            end
        end
        if strcmpi(userdata.type,'line') > 0
            nc = convertncdata(nc,currentVariable,var);
        end
        
    case 'Tuflow'
        
    case 'GETM'
        
end


