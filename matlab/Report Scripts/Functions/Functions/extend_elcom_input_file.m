function extend_elcom_input_file(filename,outfile,sdate,edate,srange,erange)
% A simple function to take an existing input file and extend it through
% the range of startdate to enddate, based on data from the range srange to
% erange.



[data,data_type,bcset_no,n_data,file_type,ierr] = readELCOMinputFile(filename);

for ii = 1:length(data_type)
    if strcmp(data_type{ii},'TIME') == 1
        nyear = floor(data(:,ii) / 1000);
        nday = rem(data(:,ii),1000);
        old.(data_type{ii}) = datenum(nyear,1,nday);
    else
        old.(data_type{ii}) = data(:,ii);
    end
end

% Get the range
ss = find(old.TIME >= srange & old.TIME < erange);

% Get the inc
inc = old.TIME(ss(3)) - old.TIME(ss(2));

datearray = [sdate:inc:edate];

mTIME = old.TIME(ss) + (365*2);

[int.TIME,ind] = unique(mTIME);

for i = 1:length(data_type)
    
    if strcmpi(data_type{i},'TIME') == 0
        
        mData = old.(data_type{i})(ss);
        int.(data_type{i}) = mData(ind);
        int1.(data_type{i}) = interp1(int.TIME,int.(data_type{i}),datearray);
        clear mData;
    end
    
end

olddate = matlab2CWRdate(old.TIME);
newdate = matlab2CWRdate(datearray);

final.TIME = [olddate newdate];

for i = 1:length(data_type)
    
    if strcmpi(data_type{i},'TIME') == 0
        
        final.(data_type{i}) = [old.(data_type{i});int1.(data_type{i})'];
        
    end
end

fid = fopen(outfile,'wt');

fid2 = fopen(filename,'rt');

isnum = 0;

while ~isnum
    
    line = fgetl(fid2);
    
    [~,linespt] = regexp(line,'\s','match','split');
    
    if strcmpi(linespt{1},'TIME') == 0
        fprintf(fid,'%s\n',line);
    else
                fprintf(fid,'%s\n',line);

        isnum = 1;
    end
end

fclose(fid2);




for i = 1:length(final.TIME)
    for j = 1:length(data_type)
        if j < length(data_type)
            fprintf(fid,'%7.4f ',final.(data_type{j})(i));
        else
            fprintf(fid,'%7.4f\n',final.(data_type{j})(i));
        end
    end
end

fclose(fid);

