function plottfv_polygon(conf)

switch conf
    case 'poly'
        config_polygon;
    case 'tfv'
        config_polygon_tfv;
        case 'oxy'
        config_polygon_oxy;    
         case 'diag'
        config_polygon_diag;        
    case 'single'
        config_polygon_CEWH_Single;
    case 'ph'
        config_polygon_ph;
        
    case 'cewh'
        config_polygon_CEWH;

        
            case 'coorong'
        config_polygon_COORONG;
    case 'uber'
        config_polygon_uber;
    case '2011'
        config_polygon_geo_2011;
    case 'reporting'
        config_polygon_CEWH_Reporting;
    case 'test'
        config_polygon_CEWH_Reporting_test;
        
    case 'ON'
        config_polygon_CEWH_Reporting_ON;
    case 'mouth'
        config_polygon_CEWH_Reporting_Mouth;
    case 'goolwa'
        config_polygon_goolwa;
    case 'albert'
        config_polygon_albert;
    otherwise
        disp('Configuration not found');
        stop;
end

allvars = tfv_infonetcdf(ncfile(1).name);

shp = shaperead(polygon_file);

load Matfiles\target.mat;

% Load Field Data and Get site names
% field = load(['matfiles/',fielddata,'.mat']);
% fdata = field.(fielddata);
% sitenames = fieldnames(fdata);

% for i = 1:length(sitenames)
%     vars = fieldnames(fdata.(sitenames{i}));
%     X(i) = fdata.(sitenames{i}).(vars{1}).X;
%     Y(i) = fdata.(sitenames{i}).(vars{1}).Y;
% end

for mod = 1:length(ncfile)
    tdata = tfv_readnetcdf(ncfile(mod).name,'timestep',1);
    all_cells(mod).X = double(tdata.cell_X);
    all_cells(mod).Y = double(tdata.cell_Y);
    
    ttdata = tfv_readnetcdf(ncfile(mod).name,'names','D');
    d_data(mod).D = ttdata.D;
    
    
end



clear ttdata
%D = 0;

for var = 1:length(varname)
    
    savedir = [outputdirectory,varname{var},'/'];
    mkdir(savedir);
    
    
    
    for mod = 1:length(ncfile)
        disp(['Loading Model ',num2str(mod)]);
        loadname = varname{var};
        
        switch varname{var}
            
            case 'OXYPC'
                oxy = tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_AED_OXYGEN_OXY'});
                tra = tfv_readnetcdf(ncfile(mod).name,'names',{'TRACE_1'});
                
                raw(mod).data.OXYPC = tra.TRACE_1 ./ oxy.WQ_AED_OXYGEN_OXY;
                clear tra oxy
                
            case 'ON'
%                 TN =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_DIAG_TOT_TN'});
%                 AMM =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_NIT_AMM'});
%                 NIT =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_NIT_NIT'});
%                 GRN = tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_PHY_GRN'});
%                 raw(mod).data.ON = TN.WQ_DIAG_TOT_TN - AMM.WQ_NIT_AMM - NIT.WQ_NIT_NIT - (GRN.WQ_PHY_GRN .* 0.15);
                
                DON =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_OGM_DON'});
                PON =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_OGM_PON'});
                raw(mod).data.ON = DON.WQ_OGM_DON + PON.WQ_OGM_PON;

                clear TN AMM NIT
                
            case 'OP'
%                 TP =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_DIAG_TOT_TP'});
%                 FRP =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_PHS_FRP'});
%                 
%                 raw(mod).data.OP = TP.WQ_DIAG_TOT_TP - FRP.WQ_PHS_FRP;
                DON =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_OGM_DOP'});
                PON =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_OGM_POP'});
                raw(mod).data.OP = DON.WQ_OGM_DOP + PON.WQ_OGM_POP;
                clear TP FRP
                
            case 'TURB'
                SS1 =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_TRC_SS1'});
                POC =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_OGM_POC'});
                GRN =  tfv_readnetcdf(ncfile(mod).name,'names',{'WQ_PHY_GRN'});
                
                raw(mod).data.TURB = (SS1.WQ_TRC_SS1 .* 2.356)  + (GRN.WQ_PHY_GRN .* 0.1) + (POC.WQ_OGM_POC / 83.333333 .* 0.1);
                
                clear TP FRP
                
                sites = fieldnames(fdata);
                for bdb = 1:length(sites)
                    if isfield(fdata.(sites{bdb}),'WQ_DIAG_TOT_TURBIDITY')
                        fdata.(sites{bdb}).TURB = fdata.(sites{bdb}).WQ_DIAG_TOT_TURBIDITY;
                    end
                end
                
            otherwise
                
                raw(mod).data = tfv_readnetcdf(ncfile(mod).name,'names',{loadname});
        end
    end
    
    clear functions
    
    
    for site = 1:length(shp)
        
        isepa = 0;
        isdewnr = 0;
        
        dimc = [0.9 0.9 0.9]; % dimmest (lightest) color
        pred_lims = [0.01,0.25,0.5,0.75,0.99];
        num_lims = length(pred_lims);
        nn = (num_lims+1)/2;
        
        leg_inc = 1;
        
        
