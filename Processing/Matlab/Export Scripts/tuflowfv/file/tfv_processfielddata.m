function data = tfv_processfielddata(fdata,plotdepth,sitename,varname)
% Internal function to process the field data and return the structured
% type data.
if strcmpi(varname,'H') < 1
    
    data = [];
    uDate = unique(floor(fdata.(sitename).(varname).Date));
    
    uSurf = zeros(length(uDate),1);
    uBot = zeros(length(uDate),1);
    for jj = 1:length(uDate)
        
        mData = fdata.(sitename).(varname).Data(floor(fdata.(sitename).(varname).Date) ...
            == uDate(jj));
        mDepth = fdata.(sitename).(varname).Depth(floor(fdata.(sitename).(varname).Date) ...
            == uDate(jj));
        
        
        % Find Surface or Bottom
        for ii = 1:length(plotdepth)
            switch plotdepth{ii}
                case 'surface'
                    ss = mData(mDepth == max(mDepth));
                    if ~isempty(ss)
                        uSurf(jj,1) = ss(1);
                    else
                        uSurf(jj,1) = NaN;
                    end
                case 'bottom'
                    bb = mData(mDepth == min(mDepth));
                    if ~isempty(bb)
                        uBot(jj,1) = bb(1);
                    else
                        uBot(jj,1) = NaN;
                    end
                otherwise
                    disp('Not a Level Option');
                    disp('Only surface and bottom');
            end
        end
        
        
        % Add profile data
        data.profiles(jj).date  = uDate(jj);
        data.profiles(jj).depth = mDepth;
        data.profiles(jj).data  = mData;
        
    end
    
    data.surface = uSurf;
    data.bottom = uBot;
    data.date = uDate;
    
else
    data.surface = fdata.(sitename).(varname).Data;
    data.bottom = fdata.(sitename).(varname).Data;
    data.date = fdata.(sitename).(varname).Date;
    
end
