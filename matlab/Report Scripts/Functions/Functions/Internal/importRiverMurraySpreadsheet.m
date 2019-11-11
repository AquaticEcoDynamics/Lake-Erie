function data = importRiverMurraySpreadsheet(filename)
% Function to import the Data.Rivermurray spreadsheet and pass back a variable data
% Only works with xls on a mac...
if(strcmp(computer,'MACI') >0)
    holding = xlsread(filename);
    ss = find(~isnan(holding(:,1)) >0);
    DD = excel2dates(holding(ss,1));
    
    for ii = 1:length(DD.Day)
        newString = [num2str(DD.Day(ii)),'/',num2str(DD.Month(ii)),'/',num2str(DD.Year(ii))];
        
        data.Dates(ii) = datenum(newString);
    end
    
    data.Level = holding(ss,2);
else
    % Site Name
    [junk,siteString] = xlsread(filename,'B1:B1');
    
    data.SiteName = siteString;
    % Dates
    %     [junk, dateS] = xlsread(filename,'A3:A200000');
    %
    %     for ii = 1:length(dateS)
    %         holding = dateS{ii};
    %         data.Dates(ii) = datenum(holding,'dd/mm/yyyy');
    %     end
    
    %     data.Dates = matlab2CWRdate(data.Dates)';
    
    % Variables
    [~, headers] = xlsread(filename,'A2:BB2');
    [num,dateS] = xlsread(filename,'A4:BB300000');
    [~,~,chx] = xlsread(filename,'B4:BB300000');

    for ii = 1:length(headers)
        count = 1;
        for kk = 1:length(dateS)
            if strcmp(headers(ii),'Date') >0
                if ~isempty(dateS(kk))
                    holding = dateS{kk};
                    if length(holding) > 12
                        
                        ident = holding(end-1:end);
                        
                        data.Dates(kk) = datenum(holding,['dd/mm/yyyy HH:MM:SS ',ident]);%,'dd/mm/yyyy'));
                    else
                        data.Dates(kk) = datenum(holding,'dd/mm/yyyy');%,'dd/mm/yyyy'));
                    end
                else
                    data.Dates(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'Level (m)') > 0
                if strcmp(chx(kk,2),'---') <1
                    data.Level(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.Level(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'Water Temp. (Deg.C)') > 0
                if strcmp(chx(kk),'---') <1
                    data.Temp(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.Level(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'Wind Direction') > 0
                if strcmp(chx(kk),'---') <1
                    
                    data.WindDir(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.WindDir(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'Wind Spd (km/h)') > 0
                if strcmp(chx(kk),'---') <1
                    
                    data.WindSpd(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.WindSpd(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'pH') > 0
                if strcmp(chx(kk),'---') <1
                    
                    data.pH(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.pH(kk) = NaN;
                end
            end
            if strcmp(headers(ii),'EC corrected (uS/cm)') > 0
                if strcmp(chx(kk),'---') <1
                    
                    data.Conductivity(kk) = num(count,ii-1);
                    count = count+1;
                else
                    data.Conductivity(kk) = NaN;
                end
            end
        end
    end
end
end
%%