%         inpol = inpolygon(X,Y,shp(site).X,shp(site).Y);
%         
%         sss = find(inpol == 1);
%         
%         epa_leg = 0;
%         dewnr_leg = 0;
        
        
        for mod = 1:length(ncfile)
            
            data(mod) = tfv_getmodeldatapolygon(raw(mod).data,ncfile(mod).name,all_cells(mod).X,all_cells(mod).Y,shp(site).X,shp(site).Y,{loadname},d_data(mod).D);
            
            if isfield(data,'date')
                if mod == 1
                    %
                    fig = fillyy(data(mod).date,data(mod).pred_lim_ts(1,:),data(mod).pred_lim_ts(2*nn-1,:),dimc);hold on
                    set(fig,'DisplayName',[ncfile(mod).legend,' (Surface Range)']);
                    hold on
                    
                    for plim_i=2:(nn-1)
                        fig2 = fillyy(data(mod).date,data(mod).pred_lim_ts(plim_i,:),data(mod).pred_lim_ts(2*nn-plim_i,:),dimc.*0.9.^(plim_i-1));
                        set(fig2,'HandleVisibility','off');
                    end
                end
%                 if mod == 1
%                     if ~isempty(sss)
%                         
%                         for j = 1:length(sss)
%                             if isfield(fdata.(sitenames{sss(j)}),varname{var})
%                                 [xdata_d,ydata_d] = process_daily(fdata.(sitenames{sss(j)}).(varname{var}).Date,fdata.(sitenames{sss(j)}).(varname{var}).Data);
%                                 
%                                 [ydata_d,~] = tfv_Unit_Conversion(ydata_d,varname{var});
%                                 
%                                 if isfield(fdata.(sitenames{sss(j)}).(varname{var}),'Agency')
%                                     agency = fdata.(sitenames{sss(j)}).(varname{var}).Agency;
%                                 else
%                                     agency = 'EPA';
%                                 end
%                                 
%                                 %                     if strcmpi(agency,'DEWNR')
%                                 if dewnr_leg == 0
%                                     fp = plot(xdata_d,ydata_d,'color',def.fieldcolour{1},'marker',def.fieldsymbol{1},...
%                                         'linestyle',':','markersize',12,'displayname','Field');hold on
%                                     dewnr_leg = 1;
%                                 else
%                                     fp = plot(xdata_d,ydata_d,'color',def.fieldcolour{1},'marker',def.fieldsymbol{1},...
%                                         'linestyle',':','markersize',12,'HandleVisibility','off');hold on
%                                 end
%                                 %                     else
%                                 %                         if epa_leg == 0
%                                 %                             fp = plot(xdata_d,ydata_d,'+b','markersize',2,'displayname','EPA');hold on
%                                 %                             epa_leg = 1;
%                                 %                             disp('hi')
%                                 %                         else
%                                 %                             fp = plot(xdata_d,ydata_d,'+b','markersize',2,'HandleVisibility','off');hold on
%                                 %                         end
%                                 %                     end
%                             end
%                             
%                             
%                         end
%                     end
%                 end
                
                
                
                
                
                [xdata,ydata] = tfv_averaging(data(mod).date,data(mod).pred_lim_ts(3,:),def);
                
%                 xdata = data(mod).date;
%                 ydata = data(mod).pred_lim_ts(3,:);
                
                plot(xdata,ydata,ncfile(mod).colour{1},'linewidth',1.5,'DisplayName',[ncfile(mod).legend,' (Surface Median)']);hold on
                
                if addBottom
                    [xdata,ydata] = tfv_averaging(data(mod).date,data(mod).pred_lim_ts_b(3,:),def);
                    data(mod)
                    plot(xdata,ydata,ncfile(mod).colour{2},'linewidth',1.5,'DisplayName',[ncfile(mod).legend,' (Bottom Median)']);hold on
                end
                plotdate(1:length(xdata),mod) = xdata;
                plotdata(1:length(ydata),mod) = ydata;
                
            end
            
            
            
            % end
            
        end
        
