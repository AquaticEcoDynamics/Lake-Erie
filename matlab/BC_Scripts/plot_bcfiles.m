function plot_bcfiles(basedir)
%basedir = 'BCs/Flow/';

dirlist = dir([basedir,'*.csv']);

for k = 1:length(dirlist)
    disp(dirlist(k).name);
    outdir = [basedir,'Images/',regexprep(dirlist(k).name,'.csv',''),'/'];
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    
    data = tfv_readBCfile([basedir,dirlist(k).name]);
    
    datearray = [min(data.Date):(max(data.Date) - min(data.Date))/5:max(data.Date)];
    
    
    vars = fieldnames(data);
    
    for i = 1:length(vars)
        figure
        if strcmpi(vars{i},'Date') == 0
            
%             for j = 1:length(sites)
                name = regexprep(vars{i},'_','');
                
%                 if isfield(data.(sites{j}),vars{i})
                    
                    xdata = data.Date;
                    ydata = data.(vars{i});
                    
                    plot(xdata,ydata,'displayname',name);hold on
                    
                    
%                 end
%             end
            
            xlim([datearray(1) datearray(end)]);
            
            set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
            
            ylabel(upper(name),'fontsize',8);
            
            title(name);
            
            legend('location','NW');
            
            %--% Paper Size
            set(gcf, 'PaperPositionMode', 'manual');
            set(gcf, 'PaperUnits', 'centimeters');
            xSize = 21;
            ySize = 8;
            xLeft = (21-xSize)/2;
            yTop = (30-ySize)/2;
            set(gcf,'paperposition',[0 0 xSize ySize])
            
            %print(gcf,['Images_All/Guaged/',vars{i},'.eps'],'-depsc2','-painters');
            print(gcf,[outdir,sprintf('%03d',i),'_',vars{i},'.png'],'-dpng','-zbuffer');
            
            close all;
            
        end
    end
    
    
    
    
    
    
end

create_html_for_directory([basedir,'Images/']);
function data = tfv_readBCfile(filename)
%--% a simple function to read in a TuflowFV BC file and return a
%structured type 'data', justing the headers as variable names.
%
% Created by Brendan Busch

if ~exist(filename,'file')
    disp('File Not Found');
    return
end

data = [];

fid = fopen(filename,'rt');

sLine = fgetl(fid);

headers = regexp(sLine,',','split');
headers = upper(regexprep(headers,'\s',''));
EOF = 0;
inc = 1;

% The actual data import.__________________________________________________
frewind(fid)
x  = length(headers);
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

dateformatlong = 'dd/mm/yyyy HH:MM';

% Data Processing__________________________________________________________
for i = 1:length(headers)
    
    if i == 1
        data.Date(:,1) = datenum(datacell{1},dateformatlong);
    else
        data.(headers{i})(:,1) = str2doubleq(datacell{i});
    end
end

%  while ~EOF
%
%     sLine = fgetl(fid);
%
%     if sLine == -1
%         EOF = 1;
%     else
%         dataline = regexp(sLine,',','split');
%
%         for ii = 1:length(headers);
%
%             if strcmpi(headers{ii},'ISOTime')
%                 data.Date(inc,1) = datenum(dataline{ii},...
%                                         'dd/mm/yyyy HH:MM');
%             else
%                 data.(headers{ii})(inc,1) = str2double(dataline{ii});
%             end
%         end
%         inc = inc + 1;
%     end
% end