%         if strcmpi({loadname},'H') == 1
%             plot(target.A4261156.Date,target.A4261156.Data);
%         end
        
        
        
        
        xlim([def.datearray(1) def.datearray(end)]);
        ylim([def.cAxis(var).value]);
        
        set(gca,'Xtick',def.datearray,...
            'XTickLabel',datestr(def.datearray,def.dateformat),...
            'FontSize',def.xlabelsize);
                %if sum(strcmp(valid_vars,varname{var})) > 0
%                     if isylabel
%         
% %                         if isempty(units)
% %                             units = fdata.(sitenames{site}).(varname{var}).Units;
% %                         end
%         
%                         ylabel([regexprep(fdata.(sitenames{site}).(varname{var}).Variable_Name,'_',' '),' (',...
%                             units,')'],...
%                             'FontSize',def.ylabelsize);
%                     end
                %end
        if istitled
            %             if sum(strcmp(valid_vars,varname{var})) > 0
            %                 if isfield(fdata.(sitenames{site}).(varname{var}),'Title')
            title([regexprep(shp(site).Name,'_',' ')],...
                'FontSize',def.titlesize,...
                'FontWeight','bold');
            %                 end
            %             else
            %                 if isfield(fdata.(sitenames{site}).SAL,'Title')
            %                     title(fdata.(sitenames{site}).SAL.Title,...
            %                         'FontSize',def.titlesize,...
            %                         'FontWeight','bold');
            %                 end
            %             end
        end
        if exist('islegend','var')
            if islegend
                leg = legend('show');
                set(leg,'location',def.legendlocation,'fontsize',def.legendsize);
            end
        else
            leg = legend('location',def.legendlocation);
            set(leg,'fontsize',def.legendsize);
        end
        
        %         if strcmp(varname{var},'WQ_AED_OXYGEN_OXY') == 1
        %
        %             plot([def.datearray(1) def.datearray(end)],[2 2],...
        %                 'color',[0.4 0.4 0.4],'linestyle','--');
        %
        %             plot([def.datearray(1) def.datearray(end)],[4 4],...
        %                 'color',[0.4 0.4 0.4],'linestyle','--');
        %
        %         end
        
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = def.dimensions(1);
        ySize = def.dimensions(2);
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        %             if isfield(fdata.(sitenames{site}).SAL,'Order')
        %                 final_sitename = [sprintf('%04d',fdata.(sitenames{site}).SAL.Order),'_',sitenames{site},'.png'];
        %             else
        %                 final_sitename = [sitenames{site},'.png'];
        %             end
        
        %        tVar = fieldnames(fdata.(sitenames{site}));
        
        %         if isfield(fdata.(sitenames{site}).(tVar{1}),'Order')
        %             final_sitename = [sprintf('%04d',fdata.(sitenames{site}).SAL.Order),'_',sitenames{site},'.eps'];
        %         else
        %
        %         end
        final_sitename = [sprintf('%04d',shp(site).Plot_Order),'_',shp(site).Name,'.eps'];
        finalname = [savedir,final_sitename];
        if exist('filetype','var')
            if strcmpi(filetype,'png');
                print(gcf,'-dpng',regexprep(finalname,'.eps','.png'),'-opengl');
                print(gcf,'-dpng',regexprep(finalname,'.eps','.png'),'-opengl');
            else
                %                     print(gcf,'-depsc2',finalname,'-painters');
                %                     print(gcf,'-dpng',regexprep(finalname,'.eps','.png'),'-opengl');
                
                %                 disp('eps');
                print(gcf,finalname,'-depsc2');
                disp('png');
                saveas(gcf,regexprep(finalname,'.eps','.png'));
            end
        else
            %                 print(gcf,'-depsc2',finalname,'-painters');
            %                 print(gcf,'-dpng',regexprep(finalname,'.eps','.png'),'-opengl');
            
            %             disp('eps');
            print(gcf,finalname,'-depsc2');
            disp('png');
            saveas(gcf,regexprep(finalname,'.eps','.png'));
        end
        
        tfv_export_conc(regexprep(finalname,'.eps','.csv'),plotdate,plotdata,ncfile);
        
        close all force
        
        clear data
        
    end
end


